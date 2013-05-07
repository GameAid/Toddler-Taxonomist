//
//  BoardLayer.h
//  Toddler Taxonomist
//
//  Created by Clay Heaton on 4/16/13.
//  Copyright 2013 The Perihelion Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MainMenuLayer.h"

@class Question;

// typedef unsigned int ALuint; Defined in MainMenuLayer

typedef enum
{
	PictureModeINVALID     = 0,
	PictureModePictures_01 = 1,
	PictureModePictures_02 = 2,
    PictureModePictures_04 = 4,
    //PictureModePictures_06 = 6, // Not in use
    PictureModePictures_08 = 8,
    PictureModePictures_40 = 40,
	PictureModeMAX,
} PictureMode;



@interface BoardLayer : CCLayer {
    
}

@property (assign, readwrite)       ALuint soundPlaying;
@property (assign, readwrite)       int randomPrefix;
@property (assign, readwrite)       BOOL detailPanelClosed;
@property (assign, readwrite)       BOOL retina;
@property (assign, readwrite)       BOOL firstGuess;
@property (assign, readwrite)       BOOL needToClearTextureCache;
@property (assign, readwrite)       BOOL needsTouch;
@property (assign, readwrite)       float sizeAdjustmentFactor;
@property (assign, readwrite)       float correctSoundDelay;
@property (nonatomic, readwrite)    PictureMode pictureMode;
@property (strong, nonatomic)       NSArray *picturesArray_1;
@property (strong, nonatomic)       NSArray *picturesArray_2;
@property (strong, nonatomic)       NSArray *picturesArray_4;
@property (strong, nonatomic)       NSArray *picturesArray_8;
@property (strong, nonatomic)       NSArray *picturesArray_40;
@property (strong, nonatomic)       NSArray *positionArray;
@property (strong, nonatomic)       NSDictionary *picArraysByNumber;

@property (strong, nonatomic)       NSMutableArray *randomColorArray;
@property (strong, nonatomic)       NSMutableArray *tiles;

@property (strong, nonatomic)       NSArray *soundsCorrect;
@property (strong, nonatomic)       NSArray *soundsIncorrect;

@property (retain, nonatomic)       Question *activeQuestion;
@property (assign, readwrite)       BOOL showInfoPanel;

+(CCScene *)scene;
- (void)closeDetails;

@end
