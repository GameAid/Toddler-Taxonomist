//
//  Settings.h
//  Toddler Taxonomist
//
//  Created by Clay Heaton on 4/17/13.
//  Copyright (c) 2013 The Perihelion Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SimpleAudioEngine.h"

typedef enum
{
	TagINVALID     = 0,
	TagOrganismDetails,
	TagMAX,
} Tags;

@interface Settings : NSObject {
    SimpleAudioEngine *soundEngine;
}

@property (strong, readwrite) NSMutableDictionary *boardSettings;

+(Settings *)settings;

@end
