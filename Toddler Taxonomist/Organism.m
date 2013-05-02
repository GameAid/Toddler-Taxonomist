//
//  Organism.m
//  Toddler Taxonomist
//
//  Created by Clay Heaton on 4/17/13.
//  Copyright (c) 2013 The Perihelion Group. All rights reserved.
//

#import "Organism.h"
#import "NSString+UnicodeUtilities.h"

@implementation Organism

- (id) initWithArray:(NSArray *)csvArray
{
    self = [super init];
    if (self) {
        [self categorizeWithArray:csvArray];
    }
    return self;
}

- (void) categorizeWithArray:(NSArray *)csvArray
{
    // Self-categorize
    [self setGenericName:         [csvArray objectAtIndex:0]];
    [self setSpecificName:        [csvArray objectAtIndex:1]];
    [self setScientificName:      [csvArray objectAtIndex:2]];
    [self setKingdomName:         [csvArray objectAtIndex:3]];
    [self setPhylumName:          [csvArray objectAtIndex:4]];
    [self setClassName:           [csvArray objectAtIndex:5]];
    [self setSubclassName:        [csvArray objectAtIndex:6]];
    [self setInfraclassName:      [csvArray objectAtIndex:7]];
    [self setSuperOrderName:      [csvArray objectAtIndex:8]];
    [self setOrderName:           [csvArray objectAtIndex:9]];
    [self setSubOrderName:        [csvArray objectAtIndex:10]];
    [self setFamilyName:          [csvArray objectAtIndex:11]];
    [self setSubfamilyName:       [csvArray objectAtIndex:12]];
    [self setGenusName:           [csvArray objectAtIndex:13]];
    [self setSpeciesName:         [csvArray objectAtIndex:14]];
    [self setSubspeciesName:      [csvArray objectAtIndex:15]];
    [self setIsMammal:            [(NSString *)[csvArray objectAtIndex:16] boolValue]];
    [self setIsArthropod:         [(NSString *)[csvArray objectAtIndex:17] boolValue]];
    [self setIsReptile:           [(NSString *)[csvArray objectAtIndex:18] boolValue]];
    [self setIsAmphibian:         [(NSString *)[csvArray objectAtIndex:19] boolValue]];
    [self setIsEndangered:        [(NSString *)[csvArray objectAtIndex:20] boolValue]];
    [self setIsExtinct:           [(NSString *)[csvArray objectAtIndex:21] boolValue]];
    [self setIsNocturnal:         [(NSString *)[csvArray objectAtIndex:22] boolValue]];
    [self setImagePrefix:         [csvArray objectAtIndex:23]];
    [self setImageSource:         [csvArray objectAtIndex:24]];
    [self setOrganismDescription: [csvArray objectAtIndex:25]];
    [self setWikipediaLink:       [csvArray objectAtIndex:26]];
    [self setGenericFileName:     [csvArray objectAtIndex:27]];
    [self setPhotoCredit:         [csvArray objectAtIndex:28]];
}

- (NSString *)sound_thats_generic
{
    return [NSString stringWithFormat:@"thats_%@%@",[self genericFileName], @".mp3"];
}

- (NSString *)sound_thats_specific
{
    return [NSString stringWithFormat:@"thats_%@%@",[self imagePrefix], @".mp3"];
}

- (NSString *)sound_where_generic
{
    return [NSString stringWithFormat:@"where_%@%@",[self genericFileName], @".mp3"];
}

- (NSString *)sound_where_specific
{
    return [NSString stringWithFormat:@"where_%@%@",[self imagePrefix], @".mp3"];
}

- (NSString *)picSized:(int)dim1 by:(int)dim2
{
    return [NSString stringWithFormat:@"%@_%i-%i.jpg", [self imagePrefix], dim1, dim2];
}

- (NSString *)sound_thats_scientific
{
    NSString *str = [NSString stringWithFormat:@"thats_sci_%@%@",[self imagePrefix], @".mp3"];
    NSLog(@"that's sound: %@", str);
    return str;
}

- (NSString *)sound_where_scientific
{
    NSString *str = [NSString stringWithFormat:@"where_sci_%@%@",[self imagePrefix], @".mp3"];
    NSLog(@"question sound: %@", str);
    return str;
}

- (NSString *)properSpeciesName
{
    NSString *answer = [NSString stringWithFormat:@"%@. %@",[[self genusName] substringWithRange:NSMakeRange(0, 1)], [self speciesName] ];
    return answer;
}

- (NSString *)properSubspeciesName
{
    NSString *answer = [NSString stringWithFormat:@"%@. %@. %@",[[self genusName] substringWithRange:NSMakeRange(0, 1)], [[self speciesName] substringWithRange:NSMakeRange(0, 1)], [self subspeciesName] ];
    return answer;
}

@end
