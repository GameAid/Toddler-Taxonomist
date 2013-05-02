//
//  Organism.h
//  Toddler Taxonomist
//
//  Created by Clay Heaton on 4/17/13.
//  Copyright (c) 2013 The Perihelion Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Organism : NSObject

@property (copy, nonatomic) NSString *genericName;
@property (copy, nonatomic) NSString *specificName;
@property (copy, nonatomic) NSString *scientificName; // Binomial or Trinomial

@property (copy, nonatomic) NSString *kingdomName;
@property (copy, nonatomic) NSString *phylumName;
@property (copy, nonatomic) NSString *className;
@property (copy, nonatomic) NSString *subclassName;
@property (copy, nonatomic) NSString *infraclassName;
@property (copy, nonatomic) NSString *superOrderName;
@property (copy, nonatomic) NSString *orderName;
@property (copy, nonatomic) NSString *subOrderName;
@property (copy, nonatomic) NSString *familyName;
@property (copy, nonatomic) NSString *subfamilyName;
@property (copy, nonatomic) NSString *genusName;
@property (copy, nonatomic) NSString *speciesName;
@property (copy, nonatomic) NSString *subspeciesName;

@property (nonatomic, readwrite) BOOL isMammal;
@property (nonatomic, readwrite) BOOL isArthropod;
@property (nonatomic, readwrite) BOOL isReptile;
@property (nonatomic, readwrite) BOOL isAmphibian;
@property (nonatomic, readwrite) BOOL isEndangered;
@property (nonatomic, readwrite) BOOL isExtinct;
@property (nonatomic, readwrite) BOOL isNocturnal;

@property (copy, nonatomic) NSString *imagePrefix;
@property (copy, nonatomic) NSString *imageSource;

@property (copy, nonatomic) NSString *organismDescription;
@property (copy, nonatomic) NSString *wikipediaLink;

@property (copy, nonatomic) NSString *genericFileName; // Only used for loading sounds

@property (copy, nonatomic) NSString *photoCredit;

- (id) initWithArray:(NSArray *)csvArray;

- (NSString *)picSized:(int)dim1 by:(int)dim2;

// Played when question choice is incorrect
- (NSString *)sound_thats_generic;
- (NSString *)sound_thats_specific;
- (NSString *)sound_thats_scientific;

// Played as question
- (NSString *)sound_where_generic;
- (NSString *)sound_where_specific;
- (NSString *)sound_where_scientific;

- (NSString *)properSpeciesName;
- (NSString *)properSubspeciesName;
@end