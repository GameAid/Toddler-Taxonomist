//
//  Tile.m
//  Toddler Taxonomist
//
//  Created by Clay Heaton on 4/18/13.
//  Copyright 2013 The Perihelion Group. All rights reserved.
//

#import "Tile.h"
#import "Organism.h"


@implementation Tile

- (id) init
{
    self = [super init];
    if (self) {
        [self setIsAnswer:NO];
        [self setAlreadyTapped:NO];
    }
    return self;
}

- (id) initAsAnswer:(BOOL)isThisTheAnswer
{
    self = [super init];
    if (self) {
        [self setIsAnswer:isThisTheAnswer];
    }
    return self;
}

- (void) dealloc
{
    [self removeAllChildrenWithCleanup:YES];
    _organism = nil;
    _tileSprite = nil;
}

@end
