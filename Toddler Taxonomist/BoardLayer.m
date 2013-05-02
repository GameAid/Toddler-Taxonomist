//
//  BoardLayer.m
//  Toddler Taxonomist
//
//  Created by Clay Heaton on 4/16/13.
//  Copyright 2013 The Perihelion Group. All rights reserved.
//

#import "BoardLayer.h"
#import "Settings.h"
#import "Question.h"
#import "Tile.h"
#import "AnimalCatalogue.h"
#import "Organism.h"
#import "OrganismDetails.h"

@implementation BoardLayer
@synthesize picturesArray_1, picturesArray_2, picturesArray_4, picturesArray_8, picturesArray_40;


+(CCScene *) scene
{
	CCScene *scene         = [CCScene node];
	BoardLayer *boardLayer = [BoardLayer node];
	[scene addChild: boardLayer];
	return scene;
}

- (id) init {
    self = [super init];
    if (self) {

        _tiles = [[NSMutableArray alloc] init];
        
        [self setTouchEnabled:YES];
        [self setNeedsTouch:NO];
        [self setRandomPrefix:arc4random()%4000 + 1234];
        [self setCorrectSoundDelay:1.0f];
        
        
        [self setDetailPanelClosed:YES];
        [self setNeedToClearTextureCache:NO];
        
        // Initialize sound arrays
        // Load sounds
        _soundsCorrect   = [NSArray arrayWithObjects:
                            [[NSBundle mainBundle] pathForResource:@"correct_1" ofType:@"mp3"],
                            [[NSBundle mainBundle] pathForResource:@"correct_2" ofType:@"mp3"],
                            [[NSBundle mainBundle] pathForResource:@"correct_3" ofType:@"mp3"],
                            [[NSBundle mainBundle] pathForResource:@"correct_4" ofType:@"mp3"],
                            [[NSBundle mainBundle] pathForResource:@"correct_5" ofType:@"mp3"],
                            [[NSBundle mainBundle] pathForResource:@"correct_6" ofType:@"mp3"],
                            [[NSBundle mainBundle] pathForResource:@"correct_7" ofType:@"mp3"],
                            [[NSBundle mainBundle] pathForResource:@"correct_8" ofType:@"mp3"],
                            [[NSBundle mainBundle] pathForResource:@"correct_9" ofType:@"mp3"],
                            [[NSBundle mainBundle] pathForResource:@"correct_10" ofType:@"mp3"],
                            nil];
        
        _soundsIncorrect = [NSArray arrayWithObjects:
                            [[NSBundle mainBundle] pathForResource:@"incorrect_1" ofType:@"mp3"],
                            [[NSBundle mainBundle] pathForResource:@"incorrect_2" ofType:@"mp3"],
                            [[NSBundle mainBundle] pathForResource:@"incorrect_3" ofType:@"mp3"],
                            [[NSBundle mainBundle] pathForResource:@"incorrect_4" ofType:@"mp3"],
                            [[NSBundle mainBundle] pathForResource:@"incorrect_5" ofType:@"mp3"],
                            [[NSBundle mainBundle] pathForResource:@"incorrect_6" ofType:@"mp3"],
                            [[NSBundle mainBundle] pathForResource:@"incorrect_7" ofType:@"mp3"],
                            [[NSBundle mainBundle] pathForResource:@"incorrect_8" ofType:@"mp3"],
                            [[NSBundle mainBundle] pathForResource:@"incorrect_9" ofType:@"mp3"],
                            [[NSBundle mainBundle] pathForResource:@"incorrect_10" ofType:@"mp3"],
                            nil];
        
        for (NSString *str in _soundsCorrect) {
            [[SimpleAudioEngine sharedEngine] preloadEffect:str];
        }
        
        for (NSString *str in _soundsIncorrect) {
            [[SimpleAudioEngine sharedEngine] preloadEffect:str];
        }
        
        // TODO: Remove for final build
        // [self createRandomColors];
        
        // Establish picture locations
        [self establishPictureLocations];
        
        // Default difficulty mode
        QuestionDifficulty difficulty = [[[[Settings settings] boardSettings] objectForKey:@"boardStartDifficulty"] intValue];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetPicMode:)       name:@"setPictureMode"    object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(delayFlagUpdateTextures:) name:@"clearTextureCache" object:nil];
        
        [self setFirstGuess:YES];
        [self setQuestionWithDifficulty:difficulty orQuestion:nil];
        [self scheduleUpdate];
    }
    return self;
}

- (void) delayFlagUpdateTextures:(NSNotification *)notification
{
    [self performSelector:@selector(flagUpdateTextures) withObject:nil afterDelay:1.0f];
}

- (void) flagUpdateTextures
{
    [self setNeedToClearTextureCache:YES];
}

- (void) resetPicMode:(NSNotification *)notification
{
    // CCLOG(@"==> Setting the picture mode in BoardLayer by notification from Question.");
    NSDictionary *info = [notification userInfo];
    PictureMode pm = [[info objectForKey:@"pictureMode"] intValue];
    [self setPictureMode:pm];
}

-(void) update:(ccTime)delta
{
    if ([self needToClearTextureCache]) {
        CCLOG(@"==> Clearing textures after notification from Question (Difficulty Change)");
        [[CCTextureCache sharedTextureCache] removeUnusedTextures];
        [self setNeedToClearTextureCache:NO];
    }
    
    if ([self needsTouch]) {
        [self setTouchEnabled:YES];
        [self setNeedsTouch:NO];
    }
}

- (void) setQuestionWithDifficulty:(QuestionDifficulty)qd orQuestion:(Question *)newQuestion
{
    CCLOG(@"%@", NSStringFromSelector(_cmd));
    [self setFirstGuess:YES];
    
    // Reset the catalogue
    [[AnimalCatalogue animalCatalogue] resetCatalogue];
    
    Question *q;
    
    if (!newQuestion) {
        q = [[Question alloc] initWithDifficultyMode:qd];
    } else {
        q = newQuestion;
    }
    
    // Clear the cache
    [self setActiveQuestion:nil];
    [self setActiveQuestion:q];
    
    // Try removing child tiles
    if ([_tiles count] > 0) {
        for (Tile *t in _tiles) {
            [self removeChild:t];
        }
    }
    
    _tiles = [q answerTiles];
    _showInfoPanel = NO;
    
    switch (_pictureMode) {
        case PictureModePictures_01:
            _positionArray = picturesArray_1;
            _showInfoPanel = YES;
            break;
            
        case PictureModePictures_02:
            _positionArray = picturesArray_2;
            break;
            
        case PictureModePictures_04:
            _positionArray = picturesArray_4;
            break;
            
        case PictureModePictures_08:
            _positionArray = picturesArray_8;
            break;
            
        case PictureModePictures_40:
            _positionArray = picturesArray_40;
            break;
            
        default:
            break;
    }
    [self removeAllChildrenWithCleanup:YES];
    
    for (int i = 0; i < [_tiles count]; i++) {
        Tile *t = [_tiles objectAtIndex:i];
        
        CGRect  rect = [[_positionArray objectAtIndex:i] CGRectValue];
        CGPoint rectOrgin = rect.origin;
        CGPoint truePoint = ccpAdd(rectOrgin, ccp(rect.size.width * 0.5, rect.size.height * 0.5));
        
        t.position = truePoint;//[[positionArray objectAtIndex:i] CGRectValue].origin;
        
        t.visible = YES;
        int tileTag = [[NSString stringWithFormat:@"%i%i", _randomPrefix, i] intValue];
        
        [self addChild:t z:1 tag:tileTag];
    }
    
    
    if (_showInfoPanel) {
        NSString *orgName = [[[_tiles objectAtIndex:0] organism] specificName];
        CCLabelBMFont *nameLabel = [CCLabelBMFont labelWithString:orgName fntFile:@"audimat_45_white.fnt"];
        nameLabel.position = ccp([[CCDirector sharedDirector] winSize].width * 0.5, 64);
        [self addChild:nameLabel];
        
    } else {
        NSString *questionText = [q questionString];
        //CCLOG(@"question string: %@", questionText);
        CCLabelBMFont *questionLabel = [CCLabelBMFont labelWithString:questionText fntFile:@"audimat_36_white.fnt"];
        questionLabel.position = ccp([[CCDirector sharedDirector] winSize].width * 0.5, 64);
        [self addChild:questionLabel];
    }
    
    // Set flag to turn on touch enabled
    [self setNeedsTouch:YES];
    
    // Play question
    [[SimpleAudioEngine sharedEngine] playEffect:[q questionSoundString]];
    
    // In the event a delay is needed to play the question; shouldn't be needed
    // because the program no longer generates the next question until the
    // Yes! sounds plays from the previous question
    
    /*
    [[SimpleAudioEngine sharedEngine] performSelector:@selector(playEffect:)
                                           withObject:[q questionSoundString]
                                           afterDelay:[self correctSoundDelay]];
     */
    
}

- (void) proceedToNextQuestion
{
    //CCLOG(@"%@", NSStringFromSelector(_cmd));
    [[AnimalCatalogue animalCatalogue] resetCatalogue];
    Question *newQ = [[Question alloc] initContinuingFromQuestion:[self activeQuestion] correctOnFirstGuess:[self firstGuess]];
    [self setQuestionWithDifficulty:nil orQuestion:newQ];
}

#pragma mark Touch events
-(CGPoint) locationFromTouch:(UITouch*)touch
{
    //CCLOG(@"%@", NSStringFromSelector(_cmd));
	CGPoint touchLocation = [touch locationInView: [touch view]];
	return [[CCDirector sharedDirector] convertToGL:touchLocation];
}

-(CGPoint) locationFromTouches:(NSSet*)touches
{
    //CCLOG(@"%@", NSStringFromSelector(_cmd));
	return [self locationFromTouch:[touches anyObject]];
}


- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touchLocGL = [self locationFromTouch:[touches anyObject]];
    
    for (int i = 0; i < [_positionArray count]; i++) {
        CGRect rect = [[_positionArray objectAtIndex:i] CGRectValue];
        
        if (CGRectContainsPoint(rect, touchLocGL)) {
            Tile *t = [[_activeQuestion answerTiles] objectAtIndex:i];
            if ([t isAnswer]) {
                [self correctAnswer:t];
            } else {
                [self incorrectAnswer:t];
            }
            break;
        }
    }
}

- (void) correctAnswer:(Tile *)tile
{
    [self setTouchEnabled:NO];
    
    NSString *correctSoundString = [_soundsCorrect objectAtIndex:arc4random()%[_soundsCorrect count]];
    CDSoundSource *correctSource = [[SimpleAudioEngine sharedEngine] soundSourceForFile:correctSoundString];
    
    CDSoundSource *confirmSource = [[SimpleAudioEngine sharedEngine] soundSourceForFile:[tile confirmAnswerSoundString]];
    
    // Stop question sound
    [[SimpleAudioEngine sharedEngine] stopEffect:_soundPlaying];
    
    // Yes!
    [[SimpleAudioEngine sharedEngine] playEffect:correctSoundString];
    
    // Confirm the correct answer
    [[SimpleAudioEngine sharedEngine] performSelector:@selector(playEffect:)
                                           withObject:[tile confirmAnswerSoundString]
                                           afterDelay:[correctSource durationInSeconds]];
    
    float totalDelay = [correctSource durationInSeconds] + [confirmSource durationInSeconds];
    
    [self performSelector:@selector(proceedToNextQuestion) withObject:nil afterDelay:totalDelay];
}

- (void) incorrectAnswer:(Tile *)tile
{
    [self setFirstGuess:NO];
    [tile setOpacity:75];
    OrganismDetails *details = [[OrganismDetails alloc] initWithColor:ccc4(0, 0, 0, 255) andOrganism:[tile organism]];
    [details setBoardLayer:self];
    [self addChild:details z:10 tag:TagOrganismDetails];
    [self setTouchEnabled:NO];
    [self setDetailPanelClosed:NO];
    
    if (![tile alreadyTapped]) {
        NSString *noSoundString = [_soundsIncorrect objectAtIndex:arc4random()%[_soundsIncorrect count]];
        CDSoundSource *noSource = [[SimpleAudioEngine sharedEngine] soundSourceForFile:noSoundString];
        float noDuration        = noSource.durationInSeconds + 0.07f;
        
        [[SimpleAudioEngine sharedEngine] playEffect:noSoundString];
        
        // TODO: Doesn't use scientific name
        [self performSelector:@selector(playWrongAnswerSoundString:) withObject:[tile wrongAnswerSoundString] afterDelay:noDuration];
        
    } else {
        
        // This works great
        _soundPlaying = [[SimpleAudioEngine sharedEngine] playEffect:[tile wrongAnswerSoundString]];
    }
    
    if (![tile alreadyTapped]) {
         [tile setAlreadyTapped:YES];
    }
}

- (void) playWrongAnswerSoundString:(NSString *)wrongAnswerString
{
    if (!_detailPanelClosed) {
        _soundPlaying = [[SimpleAudioEngine sharedEngine] playEffect:wrongAnswerString];
    }
}

/*
- (void) ccTouchesMoved:(NSSet*)touches withEvent:(UIEvent *)event
{
    //CCLOG(@"%@", NSStringFromSelector(_cmd));
}
 */

/*
-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	CCLOG(@"%@", NSStringFromSelector(_cmd));
}
 */

#pragma mark Callbacks
- (void)closeDetails
{
    [self setDetailPanelClosed:YES];
    [self setTouchEnabled:YES];
    [self removeChildByTag:TagOrganismDetails cleanup:YES];
    
    // TODO: Possible delay needed
    // Possibly need to introduce a delay here in the event that somebody taps the red x
    // before the wrong answer sound is playing

    [[SimpleAudioEngine sharedEngine] stopEffect:_soundPlaying];
    
    _soundPlaying = [[SimpleAudioEngine sharedEngine] playEffect:[_activeQuestion questionSoundString]];
}

#pragma mark SETUP
- (void) establishPictureLocations
{
    CCLOG(@"%@", NSStringFromSelector(_cmd));
    float unit = 128;
    float xVal, yVal;
    
    // One picture
    xVal = 0;
    yVal = unit;
    
    // _picturesArray_01 must have a rect defined for the descriptive area
    
    NSArray *p_01 = [NSArray arrayWithObjects:
                     [NSValue valueWithCGRect:CGRectMake(xVal,              yVal, unit * 5, unit * 5)],
                     [NSValue valueWithCGRect:CGRectMake(xVal + (unit * 5), yVal, unit * 3, unit * 5)],
                     nil];
    
    [self setPicturesArray_1:p_01];
    
    NSArray *p_02 = [NSArray arrayWithObjects:
                     [NSValue valueWithCGRect:CGRectMake(xVal,              yVal, unit * 4, unit * 5)],
                     [NSValue valueWithCGRect:CGRectMake(xVal + (unit * 4), yVal, unit * 4, unit * 5)],
                     nil];
    
    [self setPicturesArray_2:p_02];
    
    
    NSArray *p_04 = [NSArray arrayWithObjects:
                     [NSValue valueWithCGRect:CGRectMake(xVal,              yVal,                unit * 4, unit * 2.5)],
                     [NSValue valueWithCGRect:CGRectMake(xVal             , yVal + (unit * 2.5), unit * 4, unit * 2.5)],
                     [NSValue valueWithCGRect:CGRectMake(xVal + (unit * 4), yVal,                unit * 4, unit * 2.5)],
                     [NSValue valueWithCGRect:CGRectMake(xVal + (unit * 4), yVal + (unit * 2.5), unit * 4, unit * 2.5)],
                     nil];
    [self setPicturesArray_4:p_04];
    
    NSArray *p_08 = [NSArray arrayWithObjects:
                     [NSValue valueWithCGRect:CGRectMake(xVal,              yVal,                unit * 2, unit * 2.5)],
                     [NSValue valueWithCGRect:CGRectMake(xVal             , yVal + (unit * 2.5), unit * 2, unit * 2.5)],
                     
                     [NSValue valueWithCGRect:CGRectMake(xVal + (unit * 2), yVal,                unit * 2, unit * 2.5)],
                     [NSValue valueWithCGRect:CGRectMake(xVal + (unit * 2), yVal + (unit * 2.5), unit * 2, unit * 2.5)],
                     
                     [NSValue valueWithCGRect:CGRectMake(xVal + (unit * 4), yVal,                unit * 2, unit * 2.5)],
                     [NSValue valueWithCGRect:CGRectMake(xVal + (unit * 4), yVal + (unit * 2.5), unit * 2, unit * 2.5)],
                     
                     [NSValue valueWithCGRect:CGRectMake(xVal + (unit * 6), yVal,                unit * 2, unit * 2.5)],
                     [NSValue valueWithCGRect:CGRectMake(xVal + (unit * 6), yVal + (unit * 2.5), unit * 2, unit * 2.5)],
                     nil];
    [self setPicturesArray_8:p_08];
    
    NSMutableArray *p_40 = [[NSMutableArray alloc] initWithCapacity:40];
    
    for (int i = 0; i < 8; i++) {
        for(int j = 0; j < 5; j++){
            NSValue *v = [NSValue valueWithCGRect:CGRectMake(xVal + (unit * i), yVal + (unit * j), unit, unit)];
            [p_40 addObject:v];
        }
    }
    [self setPicturesArray_40:p_40];
    
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          picturesArray_1, @"1",
                          picturesArray_2, @"2",
                          picturesArray_4, @"4",
                          picturesArray_8, @"8",
                          picturesArray_40, @"40",
                          nil];
    
    [self setPicArraysByNumber:dict];
    
    CCLOG(@"Picture Locations Established");
    
}

#pragma mark TEST METHODS

- (void) draw {
    
    //[self drawInfoArea];
    //[self drawPicturesArray:[NSString stringWithFormat:@"%i", _pictureMode]];
}

- (void) drawInfoArea
{
    CCLOG(@"%@", NSStringFromSelector(_cmd));
    CGRect infoArea = CGRectMake(0, 0, [[CCDirector sharedDirector] winSize].width, 255 * _sizeAdjustmentFactor);
    [self drawRectFromRect:infoArea withColors:[_randomColorArray objectAtIndex:0]];
}

- (void) drawPicturesArray:(NSString *)num
{
    NSArray *array = [_picArraysByNumber objectForKey:num];
    
    for (int i = 0; i < [array count]; i++) {
        CGRect rect = [[array objectAtIndex:i] CGRectValue];
        NSArray *colors = [_randomColorArray objectAtIndex:i + 1];
        
        [self drawRectFromRect:rect withColors:colors];
        
    }
}

// TODO: Create arrays of non-random colors that fit themes: shades of blue, shades of orange, shades of green, etc.
- (void) createRandomColors
{
    // Set up random color array for testing
    _randomColorArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 60; i++) {
        NSArray *arr = [NSArray arrayWithObjects:
                        [NSNumber numberWithInt:arc4random() % 255],
                        [NSNumber numberWithInt:arc4random() % 255],
                        [NSNumber numberWithInt:arc4random() % 255],
                        nil];
        [_randomColorArray addObject:arr];
    }
    CCLOG(@"Random colors created");
}

- (void) drawCircleAtPoint:(CGPoint)pt withColors:(NSArray *)colors
{
    glLineWidth(3);
    ccDrawColor4B(255, 255, 255, 255);
    ccDrawCircle(pt, 50, CC_DEGREES_TO_RADIANS(90), 32, NO);
}

- (void) drawRectFromRect:(CGRect)rect withColors:(NSArray *)colors
{
    int col1;
    int col2;
    int col3;

    if (!colors) {
        col1 = 255;
        col2 = 255;
        col3 = 255;
    } else {
        col1 = [[colors objectAtIndex:0] integerValue];
        col2 = [[colors objectAtIndex:1] integerValue];
        col3 = [[colors objectAtIndex:2] integerValue];
    }
    
    // glLineWidth(0); ERROR
    //ccDrawColor4B(col1,col2,col3,255);
    
    ccColor4B c4Bcolor = ccc4(col1, col2, col3, 255);
    ccColor4F c4Fcolor = ccc4FFromccc4B(c4Bcolor);
               
    ccDrawSolidRect(rect.origin, CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height), c4Fcolor);
}

@end
