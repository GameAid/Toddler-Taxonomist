//
//  MainMenuLayer.h
//  Toddler Taxonomist
//
//  Created by Clay Heaton on 4/16/13.
//  Copyright 2013 The Perihelion Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "cocos2d.h"

@class MainMenuSlider;
@class CDSoundSource;
@class InfoLayer;

@interface MainMenuLayer : CCLayer <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
{
    
}

@property (retain, nonatomic) CDSoundSource  *themeSong;
@property (retain, nonatomic) MainMenuSlider *sliderTop;
@property (retain, nonatomic) MainMenuSlider *sliderBottom;

// returns a CCScene that contains the MainMenuLayer as the only child
+(CCScene *) scene;
- (void) addInfoLayerAsChild:(InfoLayer *)infoLayer;

@end
