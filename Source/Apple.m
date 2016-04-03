//
//  Apple.m
//  ThroughTheFruiteors
//
//  Created by Calvin Ng on 4/18/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Apple.h"

@implementation Apple

- (id)init
{
    if (self = [super init]) {
        super.fruitType = FruitTypeApple;
        super.fruitColor = RainbowColorRed;
    }
    return self;
}

@end
