//
//  AnimalCatalogue.m
//  Toddler Taxonomist
//
//  Created by Clay Heaton on 4/17/13.
//  Copyright (c) 2013 The Perihelion Group. All rights reserved.
//

#import "AnimalCatalogue.h"
#import "parseCSV.h"
#import "Organism.h"
#import "BoardLayer.h" // Only to get the struct -- move this elsewhere; constants, etc.
#import "Tile.h"

@implementation AnimalCatalogue

static AnimalCatalogue *sharedAnimalCatalogue;


+(AnimalCatalogue *)animalCatalogue
{
    if (!sharedAnimalCatalogue) {
        sharedAnimalCatalogue = [[AnimalCatalogue alloc] init];
    }
    return sharedAnimalCatalogue;
}

- (id) init
{
    self = [super init];
    if (self) {
        
        [self initializeDictionaries];
        
        // Import the CSV file
        if (![self importCSV]) {
            NSLog(@"CSV importing failed");
        }
        
        [self makeOrganisms];
        // NSLog(@"_endangered: %@", _endangeredSpecies);
    }
    return self;
}


- (void) initializeDictionaries
{
    _allOrganisms           = [[NSMutableArray alloc] init];
    _allOrganismsReference  = [[NSMutableArray alloc] init];
    
    _genericNames       = [[NSMutableDictionary alloc] init];
    _specificNames      = [[NSMutableDictionary alloc] init];
    _scientificNames    = [[NSMutableDictionary alloc] init];
    _kingdoms           = [[NSMutableDictionary alloc] init];
    _phylums            = [[NSMutableDictionary alloc] init];
    _classes            = [[NSMutableDictionary alloc] init];
    _subclasses         = [[NSMutableDictionary alloc] init];
    _infraclasses       = [[NSMutableDictionary alloc] init];
    _orders             = [[NSMutableDictionary alloc] init];
    _families           = [[NSMutableDictionary alloc] init];
    _subfamilies        = [[NSMutableDictionary alloc] init];
    _genuses            = [[NSMutableDictionary alloc] init];
    _species            = [[NSMutableDictionary alloc] init];
    _subspecies         = [[NSMutableDictionary alloc] init];
    
    _mammals            = [[NSMutableDictionary alloc] init];
    _arthropods         = [[NSMutableDictionary alloc] init];
    _reptiles           = [[NSMutableDictionary alloc] init];
    _amphibians         = [[NSMutableDictionary alloc] init];
    _endangeredSpecies  = [[NSMutableDictionary alloc] init];
    _extinctSpecies     = [[NSMutableDictionary alloc] init];
    
    _usedOrganisms      = [[NSMutableSet alloc] init];
}

- (BOOL) importCSV
{
    CSVParser *parser = [CSVParser new];
    
    //get the path to the file in your xcode project's resource path
    NSString *csvFilePath = [[NSBundle mainBundle] pathForResource:@"animal_list" ofType:@"csv"];
    
    [parser openFile:csvFilePath];
    
    NSMutableArray *content = [parser parseFile];
    
    
    [self setCsvContent:content];
    
    /*
    for (int i = 0; i < [_csvContent count]; i++) {
        NSLog(@"content of line %d: %@", i, [_csvContent objectAtIndex:i]);
    }
     */
     
    
    [parser closeFile];
    parser = nil;
    return YES;
}

- (void) makeOrganisms
{
    // 0 is for the headers
    int csvRows = [_csvContent count];
    
    for (int i = 1; i < csvRows; i++) {
        NSArray *organismParts = [_csvContent objectAtIndex:i];
        
        Organism *o = [[Organism alloc] initWithArray:organismParts];
        //CCLOG(@"organism: %@", [o specificName]);
        [_allOrganisms addObject:o];
        
        // We never will change _allOrganismsReference
        [_allOrganismsReference addObject:o];
        
        [self categorizeOrganism:o      intoDictionary:_genericNames        usingKey:[o genericName]];
        [self categorizeOrganism:o      intoDictionary:_specificNames       usingKey:[o specificName]];
        [self categorizeOrganism:o      intoDictionary:_scientificNames     usingKey:[o scientificName]];
        [self categorizeOrganism:o      intoDictionary:_kingdoms            usingKey:[o kingdomName]];
        [self categorizeOrganism:o      intoDictionary:_phylums             usingKey:[o phylumName]];
        [self categorizeOrganism:o      intoDictionary:_classes             usingKey:[o className]];
        [self categorizeOrganism:o      intoDictionary:_subclasses          usingKey:[o subclassName]];
        [self categorizeOrganism:o      intoDictionary:_infraclasses        usingKey:[o infraclassName]];
        [self categorizeOrganism:o      intoDictionary:_superorders         usingKey:[o superOrderName]];
        [self categorizeOrganism:o      intoDictionary:_orders              usingKey:[o orderName]];
        [self categorizeOrganism:o      intoDictionary:_suborders           usingKey:[o subOrderName]];
        [self categorizeOrganism:o      intoDictionary:_families            usingKey:[o familyName]];
        [self categorizeOrganism:o      intoDictionary:_subfamilies         usingKey:[o subfamilyName]];
        [self categorizeOrganism:o      intoDictionary:_genuses             usingKey:[o genusName]];
        [self categorizeOrganism:o      intoDictionary:_species             usingKey:[o speciesName]];
        [self categorizeOrganism:o      intoDictionary:_subspecies          usingKey:[o subspeciesName]];
        
        if ([o isMammal]) {
            [self categorizeOrganism:o      intoDictionary:_mammals             usingKey:@"YES"];
        } else {
            [self categorizeOrganism:o      intoDictionary:_mammals             usingKey:@"NO"];
        }
        
        if ([o isArthropod]) {
            [self categorizeOrganism:o      intoDictionary:_arthropods          usingKey:@"YES"];
        } else {
            [self categorizeOrganism:o      intoDictionary:_arthropods          usingKey:@"NO"];
        }
        
        if ([o isReptile]) {
            [self categorizeOrganism:o      intoDictionary:_reptiles            usingKey:@"YES"];
        } else {
            [self categorizeOrganism:o      intoDictionary:_reptiles            usingKey:@"NO"];
        }
        
        if ([o isAmphibian]) {
            [self categorizeOrganism:o      intoDictionary:_amphibians          usingKey:@"YES"];
        } else {
            [self categorizeOrganism:o      intoDictionary:_amphibians          usingKey:@"NO"];
        }
        
        if ([o isEndangered]) {
            [self categorizeOrganism:o      intoDictionary:_endangeredSpecies   usingKey:@"YES"];
        } else {
            [self categorizeOrganism:o      intoDictionary:_endangeredSpecies   usingKey:@"NO"];
        }
        
        if ([o isExtinct]) {
            [self categorizeOrganism:o      intoDictionary:_extinctSpecies      usingKey:@"YES"];
        } else {
            [self categorizeOrganism:o      intoDictionary:_extinctSpecies      usingKey:@"NO"];
        }
        
        if ([o isNocturnal]) {
            [self categorizeOrganism:o      intoDictionary:_nocturnalSpecies    usingKey:@"YES"];
        } else {
            [self categorizeOrganism:o      intoDictionary:_nocturnalSpecies    usingKey:@"NO"];
        }
        o = nil;
    }
}

- (void) categorizeOrganism:(Organism *)org intoDictionary:(NSMutableDictionary *)dict usingKey:(NSString *)orgKey
{
    
    // Check for the presence of the array for the dictionary key
    NSMutableArray *obj = [dict objectForKey:orgKey];
    
    // If the array doesn't exist, then create it and add it to the dictionary
    // using the proper key
    if (!obj) {
        obj = [[NSMutableArray alloc] init];
        [dict setObject:obj forKey:orgKey];
    }
    
    // Add the object to the dictionary
    [[dict objectForKey:orgKey] addObject:org];

}

- (void) resetCatalogue
{
    [_allOrganisms setArray:_allOrganismsReference];
}

- (void) resetUsedOrganisms
{
    [_usedOrganisms removeAllObjects];
}

- (NSDictionary *)answersForDifficulty:(QuestionDifficulty)qd andPicMode:(PictureMode)pm
{
    
    // Check whether there are too many organisms in _usedOrganisms and reset it.
    // All organisms will again be available as answers.
    if ([_usedOrganisms count] > [_allOrganisms count] - 1) {
        [self resetUsedOrganisms];
        CCLOG(@"Resetting used organisms because it is too full...");
    }
    
    
    QuestionType qt = QuestionTypeSpecificName;
    int extraTiles = 0;
    
    switch (qd) {
        case DifficultyBrowse:
            qt = QuestionTypeGenericName;
            break;
            
        // The additional cases need to choose between question types.
        // Easy will only use Generic name
        case DifficultyEasy:
            qt = QuestionTypeGenericName;
            break;
            
        case DifficultyMedium:
            qt = QuestionTypeSpecificName;
            break;
            
        case DifficultyHard:
            qt = QuestionTypeScientificName;
            break;
            
        case DifficultyExtreme:
            qt = QuestionTypeScientificName;
            break;
            
        default:
            break;
    }
    
    switch (pm) {
        case PictureModePictures_01:
            extraTiles = 0;
            break;
        case PictureModePictures_02:
            extraTiles = 1;
            break;
        case PictureModePictures_04:
            extraTiles = 3;
            break;
        case PictureModePictures_08:
            extraTiles = 7;
            break;
        case PictureModePictures_40:
            extraTiles = 39;
            break;
            
            
        default:
            break;
    }
    
    Organism *answer;
    NSString *answerKey;
    NSArray  *answerChoices;
    NSArray  *answerArray;
    NSString *answerString;
    
    switch (qt) {
        case QuestionTypeGenericName:
            answerChoices = [_genericNames allKeys];
            answerKey     = [answerChoices objectAtIndex:arc4random()%[answerChoices count]];
            answerArray   = [_genericNames objectForKey:answerKey];
            answer        = [answerArray objectAtIndex:arc4random()%[answerArray count]];
            
            while ([_usedOrganisms containsObject:answer]) {
                answerKey     = [answerChoices objectAtIndex:arc4random()%[answerChoices count]];
                answerArray   = [_genericNames objectForKey:answerKey];
                answer        = [answerArray objectAtIndex:arc4random()%[answerArray count]];
            }
            
            [_usedOrganisms addObject:answer];
            answerString  = [answer genericName];
            break;
            
        case QuestionTypeSpecificName:
            answerChoices = [_specificNames allKeys];
            answerKey     = [answerChoices objectAtIndex:arc4random()%[answerChoices count]];
            answerArray   = [_specificNames objectForKey:answerKey];
            answer        = [answerArray objectAtIndex:arc4random()%[answerArray count]];
            
            while ([_usedOrganisms containsObject:answer]) {
                answerKey     = [answerChoices objectAtIndex:arc4random()%[answerChoices count]];
                answerArray   = [_specificNames objectForKey:answerKey];
                answer        = [answerArray objectAtIndex:arc4random()%[answerArray count]];
            }
            
            [_usedOrganisms addObject:answer];
            answerString  = [answer specificName];
            break;
            
        case QuestionTypeScientificName:
            answerChoices = [_scientificNames allKeys];
            answerKey     = [answerChoices objectAtIndex:arc4random()%[answerChoices count]];
            answerArray   = [_scientificNames objectForKey:answerKey];
            answer        = [answerArray objectAtIndex:arc4random()%[answerArray count]];
            
            while ([_usedOrganisms containsObject:answer]) {
                answerKey     = [answerChoices objectAtIndex:arc4random()%[answerChoices count]];
                answerArray   = [_scientificNames objectForKey:answerKey];
                answer        = [answerArray objectAtIndex:arc4random()%[answerArray count]];
            }
            
            [_usedOrganisms addObject:answer];
            answerString  = [answer scientificName];
            break;
            
        default:
            // Same as QuestionTypeGenericName
            answerChoices = [_genericNames allKeys];
            answerKey     = [answerChoices objectAtIndex:arc4random()%[answerChoices count]];
            answerArray   = [_genericNames objectForKey:answerKey];
            answer        = [answerArray objectAtIndex:arc4random()%[answerArray count]];
            
            while ([_usedOrganisms containsObject:answer]) {
                answerKey     = [answerChoices objectAtIndex:arc4random()%[answerChoices count]];
                answerArray   = [_genericNames objectForKey:answerKey];
                answer        = [answerArray objectAtIndex:arc4random()%[answerArray count]];
            }
            
            [_usedOrganisms addObject:answer];
            answerString  = [answer genericName];
            break;
    }
    
    NSString *questionString = [NSString stringWithFormat:@"Where is the %@?", answerString];
    
    CCLOG(@"answerString: %@", answerString);
    
    // Remove from _allOrganisms all organisms in the answerArray
    // If the answer is an elephant, this should remove all of the elephants from the _allOrganisms array
    // so that there isn't another elephant chosen for the other tiles.
    // Note: This may need to change if there is a question type that has multiple answers.
    
    for (Organism *org in answerArray) {
        [_allOrganisms removeObject:org];
    }
    // [_allOrganisms removeObject:answer];
    
    
    // Make an array of organisms that aren't the answer
    NSMutableArray *extraOrganisms = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < extraTiles; i++) {
        Organism *o = [_allOrganisms objectAtIndex:arc4random()%[_allOrganisms count]];
        [extraOrganisms addObject:o];
        [_allOrganisms removeObject:o];
        o = nil;
    }
    
    NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:
                            questionString,  @"questionString",
                            answer,          @"answer",
                            extraOrganisms,  @"extraTiles",
                            nil];
    
    [self resetCatalogue];
    
    return result;
}

- (Tile *)tileForOrganism:(Organism *)o forPictureMode:(int)mode isRetina:(BOOL)retina
{
    if (!o) {
        o = [_allOrganisms objectAtIndex:arc4random()%[_allOrganisms count]];
    }
    
    [_allOrganisms removeObject:o];
    
    int dim1 = 1280;
    int dim2 = 1280;
    
    float retinaScale;
    
    if (retina) {
        retinaScale = 1.0f;
    } else {
        retinaScale = 0.5f;
    }
    
    switch (mode) {
        case PictureModePictures_01:
            dim1 = 1280;
            dim2 = 1280;
            break;
            
        case PictureModePictures_02:
            dim1 = 1024;
            dim2 = 1280;
            break;
            
        case PictureModePictures_04:
            dim1 = 1024;
            dim2 = 640;
            break;
        
        case PictureModePictures_08:
            dim1 = 512;
            dim2 = 640;
            break;
            
        case PictureModePictures_40:
            dim1 = 256;
            dim2 = 256;
            
        default:
            break;
    }
    
    NSString *file = [o picSized:dim1 by:dim2];
    
    Tile *t = [[Tile alloc] initWithFile:file];
    [t setOrganism:o];
    
    [t setScale:retinaScale];
    return t;
    
}

- (Organism *) randomOrganism
{
    Organism *o = [_allOrganisms objectAtIndex:arc4random()%[_allOrganisms count]];
    [_allOrganisms removeObject:o];
    return o;
}

@end
