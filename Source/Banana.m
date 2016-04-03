//
//  Banana.m
//  ThroughTheFruiteors
//
//  Created by Calvin Ng on 4/18/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Banana.h"

@implementation Banana

- (id)init
{
    if (self = [super init]) {
        super.fruitType = FruitTypeBanana;
        super.fruitColor = RainbowColorYellow;
    }
    return self;
}

@end
