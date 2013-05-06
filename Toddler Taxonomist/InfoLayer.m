//
//  InfoLayer.m
//  Toddler Taxonomist
//
//  Created by Clay Heaton on 4/29/13.
//  Copyright 2013 The Perihelion Group. All rights reserved.
//

#import "InfoLayer.h"
#import "AnimalCatalogue.h"
#import "Organism.h"
#import "Settings.h"

@implementation InfoLayer

- (id)initWithColor:(ccColor4B)color // ccc4(0, 0, 0, 255) for black
{
    self = [super initWithColor:color];
    
    if (self) {
        [self placeMusicInfo];
        [self placeGameAidInfo];
        [self placePhotoCreditsAndLicenses];
        [self setTouchEnabled:YES];
        [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES]; //addTargetedDelegate:self priority:0 swallowTouches:YES];
        
        [self scheduleUpdate];
        
    }
    return self;
}

- (void) onExit
{
    CCLOG(@"Exiting InfoLayer");
    [self removeAllChildrenWithCleanup:YES];
    _holderArray  = nil;
    _lowestHolder = nil;
    [super onExit];
}

- (void) placeGameAidInfo
{
    CGSize winsize = [[CCDirector sharedDirector] winSize];
    
    CCLabelBMFont *aboutLabel = [CCLabelBMFont labelWithString:@"About Toddler Taxonomist"
                                                       fntFile:@"audimat_36_white.fnt"
                                                         width:winsize.width * 0.42
                                                     alignment:kCCTextAlignmentCenter];
    aboutLabel.position    = ccp(4,winsize.height - 4);
    aboutLabel.anchorPoint = ccp(0,1);
    [self addChild:aboutLabel];
    
    CCLabelBMFont *closeLabel = [CCLabelBMFont labelWithString:@"Tap anywhere to continue"
                                                       fntFile:@"audimat_24_white_italic.fnt"
                                                         width:winsize.width * 0.42
                                                     alignment:kCCTextAlignmentCenter];
    closeLabel.anchorPoint = ccp(0,1);
    closeLabel.position    = ccpSub(aboutLabel.position, ccp(0,[aboutLabel contentSize].height));
    [self addChild:closeLabel];
    
    NSString *about = @"Toddler Taxonomist was created by Clay Heaton to entertain his daughters and to support GameAid, a new initiative to create games about environmental conservation and public health. All science info and text from Wikipedia.\n\nPlease report improperly pronounced scientific names, preferably with an attached audio clip demonstrating the correct pronunciation. Thanks!\n\nFor more information:\nWeb: www.GameAid.org\nEmail: info@gameaid.org\nTwitter: @GameAid\nFacebook: www.facebook.com/GameAid\n\nCredits:\nProgramming: Clay Heaton\nVoiceover: Clay Heaton\nPhotography: See the list to the right -------->\nMain Menu Music: Clay & Blythe Heaton\n\nGameplay music by N. Cameron Britt\nwww.ncameronbritt.com\nTwitter: @NCameronBritt\n\nOne Finger Single Tap icon designed by Scott Lewis from The Noun Project.";
    
    CCLabelBMFont *aboutText = [CCLabelBMFont labelWithString:about
                                                      fntFile:@"audimat_20_white.fnt"
                                                        width:winsize.width * 0.42
                                                    alignment:kCCTextAlignmentLeft];
    aboutText.anchorPoint = ccp(0,1);
    aboutText.position    = ccpSub(closeLabel.position, ccp(0, [closeLabel contentSize].height + 15));
    [self addChild:aboutText];
    
    
    
    CCLabelBMFont *cocos = [CCLabelBMFont labelWithString:@"Made with cocos2d" fntFile:@"audimat_24_white.fnt"];
    CCSprite *cocosSprite = [CCSprite spriteWithFile:@"cocos.png"];
    [cocosSprite addChild:cocos];
    cocosSprite.anchorPoint = ccp(0,0.5f);
    cocos.anchorPoint       = ccp(0,0.5f);
    cocos.position          = ccp(cocosSprite.contentSize.width + 5,cocosSprite.contentSize.height * 0.5);
    cocosSprite.position    = ccp(15,45); // ccpSub(aboutText.position, ccp(0,aboutText.contentSize.height + cocosSprite.contentSize.height));
    cocosSprite.scale       = 0.5f;
    cocos.scale             = 1.5f;
    [self addChild:cocosSprite];
    
    /* Removed because I'm too lazy to edit the image to remove antialiasing.
     
    CCSprite *cocosLogo = [CCSprite spriteWithFile:@"cocos-official.png"];
    cocosLogo.position    = ccp(10,10);
    cocosLogo.anchorPoint = ccp(0,0);
    [self addChild:cocosLogo];
     */
    
    [[AnimalCatalogue animalCatalogue] resetCatalogue];
    
    NSMutableArray *allOrgs = [[AnimalCatalogue animalCatalogue] allOrganismsReference];
    
    BOOL isRetina = [[[[Settings settings] boardSettings] objectForKey:@"isRetina"] boolValue];
    
    CGPoint start = ccp(winsize.width * 0.5 + 128, -1);
    
    _holderArray = [[NSMutableArray alloc] initWithCapacity:[allOrgs count]];
    
    for (Organism *o in allOrgs) {
        CCSprite *photo = [CCSprite spriteWithFile:[o picSized:256 by:256]];
        photo.anchorPoint = ccp(1,1);
        
        NSString *photoCredits = [NSString stringWithFormat:@"%@\n%@\n%@", [o specificName], [o photoCredit], [o imageSource]];
        CCLabelTTF *credit = [CCLabelTTF labelWithString:photoCredits
                                                fontName:[[UIFont systemFontOfSize:12] fontName]
                                                fontSize:12
                                              dimensions:CGSizeMake(winsize.width * 0.5 - 133, 128)
                                              hAlignment:kCCTextAlignmentLeft];
        credit.anchorPoint = ccp(0,1);
        credit.visible     = YES;
        if (!isRetina) {
            photo.scale = 0.5f;
        }
        CCNode *holder = [[CCNode alloc] init];
        holder.anchorPoint = ccp(0,1);
        holder.position = start;
        [holder addChild:photo];
        photo.position = ccp(0,0);
        
        [holder addChild:credit];
        credit.position = ccp(3,0);
        
        [_holderArray addObject:holder];
        
        start = ccpSub(start, ccp(0,138));
        
        //CCLOG(@"organism: %@", [o specificName]);
    }
    
    for (CCNode *h in _holderArray) {
        [self addChild:h];
    }
    
    _lowestHolder = [_holderArray lastObject];
    
}

- (void) placeMusicInfo
{
    
}

- (void) placePhotoCreditsAndLicenses
{
    
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    // CCLOG(@"ccTouchBegan");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"closeInfoLayer" object:nil];
    return YES;
}

-(void) update:(ccTime)delta
{
    for (int i = 0; i < _holderArray.count; i++) {
        CCNode *holder = [_holderArray objectAtIndex:i];
        
        holder.position = ccpAdd(holder.position, ccp(0,2));
        
        if (holder.position.y - 128 > [[CCDirector sharedDirector] winSize].height) {
            holder.position = ccpSub([_lowestHolder position],ccp(0,138));
            _lowestHolder = holder;
        }
    }
}

/////////////////////////////////////////////////////////////////
//                                                             //
//                                                             //
//     GameAid Info                                            //
//                                            Photo            //
//                                                             //
//                                                             //
//                                                             //
//                                                             //
//                                           Credits           //
//                                                             //
//                                                             //
//                                                             //
//                                                             //
//                                                             //
//                                            and              //
//                                                             //
//                                                             //
//                                                             //
//                                                             //
//      Music Info                                             //
//                                          Licenses           //
//                                                             //
//                                                             //
//                                                             //
//                                                             //
//                                                             //
/////////////////////////////////////////////////////////////////

@end

