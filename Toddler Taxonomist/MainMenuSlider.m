//
//  MainMenuSlider.m
//  Toddler Taxonomist
//
//  Created by Clay Heaton on 4/25/13.
//  Copyright 2013 The Perihelion Group. All rights reserved.
//

#import "MainMenuSlider.h"
#import "Tile.h"


@implementation MainMenuSlider

- (id)initAtLocation:(CGPoint)point
{
    self = [super init];
    if (self) {
        [self setReverse:NO];
        _tiles        = [[NSMutableArray alloc] init];
        _walkerFrames = [[NSMutableArray alloc] init];
        [self scheduleUpdate];
    }
    return self;
}

// Only call this after populating the tiles array
- (void) setupPictures
{
    
    for (int i = 0; i < [_tiles count]; i++) {
        
        Tile *t = [_tiles objectAtIndex:i];
        
        CGPoint thisPt = ccp(i * 256 ,0);

        t.anchorPoint = ccp(0,0);
        t.position = thisPt;
        
        t.visible = YES;
        
        [self addChild:t];
    }
    
    [self createWalker];

}

- (void) createWalker
{
    CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
    CCSprite *test = [[CCSprite alloc] init ]; //spriteWithSpriteFrame:[frameCache spriteFrameByName:@"person01_65.png"]];
    NSMutableArray *sFrames = [[NSMutableArray alloc] init];
    
    int start, limit;
    
    if (_reverse) {
        start = 81;
        limit = 97;
    } else {
        start = 65;
        limit = 81;
    }
    
    for (int i = start; i < limit; i++) {
        NSString *file = [NSString stringWithFormat:@"person01_%i.png", i];
        CCSpriteFrame *frame = [frameCache spriteFrameByName:file];
        [sFrames addObject:frame];
    }
    
    [self addChild:test z:10 tag:123];
    
    CCAnimation     *anim     = [CCAnimation     animationWithSpriteFrames:sFrames delay:0.05f];
    CCAnimate       *animate  = [CCAnimate       actionWithAnimation:anim];
    CCRepeatForever *repeat   = [CCRepeatForever actionWithAction:animate];
    
    [test runAction:repeat];
    [test setAnchorPoint:ccp(0.5, 0)];
    [test setPosition:ccp(-128,0)];
    
}

-(void) update:(ccTime)delta
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    float moveBy = 1.0f;
    if (_reverse) {
        moveBy = -1.0f;
    }
    
    for (int i = 0; i < [_tiles count]; i++) {
        Tile *t = [_tiles objectAtIndex:i];
        t.position = ccpAdd(t.position, ccp(moveBy,0));
        
        if (!_reverse) {
            if (t.position.x > size.width) {
                t.position = ccp(-256,0);
            }
        } else {
            if (t.position.x < -256) {
                t.position = ccp(size.width,0);
            }
        }
    }
    

    if (!_reverse) {
        if ([self getChildByTag:123].position.x > size.width + 128) {
            [self getChildByTag:123].position = ccp(-128,0);
        }
    } else {
        if ([self getChildByTag:123].position.x < -128) {
            [self getChildByTag:123].position = ccp(size.width + 128,0);
        }
    }


    [[self getChildByTag:123] setPosition:ccpAdd([self getChildByTag:123].position,ccp(moveBy,0))];

    
}

@end
