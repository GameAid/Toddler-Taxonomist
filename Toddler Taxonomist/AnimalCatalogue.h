//
//  AnimalCatalogue.h
//  Toddler Taxonomist
//
//  Created by Clay Heaton on 4/17/13.
//  Copyright (c) 2013 The Perihelion Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BoardLayer.h"

typedef enum
{
	DifficultyINVALID     = 0,
    DifficultyBrowse  = 1,
	DifficultyEasy    = 2,
    DifficultyMedium  = 3,
    DifficultyHard    = 4,
    DifficultyExtreme = 5,
	DifficultyMAX
} QuestionDifficulty;

typedef enum
{
    QuestionTypeINVALID = 0,
    QuestionTypeGenericName,
    QuestionTypeSpecificName,
    QuestionTypeScientificName,
    QuestionTypeMAX
} QuestionType;

@class Tile;
@class Organism;

@interface AnimalCatalogue : NSObject


@property (strong, nonatomic) NSMutableDictionary *genericNames;
@property (strong, nonatomic) NSMutableDictionary *specificNames;
@property (strong, nonatomic) NSMutableDictionary *scientificNames;
@property (strong, nonatomic) NSMutableDictionary *kingdoms;
@property (strong, nonatomic) NSMutableDictionary *phylums;
@property (strong, nonatomic) NSMutableDictionary *classes;
@property (strong, nonatomic) NSMutableDictionary *subclasses;
@property (strong, nonatomic) NSMutableDictionary *infraclasses;
@property (strong, nonatomic) NSMutableDictionary *superorders;
@property (strong, nonatomic) NSMutableDictionary *orders;
@property (strong, nonatomic) NSMutableDictionary *suborders;
@property (strong, nonatomic) NSMutableDictionary *families;
@property (strong, nonatomic) NSMutableDictionary *subfamilies;
@property (strong, nonatomic) NSMutableDictionary *genuses;
@property (strong, nonatomic) NSMutableDictionary *species;
@property (strong, nonatomic) NSMutableDictionary *subspecies;

@property (strong, nonatomic) NSMutableDictionary *mammals;
@property (strong, nonatomic) NSMutableDictionary *arthropods;
@property (strong, nonatomic) NSMutableDictionary *reptiles;
@property (strong, nonatomic) NSMutableDictionary *amphibians;
@property (strong, nonatomic) NSMutableDictionary *endangeredSpecies;
@property (strong, nonatomic) NSMutableDictionary *extinctSpecies;
@property (strong, nonatomic) NSMutableDictionary *nocturnalSpecies;

@property (strong, nonatomic) NSMutableArray *csvContent;

@property (strong, nonatomic) NSMutableArray *allOrganisms;
@property (strong, nonatomic) NSMutableArray *allOrganismsReference;

@property (strong, nonatomic) NSMutableSet   *usedOrganisms;


+(AnimalCatalogue *)animalCatalogue;
- (Tile *)tileForOrganism:(Organism *)o forPictureMode:(int)mode isRetina:(BOOL)retina;
- (void) resetCatalogue;
- (NSDictionary *)answersForDifficulty:(QuestionDifficulty)qd andPicMode:(PictureMode)pm;

- (Organism *) randomOrganism;
- (void) resetUsedOrganisms;

@end
