//
//  IntroLayer.m
//  Toddler Taxonomist
//
//  Created by Clay Heaton on 4/16/13.
//  Copyright The Perihelion Group 2013. All rights reserved.
//


// Import the interfaces
#import "IntroLayer.h"
#import "MainMenuLayer.h"
#import "InfoLayer.h"
#import "SoundManager.h"


#pragma mark - IntroLayer

// HelloWorldLayer implementation
@implementation IntroLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	IntroLayer *layer = [IntroLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// 
-(id) init
{
	if( (self=[super init])) {

		// ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];

		CCSprite *background;
		
		if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
			background = [CCSprite spriteWithFile:@"Default.png"];
			background.rotation = 90;
		} else {
			background = [CCSprite spriteWithFile:@"Default-Landscape~ipad.png"];
		}
		background.position = ccp(size.width/2, size.height/2);
        
        [[SoundManager manager] playNext:@"gameaid_leader.mp3" asBackground:NO];
        
        _infoLayer = [[InfoLayer alloc] initWithColor:ccc4(0, 0, 0, 220)];

		// add the label as a child to this Layer
		[self addChild: background];
	}
	
	return self;
}

-(void) onEnter
{
	[super onEnter];
    [self performSelector:@selector(continueToMainMenu) withObject:nil afterDelay:3.0f];
}

- (void) continueToMainMenu
{
    CCScene *mainMenuScene = [MainMenuLayer scene];
    
    // Preload the _infoLayer to avoid the delay that happens on the Main menu (hopefully)
    
    MainMenuLayer *mainMenuLayer = (MainMenuLayer *)[mainMenuScene getChildByTag:1];
    [mainMenuLayer addInfoLayerAsChild:_infoLayer];
    _infoLayer = nil;
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:mainMenuScene]];
}
@end
