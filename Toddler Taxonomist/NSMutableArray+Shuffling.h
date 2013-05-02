//
//  NSMutableArray+Shuffling.h
//  Toddler Taxonomist
//
//  Created by Clay Heaton on 4/20/13.
//  Copyright (c) 2013 The Perihelion Group. All rights reserved.
//
// From http://stackoverflow.com/questions/56648/whats-the-best-way-to-shuffle-an-nsmutablearray

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// This category enhances NSMutableArray by providing
// methods to randomly shuffle the elements.
@interface NSMutableArray (Shuffling)
- (void)shuffle;
@end
