//
//  OrganismDetails.h
//  Toddler Taxonomist
//
//  Created by Clay Heaton on 4/22/13.
//  Copyright 2013 The Perihelion Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class Organism;
@class BoardLayer;

@interface OrganismDetails : CCLayerColor {
    
}

@property (retain, nonatomic) Organism *organism;
@property (unsafe_unretained, nonatomic) BoardLayer *boardLayer;

- (id)initWithColor:(ccColor4B)color andOrganism:(Organism *)org;

@end
