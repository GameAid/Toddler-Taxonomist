//
//  LoadingScene.h
//  FieldHospital
//
//  Created by Clay Heaton on 4/26/12.
//  Copyright 2012 The Perihelion Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum
{
	TargetSceneINVALID = 0,
	TargetSceneMainMenuScene,
	TargetSceneBoardScene,
	TargetSceneMAX,
} TargetScenes;

@interface LoadingScene : CCScene {
    TargetScenes targetScene_;
}

@property (retain, readwrite) NSDictionary *infoDict;

+(id) sceneWithTargetScene:(TargetScenes)targetScene;
-(id) initWithTargetScene:(TargetScenes)targetScene;

@end
