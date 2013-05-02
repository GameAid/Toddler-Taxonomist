//
//  SoundManager.m
//  Toddler Taxonomist
//
//  Created by Clay Heaton on 5/2/13.
//  Copyright (c) 2013 The Perihelion Group. All rights reserved.
//

#import "SoundManager.h"
#import "CDXPropertyModifierAction.h"

@implementation SoundManager

static SoundManager *manager;

+ (SoundManager *)manager
{
    if (!manager) {
        manager = [[SoundManager alloc] init];
    }
    return manager;
}

- (id) init
{
    self = [super init];
    if (self) {
        _playQueue = [[NSMutableArray alloc] init];
        [self setIsPlayingEffect:NO];
    }
    return self;
}


- (void)playNext:(NSString *)songName asBackground:(BOOL)bg
{
    // Handle background music
    if (bg) {
        // Stop background music and play this background music on a loop
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
        
        if (_playingBackgroundName) {
            [self unload:[_playingBackgroundName copy]];
        }
        
        _playingBackgroundName = songName;
        
        [[SimpleAudioEngine sharedEngine] performSelector:@selector(playBackgroundMusic:) withObject:_playingBackgroundName afterDelay:1.0f];
        
        [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.5f];
        return;
    }
    
    // Handle effects
    if (_isPlayingEffect) {
        [_playQueue addObject:songName];
        
    } else {
        // Play it now
        [self playNow:songName];
    }
}


- (float)playNow:(NSString *)songName
{
    return [self playNow:songName andEmptyQueue:YES];
}

- (float)playNow:(NSString *)songName andEmptyQueue:(BOOL)empty
{
    if (_isPlayingEffect) {
        [_playingSource stop];
        [self unload:_playingName];
    }
    
    if (empty) {
        [_playQueue removeAllObjects];
    }
    
    _playingSource        = nil;
    _playingSource        = [[SimpleAudioEngine sharedEngine] soundSourceForFile:songName];
    float duration        = _playingSource.durationInSeconds + 0.07f; // slight delay between sounds
    _playingName          = songName;
    
    [_playingSource play];
    
    _isPlayingEffect      = YES;
    
    [self performSelector:@selector(nextInQueue) withObject:nil afterDelay:duration];
    
    return duration;
}



- (void)stopPlaying
{
    if (_isPlayingEffect) {
        [_playingSource stop];
        
        [self unload:[_playingName copy]];
        _playingName   = @"";
        _playingSource = nil;
        _isPlayingEffect = NO;
    }
}

- (void)fadeEffect
{
    CCLOG(@"Fading Source: %@", _playingSource.description);

    // Fade out the theme song -- what happens if it isn't playing?
    [CDXPropertyModifierAction fadeSoundEffect:1.0f
                                   finalVolume:0.0f
                                     curveType:kIT_SCurve
                                    shouldStop:YES
                                        effect:_playingSource];
    
    _playingName     = @"";
    _playingSource   = nil;
    _isPlayingEffect = NO;
    
    [self performSelector:@selector(unload:) withObject:[_playingName copy] afterDelay:3.0f];
}



- (void)nextInQueue
{
    CCLOG(@"Finishing: %@", _playingName);
    
    // There's nothing in the queue, so clear stuff out
    if ([_playQueue count] == 0) {
        CCLOG(@"Nothing in the effect queue");
        
        _isPlayingEffect = NO;
        [self unload:[_playingName copy]];
        _playingName = @"";
        _playingSource = nil;
        return;
    }
    
    // There is something in the queue
    
    // Unload the last effect
    [self unload:[_playingName copy]];
    
    _isPlayingEffect = NO;
    
    // Get the name of the next sound
    _playingName = [_playQueue objectAtIndex:0];
    
    // Play the sound
    [self playNow:_playingName andEmptyQueue:NO];
    
    // Remove from the queue the sound that was just sent to play
    [_playQueue removeObjectAtIndex:0];

}


- (void)unload:(NSString *)songName
{
    CCLOG(@"Unloading %@", songName);
    [[SimpleAudioEngine sharedEngine] performSelector:@selector(unloadEffect:) withObject:songName afterDelay:0.5f];
}


@end
