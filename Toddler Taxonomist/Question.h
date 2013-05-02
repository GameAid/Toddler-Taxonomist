//
//  Question.h
//  Toddler Taxonomist
//
//  Created by Clay Heaton on 4/18/13.
//  Copyright (c) 2013 The Perihelion Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BoardLayer.h"
#import "AnimalCatalogue.h"

@interface Question : NSObject

@property (retain, readwrite) NSMutableArray        *answerTiles;
@property (retain, readwrite) NSString              *questionString;
@property (retain, readwrite) NSString              *questionSoundString;
@property (assign, readwrite) QuestionDifficulty    qDifficulty;
@property (assign, readwrite) int                   questionNumberInSequence;
@property (assign, readwrite) PictureMode           qPicMode;

- (id)initWithPictureMode:(PictureMode)mode; // Mainly for testing -- Will decide on picture mode and set it by notification

- (id)initContinuingFromQuestion:(Question *)oldQuestion correctOnFirstGuess:(BOOL)firstGuess;
- (id)initWithDifficultyMode:(QuestionDifficulty)difficulty;


@end
