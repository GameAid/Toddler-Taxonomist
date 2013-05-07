//
//  OrganismDetails.m
//  Toddler Taxonomist
//
//  Created by Clay Heaton on 4/22/13.
//  Copyright 2013 The Perihelion Group. All rights reserved.
//

#import "OrganismDetails.h"
#import "Organism.h"
#import "Settings.h"
#import "BoardLayer.h"
#import "SoundManager.h"

@implementation OrganismDetails


- (id)initWithColor:(ccColor4B)color andOrganism:(Organism *)org
{
    self = [super initWithColor:color];
    if (self) {
        [self setOrganism:org];
        [self setTouchEnabled:YES];
        [self setDescPlaying:NO];
        
        // TODO: Remove legacy audio code
        [self setDescSoundId:0];
        
        // The close button
        CCMenuItemImage *closeButton = [CCMenuItemImage itemWithNormalImage:@"close.png"
                                                              selectedImage:@"close-dark.png"
                                                                      block:^(id sender) { [self closeLayer]; }];
        [closeButton setAnchorPoint:ccp(1, 0)];
        CCMenu *menu = [CCMenu menuWithItems:closeButton, nil];
        [menu setPosition:ccp([[CCDirector sharedDirector] winSize].width, 0)];
        [menu setAnchorPoint:ccp(0,0)];
        [self addChild:menu];
        
        
        // The organism details
        
        CCSprite *orgPic = [CCSprite spriteWithFile:[_organism picSized:1280 by:1280]];
        BOOL isRetina    = [[[[Settings settings] boardSettings] objectForKey:@"isRetina"] boolValue];
        if (!isRetina){ [orgPic setScale:0.5f]; }
        [orgPic setAnchorPoint:ccp(0, 0)];
        [orgPic setPosition:ccp(0,128)];
        [self addChild:orgPic z:10 tag:99];
        
        
        
        
        CCLabelBMFont *nameLabel = [CCLabelBMFont labelWithString:[_organism specificName] fntFile:@"audimat_45_white.fnt"];
        nameLabel.position = ccp([[CCDirector sharedDirector] winSize].width * 0.5, 64);
        [self addChild:nameLabel z:10 tag:8787];

        
        
        
        CCLabelBMFont *scientificName = [CCLabelBMFont labelWithString:[_organism scientificName] fntFile:@"audimat_24_white_italic.fnt"];
        scientificName.position = ccp([[CCDirector sharedDirector] winSize].width * 0.5,32);
        [self addChild:scientificName z:10 tag:8888];
        
        
        
        CCLabelBMFont *descriptiveText = [CCLabelBMFont labelWithString:[_organism organismDescription]
                                                                fntFile:@"audimat_24_white.fnt"
                                                                  width:315.0f
                                                              alignment:kCCTextAlignmentLeft];
        descriptiveText.position = ccp([[CCDirector sharedDirector] winSize].width * 0.65f,
                                       [[CCDirector sharedDirector] winSize].height * 0.97 );
        
        descriptiveText.anchorPoint = ccp(0,1);
        [self addChild:descriptiveText z:12 tag:8675];
        
        
        
        CCLabelTTF *imageSourceLabel = [CCLabelTTF labelWithString:[_organism photoCredit] fontName:[[UIFont systemFontOfSize:12] fontName] fontSize:12];
        imageSourceLabel.color = ccc3(180, 180,180);
        imageSourceLabel.position = ccp(3,114);
        imageSourceLabel.anchorPoint = ccp(0,0);
        [self addChild:imageSourceLabel z:12 tag:9999];
        
        NSString *longInfo = [NSString stringWithFormat:@"Kingdom: %@\nPhylum: %@\nClass: %@\nOrder: %@\nFamily: %@\nGenus: %@\nSpecies: %@\n", [_organism kingdomName], [_organism phylumName], [_organism className], [_organism orderName], [_organism familyName], [_organism genusName], [_organism properSpeciesName]];
        
        if (![[_organism subspeciesName] isEqualToString:@"-"]) {
            longInfo = [longInfo stringByAppendingFormat:@"Subspecies: %@", [_organism properSubspeciesName]];
        }
        
        CCLabelBMFont *info = [CCLabelBMFont labelWithString:longInfo fntFile:@"audimat_24_white.fnt"];
        info.position = ccp(descriptiveText.position.x,128);
        info.anchorPoint = ccp(0,0);
        [self addChild:info z:12 tag:9999];
        
        CCSprite *finger = [CCSprite spriteWithFile:@"finger.png"];
        [finger setAnchorPoint:ccp(1,1)];
        [finger setPosition:ccpSub(descriptiveText.position, ccp(2,0))];
        [self addChild:finger z:12 tag:12121];
        
        CCSprite *finger2 = [CCSprite spriteWithFile:@"finger.png"];
        [finger2 setAnchorPoint:ccp(0,0.5)];
        [finger2 setPosition:ccp(nameLabel.position.x + 5 + (nameLabel.contentSize.width * 0.5), nameLabel.position.y)];
        [self addChild:finger2 z:12 tag:12122];
        
        CCSprite *finger3 = [CCSprite spriteWithFile:@"finger.png"];
        [finger3 setAnchorPoint:ccp(0,0.5)];
        [finger3 setScale:0.6f];
        [finger3 setPosition:ccp(scientificName.position.x + 5 + (scientificName.contentSize.width * 0.5), scientificName.position.y)];
        [self addChild:finger3 z:12 tag:12123];
        
    }
    return self;
}

#pragma mark Touch events
-(CGPoint) locationFromTouch:(UITouch*)touch
{
    //CCLOG(@"%@", NSStringFromSelector(_cmd));
	CGPoint touchLocation = [touch locationInView: [touch view]];
	return [[CCDirector sharedDirector] convertToGL:touchLocation];
}

-(CGPoint) locationFromTouches:(NSSet*)touches
{
    //CCLOG(@"%@", NSStringFromSelector(_cmd));
	return [self locationFromTouch:[touches anyObject]];
}


- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touchLocGL = [self locationFromTouch:[touches anyObject]];

    // Long description
    if (CGRectContainsPoint([self getChildByTag:8675].boundingBox, touchLocGL) || CGRectContainsPoint([self getChildByTag:12121].boundingBox, touchLocGL)) {
        if (_descPlaying) {
            [[SoundManager manager] stopPlaying];
            [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.25f];
            _descPlaying = NO;
            return;
        } else {
            [[SoundManager manager] playNext:[_organism sound_description] withUnload:NO];
            [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.1f];
            _descPlaying = YES;
            return;
        }
    }
    
    // Specific Name
    if (CGRectContainsPoint([self getChildByTag:8787].boundingBox, touchLocGL)|| CGRectContainsPoint([self getChildByTag:12122].boundingBox, touchLocGL)) {
        [[SoundManager manager] playNow:[_organism sound_thats_specific] andEmptyQueue:YES withUnload:NO];
        return;
    }
    
    // Scientific Name
    if (CGRectContainsPoint([self getChildByTag:8888].boundingBox, touchLocGL)|| CGRectContainsPoint([self getChildByTag:12123].boundingBox, touchLocGL)) {
        [[SoundManager manager] playNow:[_organism sound_thats_scientific] andEmptyQueue:YES withUnload:NO];
        return;
    }
    
    // Touched anywhere else:
    [self closeLayer];
    
}

- (void) closeLayer
{
    if (_descPlaying) {
        [[SimpleAudioEngine sharedEngine] stopEffect:_descSoundId];
        _descSoundId = NO;
        [[SimpleAudioEngine sharedEngine] unloadEffect:[_organism sound_description]];
    }
    [[self boardLayer] closeDetails];
}

- (void) onExit
{
    CCLOG(@"[OrganismDetails onExit]");
    // [self removeFromParentAndCleanup:YES];
    _boardLayer = nil;
    [self removeAllChildrenWithCleanup:YES];
    [self unscheduleAllSelectors];
    [self unscheduleUpdate];
    
    [super onExit];
}


@end
