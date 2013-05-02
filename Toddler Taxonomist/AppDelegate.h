//
//  AppDelegate.h
//  Toddler Taxonomist
//
//  Created by Clay Heaton on 4/16/13.
//  Copyright The Perihelion Group 2013. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"

@class AnimalCatalogue;

// Added only for iOS 6 support
@interface MyNavigationController : UINavigationController <CCDirectorDelegate>
@end

@interface AppController : NSObject <UIApplicationDelegate>
{
	UIWindow *window_;
	MyNavigationController *navController_;

	CCDirectorIOS	*director_;							// weak ref
}

@property (nonatomic, retain) UIWindow *window;
@property (readonly) MyNavigationController *navController;
@property (readonly) CCDirectorIOS *director;
@property (nonatomic, retain) AnimalCatalogue *animalCatalogue;


@end
