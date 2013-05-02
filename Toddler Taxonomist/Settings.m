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
        // Baseline sound settings
        [CDSoundEngine setMixerSampleRate:CD_SAMPLE_RATE_MID];
        [[CDAudioManager sharedManager] setResignBehavior:kAMRBStopPlay autoHandle:YES];
    }
    return self;
}

@end
