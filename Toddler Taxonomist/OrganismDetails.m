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

@implementation OrganismDetails


- (id)initWithColor:(ccColor4B)color andOrganism:(Organism *)org
{
    self = [super initWithColor:color];
    if (self) {
        [self setOrganism:org];
        [self setTouchEnabled:YES];
        
        // The close button
        CCMenuItemImage *closeButton = [CCMenuItemImage itemWithNormalImage:@"close.png"
                                                              selectedImage:@"close-dark.png"
                                                                      block:^(id sender) {
                                                                          [[self boardLayer] closeDetails];
                                                                      }];
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
        [self addChild:nameLabel];

        
        CCLabelBMFont *scientificName = [CCLabelBMFont labelWithString:[_organism scientificName] fntFile:@"audimat_24_white_italic.fnt"];
        scientificName.position = ccp([[CCDirector sharedDirector] winSize].width * 0.5,32);
        [self addChild:scientificName z:10 tag:8888];
        
        CCLabelBMFont *descriptiveText = [CCLabelBMFont labelWithString:[_organism organismDescription]
                                                                fntFile:@"audimat_24_white.fnt"
                                                                  width:315.0f
                                                              alignment:kCCTextAlignmentLeft];
        descriptiveText.position = ccp([[CCDirector sharedDirector] winSize].width * 0.65f,[[CCDirector sharedDirector] winSize].height * 0.97 );
        descriptiveText.anchorPoint = ccp(0,1);
        [self addChild:descriptiveText z:12 tag:9999];
        
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
        
    }
    return self;
}


@end
