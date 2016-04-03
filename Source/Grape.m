//
//  Grape.m
//  ThroughTheFruiteors
//
//  Created by Calvin Ng on 4/17/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Grape.h"

@implementation Grape

- (id)init
{
    if (self = [super init]) {
        super.fruitType = FruitTypeGrape;
        super.fruitColor = RainbowColorPurple;
    }
    return self;
}

@end
