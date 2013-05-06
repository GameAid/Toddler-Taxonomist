//
//  Settings.m
//  Toddler Taxonomist
//
//  Created by Clay Heaton on 4/17/13.
//  Copyright (c) 2013 The Perihelion Group. All rights reserved.
//

#import "Settings.h"

@implementation Settings

static Settings *sharedSettings;


+(Settings *)settings
{
    if (!sharedSettings) {
        sharedSettings = [[Settings alloc] init];
    }
    return sharedSettings;
}

- (id) init {
    self = [super init];
    if (self) {
        _scoreBoard = [[NSMutableDictionary alloc] init];

        [_scoreBoard setObject:[NSNumber numberWithUnsignedShort:0] forKey:@"totalQuestions"];
        [_scoreBoard setObject:[NSNumber numberWithUnsignedShort:0] forKey:@"correctStreak"];
        [_scoreBoard setObject:[NSNumber numberWithUnsignedShort:0] forKey:@"incorrectStreak"];
        
        [_scoreBoard setObject:[NSNumber numberWithUnsignedShort:0] forKey:@"correctEasy"];
        [_scoreBoard setObject:[NSNumber numberWithUnsignedShort:0] forKey:@"correctMedium"];
        [_scoreBoard setObject:[NSNumber numberWithUnsignedShort:0] forKey:@"correctHard"];
        
        [_scoreBoard setObject:[NSNumber numberWithUnsignedShort:0] forKey:@"incorrectEasy"];
        [_scoreBoard setObject:[NSNumber numberWithUnsignedShort:0] forKey:@"incorrectMedium"];
        [_scoreBoard setObject:[NSNumber numberWithUnsignedShort:0] forKey:@"incorrectHard"];
        
        [_scoreBoard setObject:[NSNumber numberWithUnsignedShort:0] forKey:@"totalEasy"];
        [_scoreBoard setObject:[NSNumber numberWithUnsignedShort:0] forKey:@"totalMedium"];
        [_scoreBoard setObject:[NSNumber numberWithUnsignedShort:0] forKey:@"totalHard"];
        [_scoreBoard setObject:[NSNumber numberWithUnsignedShort:0] forKey:@"totalCorrect"];
        [_scoreBoard setObject:[NSNumber numberWithUnsignedShort:0] forKey:@"totalIncorrect"];
        
    }
    return self;
}

#pragma mark -
#pragma mark Scoreboard Management


- (void)increment:(NSString *)key
{
    unsigned short newValue = [[_scoreBoard objectForKey:key] unsignedShortValue] + 1;
    [_scoreBoard setObject:[NSNumber numberWithUnsignedShort:newValue] forKey:key];
    
}

- (void)reportCorrectAt:(QuestionDifficulty)difficulty
{
    [self increment:@"totalCorrect"];
    [self increment:@"totalQuestions"];
    [self increment:@"correctStreak"];
    [_scoreBoard setObject:[NSNumber numberWithUnsignedShort:0] forKey:@"incorrectStreak"];
    
    switch (difficulty) {
        case DifficultyEasy:
            [self increment:@"correctEasy"];
            [self increment:@"totalEasy"];
            CCLOG(@"-- Correct at Easy Difficulty --");
            break;
            
        case DifficultyMedium:
            [self increment:@"correctMedium"];
            [self increment:@"totalMedium"];
            CCLOG(@"-- Correct at Medium Difficulty --");
            break;
            
        case DifficultyHard:
            [self increment:@"correctHard"];
            [self increment:@"totalHard"];
            CCLOG(@"-- Correct at Hard Difficulty --");
            break;
            
        default:
            NSLog(@"We shouldn't be here.");
            break;
    }
    [self log];
}

- (void)reportIncorrectAt:(QuestionDifficulty)difficulty
{
    [self increment:@"totalIncorrect"];
    [self increment:@"totalQuestions"];
    [self increment:@"incorrectStreak"];
    [_scoreBoard setObject:[NSNumber numberWithUnsignedShort:0] forKey:@"correctStreak"];
    
    switch (difficulty) {
        case DifficultyEasy:
            [self increment:@"incorrectEasy"];
            [self increment:@"totalEasy"];
            CCLOG(@"-- Incorrect at Easy Difficulty --");
            break;
            
        case DifficultyMedium:
            [self increment:@"incorrectMedium"];
            [self increment:@"totalMedium"];
            CCLOG(@"-- Incorrect at Medium Difficulty --");
            break;
            
        case DifficultyHard:
            [self increment:@"incorrectHard"];
            [self increment:@"totalHard"];
            CCLOG(@"-- Incorrect at Hard Difficulty --");
            break;
            
        default:
            NSLog(@"We shouldn't be here.");
            break;
    }
    [self log];
}

- (unsigned short)correctAnswersAt:(QuestionDifficulty)difficulty
{
    NSString *key;
    
    switch (difficulty) {
        case DifficultyEasy:
        {   key = @"correctEasy";
            break;
        }
            
        case DifficultyMedium:
        {   key = @"correctMedium";
            break;
        }
            
        case DifficultyHard:
        {   key = @"correctHard";
            break;
        }
            
        default:
            NSLog(@"We shouldn't be here.");
            break;
    }
    
    return [[_scoreBoard objectForKey:key] unsignedShortValue];
}

- (unsigned short)incorrectAnswersAt:(QuestionDifficulty)difficulty
{
    NSString *key;
    
    switch (difficulty) {
        case DifficultyEasy:
        {   key = @"incorrectEasy";
            break;
        }
            
        case DifficultyMedium:
        {   key = @"incorrectMedium";
            break;
        }
            
        case DifficultyHard:
        {   key = @"incorrectHard";
            break;
        }
            
        default:
            NSLog(@"We shouldn't be here.");
            break;
    }
    
    return [[_scoreBoard objectForKey:key] unsignedShortValue];
}

- (unsigned short)totalQuestionsAt:(QuestionDifficulty)difficulty
{
    NSString *key;
    
    switch (difficulty) {
        case DifficultyEasy:
        {   key = @"totalEasy";
            break;
        }
            
        case DifficultyMedium:
        {   key = @"totalMedium";
            break;
        }
            
        case DifficultyHard:
        {   key = @"totalHard";
            break;
        }
            
        default:
            NSLog(@"We shouldn't be here.");
            break;
    }
    
    return [[_scoreBoard objectForKey:key] unsignedShortValue];
}

- (unsigned short)totalCorrect
{
    return [[_scoreBoard objectForKey:@"totalCorrect"] unsignedShortValue];
}

- (unsigned short)totalIncorrect
{
    return [[_scoreBoard objectForKey:@"totalIncorrect"] unsignedShortValue];
}

- (unsigned short)totalQuestions
{
    return [[_scoreBoard objectForKey:@"totalQuestions"] unsignedShortValue];
}

- (unsigned short)correctStreak
{
    return [[_scoreBoard objectForKey:@"correctStreak"] unsignedShortValue];
}

- (unsigned short)incorrectStreak
{
    return [[_scoreBoard objectForKey:@"incorrectStreak"] unsignedShortValue];
}

- (void) log
{
    CCLOG(@"======================= SCORE ==========================");
    CCLOG(@"Total Questions: %i", [self totalQuestions]);
    CCLOG(@"Total Correct:   %i", [self totalCorrect]);
    CCLOG(@"Total Incorrect: %i", [self totalIncorrect]);
    CCLOG(@"Correct streak:  %i", [self correctStreak]);
    CCLOG(@"Incorrect streak:%i", [self incorrectStreak]);
    
    CCLOG(@"Easy:   %i/%i", [self correctAnswersAt:DifficultyEasy],   [self totalQuestionsAt:DifficultyEasy]);
    CCLOG(@"Medium: %i/%i", [self correctAnswersAt:DifficultyMedium], [self totalQuestionsAt:DifficultyMedium]);
    CCLOG(@"Hard:   %i/%i", [self correctAnswersAt:DifficultyHard],   [self totalQuestionsAt:DifficultyHard]);
    CCLOG(@"======================= END SCORE ======================");
    
    NSDictionary *userDict;
    
    switch ([self correctStreak]) {
        case 5:
            userDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:5], @"correctStreak", nil];
            break;
            
        case 10:
            userDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:10], @"correctStreak", nil];
            break;
            
        case 20:
            userDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:20], @"correctStreak", nil];
            break;
            
        case 30:
            userDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:30], @"correctStreak", nil];
            break;
            
        case 40:
            userDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:40], @"correctStreak", nil];
            break;
            
        case 50:
            userDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:50], @"correctStreak", nil];
            break;
            
        default:
            return;
            break;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"correctStreak" object:nil userInfo:userDict];
}

@end
