//
//  Settings.h
//  Toddler Taxonomist
//
//  Created by Clay Heaton on 4/17/13.
//  Copyright (c) 2013 The Perihelion Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "AnimalCatalogue.h"

typedef enum
{
	TagINVALID     = 0,
	TagOrganismDetails,
	TagMAX,
} Tags;

@interface Settings : NSObject {

}

@property (strong, readwrite) NSMutableDictionary *boardSettings;
@property (strong, readwrite) NSMutableDictionary *scoreBoard;

+(Settings *)settings;

- (void)reportCorrectAt:(QuestionDifficulty)difficulty;
- (void)reportIncorrectAt:(QuestionDifficulty)difficulty;

- (unsigned short)correctAnswersAt:(QuestionDifficulty)difficulty;
- (unsigned short)incorrectAnswersAt:(QuestionDifficulty)difficulty;
- (unsigned short)totalQuestionsAt:(QuestionDifficulty)difficulty;

- (unsigned short)totalCorrect;
- (unsigned short)totalIncorrect;
- (unsigned short)totalQuestions;

- (unsigned short)correctStreak;
- (unsigned short)incorrectStreak;
@end


