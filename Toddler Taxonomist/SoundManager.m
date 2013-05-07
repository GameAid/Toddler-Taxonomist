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
        [CDSoundEngine setMixerSampleRate:CD_SAMPLE_RATE_MID];
        [[CDAudioManager sharedManager] setResignBehavior:kAMRBStopPlay autoHandle:YES];
    }
    return manager;
}

- (id) init
{
    self = [super init];
    if (self) {
        _playQueue = [[NSMutableArray alloc] init];
        _unloadQueue = [[NSMutableArray alloc] init];
        [self setIsPlayingEffect:NO];
        // [self scheduleUpdate];
        //[self schedule:@selector(emptyUnloadQueue:) interval:3.0f];
        
        // [[[CCDirector sharedDirector] scheduler] resumeTarget:self];
        [[[CCDirector sharedDirector] scheduler] scheduleSelector:@selector(emptyUnloadQueue:) forTarget:self interval:45.0 paused:NO];
        
    }
    return self;
}

- (float)playNext:(NSString *)songName
{
    return [self playNext:songName asBackground:NO];
}

- (float)playNext:(NSString *)songName withUnload:(BOOL)unload
{
    return [self playNext:songName asBackground:NO withUnload:unload];
}

- (float)playNext:(NSString *)songName asBackground:(BOOL)bg
{
    return [self playNext:songName asBackground:bg withUnload:YES];
}

- (float)playNext:(NSString *)songName asBackground:(BOOL)bg withUnload:(BOOL)unload
{
    // Handle background music
    if (bg) {
        // Stop background music and play this background music on a loop
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
        
        if (_playingBackgroundName) {
            [self unload:[_playingBackgroundName copy]];
        }
        
        _playingBackgroundName = songName;
        
        [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.25f];
        
        [[SimpleAudioEngine sharedEngine] performSelector:@selector(playBackgroundMusic:) withObject:_playingBackgroundName afterDelay:1.0f];
        return 0.0f;
    }
    
    float length;
    
    // Handle effects
    if (_isPlayingEffect) {
        // CCLOG(@"playNext - on queue: %@", songName);
        CDSoundSource *src = [[SimpleAudioEngine sharedEngine] soundSourceForFile:songName];
        length = [src durationInSeconds];
        
        [_playQueue addObject:songName];
        
        src = nil;
        
    } else {
        // Play it now
        // CCLOG(@"playNext - now: %@", songName);
        length = [self playNow:songName andEmptyQueue:YES withUnload:unload];
    }
    
    return length;
}


- (float)playNow:(NSString *)songName
{
    return [self playNow:songName andEmptyQueue:YES withUnload:YES];
}

- (float)playNow:(NSString *)songName andEmptyQueue:(BOOL)empty
{
    return [self playNow:songName andEmptyQueue:empty withUnload:YES];
}

- (float)playNow:(NSString *)songName andEmptyQueue:(BOOL)empty withUnload:(BOOL)unload
{
    [self stopPlaying];
    
    if (empty) {
        [_playQueue removeAllObjects];
    }
    
    _playingSource        = nil;
    _playingSource        = [[SimpleAudioEngine sharedEngine] soundSourceForFile:songName];
    float duration        = _playingSource.durationInSeconds + 0.07f; // slight delay between sounds
    _playingName          = songName;
    
    [_playingSource play];
    
    _isPlayingEffect      = YES;
    
    [self performSelector:@selector(nextInQueueWithUnload:) withObject:[NSNumber numberWithBool:unload] afterDelay:duration];
    
    return duration;
}


- (void)stopPlaying
{
    if (_isPlayingEffect) {

        [SoundManager cancelPreviousPerformRequestsWithTarget:self];
        
        [_playingSource stop];
        
        [_unloadQueue addObject:[_playingName copy]];
        
        _playingName   = @"";
        _playingSource = nil;
        _isPlayingEffect = NO;
    }
}

- (void)stopBackgroundMusic
{
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    [self stopPlaying];
}

- (void)fadeEffect
{
    // CCLOG(@"Fading Source: %@", _playingSource.description);

    // Fade out the theme song -- what happens if it isn't playing?
    [CDXPropertyModifierAction fadeSoundEffect:1.0f
                                   finalVolume:0.0f
                                     curveType:kIT_SCurve
                                    shouldStop:YES
                                        effect:_playingSource];
    
    _playingName     = @"";
    _playingSource   = nil;
    _isPlayingEffect = NO;
    
    // [self performSelector:@selector(unload:) withObject:[_playingName copy] afterDelay:3.0f];
    [_unloadQueue addObject:[_playingName copy]];
}



- (void)nextInQueueWithUnload:(NSNumber *)doUnload
{
    CCLOG(@"Finishing: %@ unload: %@", _playingName, doUnload.boolValue ? @"YES" : @"NO");
    
    // TODO: Remove doUnload -- unnecessary if we add everything to the unload queue
    if (!doUnload.boolValue) {
        [_unloadQueue addObject:[_playingName copy]];
    }
    
    // There's nothing in the queue, so clear stuff out
    if ([_playQueue count] == 0) {
        // CCLOG(@"Nothing in the effect queue");
        
        _isPlayingEffect = NO;
        
        if (doUnload.boolValue) {
            [_unloadQueue addObject:[_playingName copy]];
        }
        
        _playingName = @"";
        _playingSource = nil;
        return;
    }
    
    // There is something in the queue
    
    // Unload the last effect
    if (doUnload.boolValue) {
        [_unloadQueue addObject:[_playingName copy]];
    }
    
    _isPlayingEffect = NO;
    
    // Get the name of the next sound
    _playingName = [_playQueue objectAtIndex:0];
    
    // Play the sound
    [self playNow:_playingName andEmptyQueue:NO withUnload:doUnload.boolValue];
    
    // Remove from the queue the sound that was just sent to play
    [_playQueue removeObjectAtIndex:0];

}

- (void) emptyUnloadQueue:(ccTime)dt
{
    CCLOG(@"Emptying the unload queue:");
    for (int i = 0; i < _unloadQueue.count; i++) {
        
        NSString *sound = [_unloadQueue objectAtIndex:i];
        
        if ([_playingName isEqualToString:sound]) {
            continue;
        }
        
        CCLOG(@"..... %@", sound);
        [_unloadQueue removeObject:sound];
        [[SimpleAudioEngine sharedEngine] unloadEffect:sound];
    }
}

- (void)unload:(NSString *)songName
{
    // CCLOG(@"Unloading %@", songName);
    [[SimpleAudioEngine sharedEngine] performSelector:@selector(unloadEffect:) withObject:songName afterDelay:2.0f];
}


@end
