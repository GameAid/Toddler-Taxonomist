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
#import "SoundManager.h"

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
                            @"correct_1.mp3",
                            @"correct_2.mp3",
                            @"correct_3.mp3",
                            @"correct_4.mp3",
                            @"correct_5.mp3",
                            @"correct_6.mp3",
                            @"correct_7.mp3",
                            @"correct_8.mp3",
                            @"correct_9.mp3",
                            @"correct_10.mp3",
                            nil];
        
        _soundsIncorrect = [NSArray arrayWithObjects:
                            @"incorrect_1.mp3",
                            @"incorrect_2.mp3",
                            @"incorrect_3.mp3",
                            @"incorrect_4.mp3",
                            @"incorrect_5.mp3",
                            @"incorrect_6.mp3",
                            @"incorrect_7.mp3",
                            @"incorrect_8.mp3",
                            @"incorrect_9.mp3",
                            @"incorrect_10.mp3",
                            nil];
        
        for (NSString *str in _soundsCorrect) {
            [[SimpleAudioEngine sharedEngine] preloadEffect:str];
        }
        
        for (NSString *str in _soundsIncorrect) {
            [[SimpleAudioEngine sharedEngine] preloadEffect:str];
        }
        
        // Establish picture locations
        [self establishPictureLocations];
        
        // Default difficulty mode
        QuestionDifficulty difficulty = [[[[Settings settings] boardSettings] objectForKey:@"boardStartDifficulty"] intValue];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(resetPicMode:)
                                                     name:@"setPictureMode"
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(delayFlagUpdateTextures:)
                                                     name:@"clearTextureCache"
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(announceCorrectStreak:)
                                                     name:@"correctStreak"
                                                   object:nil];
        
        [self setFirstGuess:YES];
        [self setQuestionWithDifficulty:difficulty orQuestion:nil];
        [self scheduleUpdate];
        
        
        
        
    }
    return self;
}

#pragma mark -
#pragma mark Correct Streak Celebrations

- (void) announceCorrectStreak:(NSNotification *)notification
{
    CCLOG(@"announceCorrectStreak of %i in BoardLayer", [[[notification userInfo] objectForKey:@"correctStreak"] intValue]);
}


- (void) delayFlagUpdateTextures:(NSNotification *)notification
{
    [self performSelector:@selector(flagUpdateTextures)
               withObject:nil
               afterDelay:1.0f];
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
        NSAssert(qd != DifficultyINVALID, @"There is no newQuestion and question difficulty is Invalid");
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
        
        t.position = truePoint;
        
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
        CCLabelBMFont *questionLabel = [CCLabelBMFont labelWithString:questionText fntFile:@"audimat_36_white.fnt"];
        questionLabel.position = ccp([[CCDirector sharedDirector] winSize].width * 0.5, 64);
        [self addChild:questionLabel z:0 tag:7777];
        
        CCSprite *finger = [CCSprite spriteWithFile:@"finger.png"];
        [finger setAnchorPoint:ccp(0,0.5)];
        [finger setPosition:ccp(questionLabel.position.x + 5 + (questionLabel.contentSize.width * 0.5), questionLabel.position.y)];
        [self addChild:finger z:0 tag:12121];
        
    }
    
    // Set flag to turn on touch enabled
    [self setNeedsTouch:YES];
    
    // Play question audio
    [[SoundManager manager] playNext:[q questionSoundString] withUnload:NO];
    
}

- (void) proceedToNextQuestion
{
    [[AnimalCatalogue animalCatalogue] resetCatalogue];
    Question *newQ = [[Question alloc] initContinuingFromQuestion:[self activeQuestion] correctOnFirstGuess:[self firstGuess]];
    [self setQuestionWithDifficulty:DifficultyINVALID orQuestion:newQ];
}

#pragma mark Touch events
-(CGPoint) locationFromTouch:(UITouch*)touch
{
	CGPoint touchLocation = [touch locationInView: [touch view]];
	return [[CCDirector sharedDirector] convertToGL:touchLocation];
}

-(CGPoint) locationFromTouches:(NSSet*)touches
{
	return [self locationFromTouch:[touches anyObject]];
}


- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touchLocGL = [self locationFromTouch:[touches anyObject]];
    
    // CCNode *qtext = [self getChildByTag:7777];
    CGRect qRect = CGRectMake(0, 0, [CCDirector sharedDirector].winSize.width, 128);
    
    if (CGRectContainsPoint(qRect, touchLocGL)) {
        [[SoundManager manager] playNow:[_activeQuestion questionSoundString] andEmptyQueue:YES withUnload:NO];
        return;
    }
    
    
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
    if (_firstGuess) {
        [[Settings settings] reportCorrectAt:_activeQuestion.qDifficulty];
    }    
    
    [self setTouchEnabled:NO];
    
    float delay;
    
    // Yes!
    delay =  [[SoundManager manager] playNow:[_soundsCorrect objectAtIndex:arc4random()%[_soundsCorrect count]]];
    delay += [[SoundManager manager] playNext:[tile confirmAnswerSoundString]];

    [self performSelector:@selector(proceedToNextQuestion) withObject:nil afterDelay:delay];
}

- (void) incorrectAnswer:(Tile *)tile
{
    if (_firstGuess) {
        [[Settings settings] reportIncorrectAt:_activeQuestion.qDifficulty];
    }
    
    [self setFirstGuess:NO];
    [tile setOpacity:75];
    OrganismDetails *details = [[OrganismDetails alloc] initWithColor:ccc4(0, 0, 0, 255) andOrganism:[tile organism]];
    [details setBoardLayer:self];
    [self addChild:details z:10 tag:TagOrganismDetails];
    [self setTouchEnabled:NO];
    [self setDetailPanelClosed:NO];
    
    if (![tile alreadyTapped]) {
        // The "incorrect answer" sound -- only played on the initial selection of a tile as incorrect
        [[SoundManager manager] playNow:[_soundsIncorrect objectAtIndex:arc4random()%[_soundsIncorrect count]]];
        [tile setAlreadyTapped:YES];
    }
    
    [[SoundManager manager] playNext:[tile wrongAnswerSoundString]];
    
}

- (void) playWrongAnswerSoundString:(NSString *)wrongAnswerString
{
    if (!_detailPanelClosed) {
        [[SoundManager manager] playNext:wrongAnswerString];
    }
}


#pragma mark Callbacks
- (void)closeDetails
{
    [self setDetailPanelClosed:YES];
    [self setTouchEnabled:YES];
    [self removeChildByTag:TagOrganismDetails cleanup:YES];

    [[SoundManager manager] playNow:[_activeQuestion questionSoundString] andEmptyQueue:YES withUnload:NO];
    [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.25f];

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

@end
