//
//  MainMenuSlider.h
//  Toddler Taxonomist
//
//  Created by Clay Heaton on 4/25/13.
//  Copyright 2013 The Perihelion Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class Tile;

@interface MainMenuSlider : CCLayer {
    
}

@property (assign, readwrite)    BOOL            reverse;
@property (assign, readwrite)    CGPoint         pt;
@property (nonatomic, readwrite) NSMutableArray *tiles;
@property (nonatomic, readwrite) NSMutableArray *walkerFrames;

- (id)initAtLocation:(CGPoint)point;
- (void) setupPictures;

@end
