//
//  IntroLayer.h
//  Toddler Taxonomist
//
//  Created by Clay Heaton on 4/16/13.
//  Copyright The Perihelion Group 2013. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

@class InfoLayer;

// HelloWorldLayer
@interface IntroLayer : CCLayer
{
}

@property (retain, nonatomic) InfoLayer *infoLayer;

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
