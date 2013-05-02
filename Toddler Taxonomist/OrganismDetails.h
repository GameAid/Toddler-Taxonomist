//
//  OrganismDetails.h
//  Toddler Taxonomist
//
//  Created by Clay Heaton on 4/22/13.
//  Copyright 2013 The Perihelion Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "BoardLayer.h"

@class Organism;

@interface OrganismDetails : CCLayerColor {
    
}

@property (retain, nonatomic) Organism *organism;
@property (unsafe_unretained, nonatomic) BoardLayer *boardLayer;
@property (assign, readwrite) BOOL descPlaying;
@property (assign, readwrite) ALuint descSoundId;

- (id)initWithColor:(ccColor4B)color andOrganism:(Organism *)org;

@end
