//
//  SoundManager.h
//  Toddler Taxonomist
//
//  Created by Clay Heaton on 5/2/13.
//  Copyright (c) 2013 The Perihelion Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimpleAudioEngine.h"

@interface SoundManager : NSObject

@property (retain, nonatomic) NSString       *playingName;
@property (retain, nonatomic) CDSoundSource  *playingSource;
@property (assign, nonatomic) BOOL            isPlayingEffect;
@property (retain, nonatomic) NSString       *playingBackgroundName;
@property (retain, nonatomic) NSMutableArray *playQueue;

+ (SoundManager *)manager;

// Finish whatever is playing and then play this
- (void)playNext:(NSString *)songName asBackground:(BOOL)bg;

// Cancel what's playing and and the queue and play this now.
- (float)playNow:(NSString *)songName;

// Stop what's playing -- effects only, not bg
- (void)stopPlaying;

// Unload this from memory
- (void)unload:(NSString *)songName;

- (void)fadeEffect;



@end
