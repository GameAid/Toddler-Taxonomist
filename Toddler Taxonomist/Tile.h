//
//  Tile.h
//  Toddler Taxonomist
//
//  Created by Clay Heaton on 4/18/13.
//  Copyright 2013 The Perihelion Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class Organism;

typedef enum
{
	PicSizeINVALID     = 0,
    PicSize_5x5,
    PicSize_4x5,
    PicSize_4x25,
    PicSize_2x25,
    PicSize_1x1,
	PicSizeMAX
} PicSizes;

@interface Tile : CCSprite {
    
}

@property (retain, nonatomic) Organism *organism;
@property (retain, nonatomic) CCSprite *tileSprite; // use initWithFile & get file from the organism
@property (assign, readwrite) BOOL isAnswer;
@property (assign, readwrite) BOOL alreadyTapped;
@property (nonatomic, readwrite) NSString *wrongAnswerSoundString;
@property (nonatomic, readwrite) NSString *confirmAnswerSoundString;

- (id) initAsAnswer:(BOOL)isThisTheAnswer;

@end
