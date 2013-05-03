//
//  Question.m
//  Toddler Taxonomist
//
//  Created by Clay Heaton on 4/18/13.
//  Copyright (c) 2013 The Perihelion Group. All rights reserved.
//

#import "Question.h"
#import "BoardLayer.h"
#import "AnimalCatalogue.h"
#import "Settings.h"
#import "Tile.h"
#import "NSMutableArray+Shuffling.h"
#import "Organism.h"

@implementation Question

- (id)initWithPictureMode:(PictureMode)mode
{
    self = [super init];
    if (self) {
        _answerTiles = [[NSMutableArray alloc] init];
        [self generateAnswersForPictureMode:mode];
    }
    return self;
}

- (id)initWithDifficultyMode:(QuestionDifficulty)difficulty
{
    self = [super init];
    if (self) {
        _answerTiles = [[NSMutableArray alloc] init];
        
        // Determine PictureMode and send notification
        PictureMode picMode = [self determinePicMode:difficulty];
        
        NSDictionary *picDict = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:picMode] forKey:@"pictureMode"];
        
        // This should inform BoardLayer to use the dispatched pictureMode
        [[NSNotificationCenter defaultCenter] postNotificationName:@"setPictureMode" object:nil userInfo:picDict];
        [self setQPicMode:picMode];
        [self setQDifficulty:difficulty];
        
        [self generateAnswersForPictureMode:picMode];
    }
    return self;
}

- (id)initContinuingFromQuestion:(Question *)oldQuestion correctOnFirstGuess:(BOOL)firstGuess
{
    self = [super init];
    if (self) {
        CCLOG(@"");
        CCLOG(@"----------------------------------------");
        
        if (firstGuess) {
            [self setQuestionNumberInSequence:[oldQuestion questionNumberInSequence] + 1];
        } else {
            [self setQuestionNumberInSequence:[oldQuestion questionNumberInSequence] - 1];
        }
        
        CCLOG(@"Question questionNumberInSequence: %i", [self questionNumberInSequence]);
        
        _answerTiles = [[NSMutableArray alloc] init];
        
        // Determine PictureMode and send notification
        [self determineDifficultyAndPicModeFrom:oldQuestion];
        CCLOG(@"Question difficulty:   %i", [self qDifficulty]);
        CCLOG(@"Question picture mode: %i", [self qPicMode]);
        
        PictureMode picMode = [self qPicMode];
        NSDictionary *picDict = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:picMode] forKey:@"pictureMode"];
        
        // This should inform BoardLayer to use the dispatched pictureMode
        [[NSNotificationCenter defaultCenter] postNotificationName:@"setPictureMode" object:nil userInfo:picDict];
        
        [self generateAnswersForPictureMode:picMode];
        
        oldQuestion = nil;
        
        CCLOG(@"----------------------------------------");
        CCLOG(@"");
    }
    return self;
}

- (void) sendTextureClearNotification
{
    // Sending a notification so that we clear the cache after the next question is loaded (on update in BoardLayer)
    [[NSNotificationCenter defaultCenter] postNotificationName:@"clearTextureCache" object:nil];
}

- (void) determineDifficultyAndPicModeFrom:(Question *)oldQuestion
{
    // Just browsing...
    if ([oldQuestion qPicMode] == PictureModePictures_01) {
        [self setQPicMode:PictureModePictures_01];
        [self setQDifficulty:DifficultyBrowse];
        [self setQuestionNumberInSequence:0];
        return;
    }
    
    // Playing
    if ([self questionNumberInSequence] > 4) {
        if ([oldQuestion qPicMode] == PictureModePictures_40) {
            // Increment difficulty level and reset to PictureModePictures_02
            
            [[AnimalCatalogue animalCatalogue] resetUsedOrganisms];
            
            if ([oldQuestion qDifficulty] == DifficultyExtreme) {
                // At extreme difficulty with 40 pictures -- keep it the same
                [self setQPicMode:[oldQuestion qPicMode]];
                [self setQDifficulty:[oldQuestion qDifficulty]];
                return;
                
            } else {
                [self setQDifficulty:[oldQuestion qDifficulty] + 1];
                [self setQPicMode:PictureModePictures_02];
                [self setQuestionNumberInSequence:0];
                [self sendTextureClearNotification];
                return;
            }
            
        } else {
            
            // Increment pictureMode but keep same difficulty level
            [self setQDifficulty:[oldQuestion qDifficulty]];
            switch ([oldQuestion qPicMode]) {
                    
                case PictureModePictures_02:
                    [self setQPicMode:PictureModePictures_04];
                    [self sendTextureClearNotification];
                    break;
                    
                case PictureModePictures_04:
                    [self setQPicMode:PictureModePictures_08];
                    [self sendTextureClearNotification];
                    break;
                    
                case PictureModePictures_08:
                    [self setQPicMode:PictureModePictures_40];
                    [self sendTextureClearNotification];
                    break;
                    
                default:
                    CCLOG(@"We shouldn't be here...");
                    break;
            }
            [self setQuestionNumberInSequence:0];
            return;
        }
    } else if ([self questionNumberInSequence] < -4) {
        if ([oldQuestion qPicMode] == PictureModePictures_02) {
            // Decrement difficulty level and reset to PictureModePictures_08
            
            [[AnimalCatalogue animalCatalogue] resetUsedOrganisms];
            
            if ([oldQuestion qDifficulty] == DifficultyEasy) {
                // At the easiest level -- leave it there.
                [self setQDifficulty:[oldQuestion qDifficulty]];
                [self setQPicMode:[oldQuestion qPicMode]];
                [self setQuestionNumberInSequence:0];
                return;
            } else {
                [self setQDifficulty:[oldQuestion qDifficulty] - 1];
                [self setQPicMode:PictureModePictures_08];
                [self setQuestionNumberInSequence:0];
                [self sendTextureClearNotification];
                return;
            }
            
            
        } else {
            // Decrement pictureMode but keep same difficulty level
            
            [self setQDifficulty:[oldQuestion qDifficulty]];
            switch ([oldQuestion qPicMode]) {
                case PictureModePictures_40:
                    [self setQPicMode:PictureModePictures_08];
                    [self setQuestionNumberInSequence:0];
                    [self sendTextureClearNotification];
                    return;
                    break;
                case PictureModePictures_08:
                    [self setQPicMode:PictureModePictures_04];
                    [self setQuestionNumberInSequence:0];
                    [self sendTextureClearNotification];
                    return;
                    break;
                case PictureModePictures_04:
                    [self setQPicMode:PictureModePictures_02];
                    [self setQuestionNumberInSequence:0];
                    [self sendTextureClearNotification];
                    return;
                    break;
                default:
                    CCLOG(@"We shouldn't be here...");
                    break;
            }
            
        }
    } else {
        // Keep the same picture model and difficulty
        [self setQDifficulty:[oldQuestion qDifficulty]];
        [self setQPicMode:[oldQuestion qPicMode]];
        return;
    }
}

- (PictureMode)determinePicMode:(QuestionDifficulty)d
{
    switch (d) {
        case DifficultyBrowse:
            return PictureModePictures_01;
            break;
            
        case DifficultyEasy:
            return PictureModePictures_02;
            break;
            
        case DifficultyMedium:
            return PictureModePictures_04;
            break;
            
        case DifficultyHard:
            return PictureModePictures_08;
            break;
            
            
        case DifficultyExtreme:
            return PictureModePictures_40;
            break;
            
        default:
            return PictureModePictures_01;
            break;
    }
}

// TODO: Generate the question first

- (void)generateAnswersForPictureMode:(PictureMode)mode
{
    CCLOG(@"generating answers for picture mode: %i and difficulty: %i", mode, [self qDifficulty]);
    BOOL isRetina = [[[[Settings settings] boardSettings] objectForKey:@"isRetina"] boolValue];
    
    NSDictionary *tiles = [[AnimalCatalogue animalCatalogue] answersForDifficulty:[self qDifficulty] andPicMode:[self qPicMode]];
    
    [self setQuestionString:[tiles objectForKey:@"questionString"]];
    
    // Get the tile for the answer
    Organism *answer = [tiles objectForKey:@"answer"];    
    Tile *answerTile = [[AnimalCatalogue animalCatalogue] tileForOrganism:answer forPictureMode:mode isRetina:isRetina];
    [answerTile setIsAnswer:YES];
    [[self answerTiles] addObject:answerTile];
    
    // Set the question audio
    switch ([self qDifficulty]) {
        case DifficultyEasy:
        {
            [self setQuestionSoundString:[answer sound_where_generic]];
            [answerTile setConfirmAnswerSoundString:[answer sound_thats_generic]];
            break;
        }
            
        case DifficultyMedium:
        {
            [self setQuestionSoundString:[answer sound_where_specific]];
            [answerTile setConfirmAnswerSoundString:[answer sound_thats_specific]];
            break;
        }
            
        case DifficultyHard:
        {
            [self setQuestionSoundString:[answer sound_where_scientific]];
            [answerTile setConfirmAnswerSoundString:[answer sound_thats_scientific]];
            break;
        }
            
        case DifficultyExtreme:
        {
            [self setQuestionSoundString:[answer sound_where_scientific]];
            [answerTile setConfirmAnswerSoundString:[answer sound_thats_scientific]];
            break;
        }
            
        default:
        {
            [self setQuestionSoundString:[answer sound_where_specific]];
            [answerTile setConfirmAnswerSoundString:[answer sound_thats_specific]];
            break;
        }
    }
    
    // Then get the tiles for the extra organisms
    NSMutableArray *otherOrgs = [tiles objectForKey:@"extraTiles"];
    
    for (int i = 0; i < [otherOrgs count]; i++) {
        Tile *otherTile = [[AnimalCatalogue animalCatalogue] tileForOrganism:[otherOrgs objectAtIndex:i]
                                                              forPictureMode:mode
                                                                    isRetina:isRetina];
        switch ([self qDifficulty]) {
            case DifficultyEasy:
            {
                [otherTile setWrongAnswerSoundString:[[otherTile organism] sound_thats_generic]];
                break;
            }
                
            case DifficultyMedium:
            {
                [otherTile setWrongAnswerSoundString:[[otherTile organism] sound_thats_specific]];
                break;
            }
                
            case DifficultyHard:
            {
                [otherTile setWrongAnswerSoundString:[[otherTile organism] sound_thats_scientific]];
                break;
            }
                
            case DifficultyExtreme:
            {
                [otherTile setWrongAnswerSoundString:[[otherTile organism] sound_thats_scientific]];
                break;
            }
                
            default:
            {
                [otherTile setWrongAnswerSoundString:[[otherTile organism] sound_thats_specific]];
                break;
            }
        }
        
        [[self answerTiles] addObject:otherTile];
    }
    
    // See NSMutableArray+Shuffling Category
    [[self answerTiles] shuffle];
    
}

- (void)dealloc
{
    CCLOG(@"Deallocating question...");
    _answerTiles = nil;
    _questionString = nil;
}

@end
