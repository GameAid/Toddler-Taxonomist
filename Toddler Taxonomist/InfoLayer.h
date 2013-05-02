//
//  InfoLayer.h
//  Toddler Taxonomist
//
//  Created by Clay Heaton on 4/29/13.
//  Copyright 2013 The Perihelion Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface InfoLayer : CCLayerColor {
    
}

@property (retain, nonatomic) NSMutableArray *holderArray;
@property (retain, nonatomic) CCNode *lowestHolder;

@end
