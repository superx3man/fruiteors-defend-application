//
//  Fruit.h
//  ThroughTheFruiteors
//
//  Created by Calvin Ng on 4/17/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCSprite.h"

#import "Rainbow.h"

typedef NS_ENUM(NSInteger, FruitType)
{
    FruitTypeGrape,
    FruitTypePear,
    FruitTypeBanana,
    FruitTypeOrange,
    FruitTypeApple
};

@interface Fruit : CCSprite <CCBAnimationManagerDelegate>

@property (nonatomic, assign) FruitType fruitType;
@property (nonatomic, assign) RainbowColor fruitColor;

- (void)runDestroyAnimation;

@end
