//
//  MainMenuLayer.m
//  Toddler Taxonomist
//
//  Created by Clay Heaton on 4/16/13.
//  Copyright 2013 The Perihelion Group. All rights reserved.
//

#import "AppDelegate.h"
#import "MainMenuLayer.h"
#import "LoadingScene.h"
#import "BoardLayer.h"
#import "Settings.h"
#import "AnimalCatalogue.h"
#import "MainMenuSlider.h"
#import "CDXPropertyModifierAction.h"
#import "InfoLayer.h"
#import "SoundManager.h"


@implementation MainMenuLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{

	CCScene *scene       = [CCScene node];
	MainMenuLayer *layer = [MainMenuLayer node];
    
	[scene addChild: layer z:0 tag:1];

	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
    self = [super init];
	if( (self) ) {
        
        [self createMainLabel];
        // [self createGameKitStuff];
        [self createButtons];
        [self createSliders];
        [self scheduleUpdate];
        
        [[SoundManager manager] playNext:@"ThemeSong_v2.mp3" asBackground:NO];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(closeInfoLayer:)
                                                     name:@"closeInfoLayer"
                                                   object:nil];
	}
	return self;
}

- (void) onExit
{
    [super onExit];
}

- (void) createMainLabel
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    CCLabelBMFont* label = [CCLabelBMFont labelWithString:@"Toddler Taxonomist" fntFile:@"audimat_45_white.fnt"];
    label.position       =  ccp( size.width/8 , size.height/6 - size.height/12 );
    label.anchorPoint    = ccp(0,0.5);

    [self addChild:label z:12 tag:1124];
}

- (void) createGameKitStuff
{
    
    //
    // Leaderboards and Achievements
    //
    
    // Default font size will be 28 points.
    // [CCMenuItemFont setFontSize:28];
    
    /*
     
     // to avoid a retain-cycle with the menuitem and blocks
     __block id copy_self = self;
     
     // Achievement Menu Item using blocks
     CCMenuItem *itemAchievement = [CCMenuItemFont itemWithString:@"Achievements" block:^(id sender) {
     
     
     GKAchievementViewController *achivementViewController = [[GKAchievementViewController alloc] init];
     achivementViewController.achievementDelegate = copy_self;
     
     AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
     
     [[app navController] presentModalViewController:achivementViewController animated:YES];
     
     [achivementViewController release];
     }];
     
     // Leaderboard Menu Item using blocks
     CCMenuItem *itemLeaderboard = [CCMenuItemFont itemWithString:@"Leaderboard" block:^(id sender) {
     
     
     GKLeaderboardViewController *leaderboardViewController = [[GKLeaderboardViewController alloc] init];
     leaderboardViewController.leaderboardDelegate = copy_self;
     
     AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
     
     [[app navController] presentModalViewController:leaderboardViewController animated:YES];
     
     [leaderboardViewController release];
     }]; */
}

- (void) createButtons
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    Settings *settings = [Settings settings];
    NSNumber *difficulty = [NSNumber numberWithInt:DifficultyEasy];
    [[settings boardSettings] setObject:difficulty forKey:@"boardStartDifficulty"];
    
    CCMenuItemImage *startFinger = [CCMenuItemImage itemWithNormalImage:@"start.png"
                                                          selectedImage:@"start-dark.png"
                                                                  block:^(id sender)
    {                                                  
                    [[SoundManager manager] fadeEffect];
                    [[SoundManager manager] playNext:@"GameLoop.mp3" asBackground:YES];
                
                                                                      
                    CCScene *gameScene = [LoadingScene sceneWithTargetScene:TargetSceneBoardScene];
                                                                      
                    [[CCDirector sharedDirector] performSelector:@selector(replaceScene:)
                                                      withObject:gameScene
                                                      afterDelay:1.0f];
                                                                      
                    [self removeChildByTag:1125 cleanup:YES];
                    [[CCTextureCache sharedTextureCache] removeUnusedTextures];
    }];
    
    [startFinger setAnchorPoint:ccp(1, 0)];
    CCMenu *menu = [CCMenu menuWithItems:startFinger, nil];
    [menu setPosition:ccp(size.width, 0)];
    [menu setAnchorPoint:ccp(0,0)];
    [self addChild:menu z:10 tag:1122];
    
    
    CCMenuItemImage *aboutButton = [CCMenuItemImage itemWithNormalImage:@"about.png"
                                                          selectedImage:@"about-dark.png"
                                                                  block:^(id sender) {
                                                                      [self openInfoLayer];
                                                                  }];
    [aboutButton setAnchorPoint:ccp(0,0)];
    CCMenu *infoMenu = [CCMenu menuWithItems:aboutButton, nil];
    [infoMenu setPosition:ccp(0,0)];
    [infoMenu setAnchorPoint:ccp(0,0)];
    [self addChild:infoMenu z:10 tag:1123];
}

- (void) addInfoLayerAsChild:(InfoLayer *)infoLayer
{
    [self addChild:infoLayer z:999 tag:1125];
    [self getChildByTag:1125].visible = NO;
    [[self getChildByTag:1125] pauseSchedulerAndActions];
}

- (void) openInfoLayer
{
    [self getChildByTag:1122].visible = NO;
    [self getChildByTag:1123].visible = NO;
    [self getChildByTag:1124].visible = NO;

    // Show the infoLayer and run it
    [self getChildByTag:1125].visible = YES;
    [[self getChildByTag:1125] resumeSchedulerAndActions];
}

- (void) closeInfoLayer:(NSNotification *)notification
{
    // Hide the infoLayer and pause it
    [self getChildByTag:1125].visible = NO;
    [[self getChildByTag:1125] pauseSchedulerAndActions];
    
    [self getChildByTag:1122].visible = YES;
    [self getChildByTag:1123].visible = YES;
    [self getChildByTag:1124].visible = YES;
}

- (void) createSliders
{
    // Load images into the shared texture cache
    CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
    [frameCache addSpriteFramesWithFile:@"walker01.plist"];
    
    BOOL isRetina = [[[[Settings settings] boardSettings] valueForKey:@"isRetina"] boolValue];
    
    MainMenuSlider *slider1 = [[MainMenuSlider alloc] initAtLocation:ccp(0, 0)];  //128
    MainMenuSlider *slider2 = [[MainMenuSlider alloc] initAtLocation:ccp(0, 0)]; //448
    
    // Move it in the opposite direction
    [slider2 setReverse:YES];
    
    AnimalCatalogue *animalCatalogue = [AnimalCatalogue animalCatalogue]; // Get the singleton animal catalogue
    
    NSMutableSet *chosenOrgs = [[NSMutableSet alloc] init];
    
    for (int i = 0; i < 4; i++) {
        Organism *o1 = [animalCatalogue randomOrganism];
        while ([chosenOrgs containsObject:o1]) {
            o1 = [animalCatalogue randomOrganism];
        }
        [chosenOrgs addObject:o1];
        
        Organism *o2 = [animalCatalogue randomOrganism];
        while ([chosenOrgs containsObject:o2]) {
            o2 = [animalCatalogue randomOrganism];
        }
        [chosenOrgs addObject:o2];
        
        [[slider1 tiles] addObject:[animalCatalogue tileForOrganism:o1 forPictureMode:PictureModePictures_08 isRetina:isRetina]];
        [[slider2 tiles] addObject:[animalCatalogue tileForOrganism:o2 forPictureMode:PictureModePictures_08 isRetina:isRetina]];
    }
    
    [slider1 setupPictures];
    [slider2 setupPictures];
    
    [slider1 setAnchorPoint:ccp(0, 0)];
    [slider2 setAnchorPoint:ccp(0, 0)];
    
    [slider1 setPosition:ccp(0,128)];
    [slider2 setPosition:ccp(0,448)];
    
    [slider1 setVisible:YES];
    [slider2 setVisible:YES];
    
    [self addChild:slider1 z:45 tag:321];
    [self addChild:slider2 z:45 tag:322];
    
    // Reset the catalogue after choosing
    [animalCatalogue resetCatalogue];
}


#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

@end
