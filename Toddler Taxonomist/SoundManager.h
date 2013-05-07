//
//  SoundManager.h
//  Toddler Taxonomist
//
//  Created by Clay Heaton on 5/2/13.
//  Copyright (c) 2013 The Perihelion Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimpleAudioEngine.h"
#import "cocos2d.h"

@interface SoundManager : CCNode

@property (retain, nonatomic) NSString       *playingName;
@property (retain, nonatomic) CDSoundSource  *playingSource;
@property (assign, nonatomic) BOOL            isPlayingEffect;
@property (retain, nonatomic) NSString       *playingBackgroundName;
@property (retain, nonatomic) NSMutableArray *playQueue;
@property (retain, nonatomic) NSMutableArray *unloadQueue;

+ (SoundManager *)manager;

// Finish whatever is playing and then play this
- (float)playNext:(NSString *)songName asBackground:(BOOL)bg;

- (float)playNext:(NSString *)songName;
- (float)playNext:(NSString *)songName withUnload:(BOOL)unload;

// Cancel what's playing and and the queue and play this now.
- (float)playNow:(NSString *)songName;
- (float)playNow:(NSString *)songName andEmptyQueue:(BOOL)empty withUnload:(BOOL)unload;

- (void)playConcurrent:(NSString *)soundName;

// Stop what's playing -- effects only, not bg
- (void)stopPlaying;

- (void)stopBackgroundMusic;

// Unload this from memory
- (void)unload:(NSString *)songName;

- (void)fadeEffect;



@end
