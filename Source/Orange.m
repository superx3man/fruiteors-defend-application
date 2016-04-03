//
//  Orange.m
//  ThroughTheFruiteors
//
//  Created by Calvin Ng on 4/18/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Orange.h"

@implementation Orange

- (id)init
{
    if (self = [super init]) {
        super.fruitType = FruitTypeOrange;
        super.fruitColor = RainbowColorOrange;
    }
    return self;
}

@end
