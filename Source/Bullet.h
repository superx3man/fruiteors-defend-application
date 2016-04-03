//
//  Bullet.h
//  ThroughTheFruiteors
//
//  Created by Calvin Ng on 4/17/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCSprite.h"

#import "Rainbow.h"

@interface Bullet : CCSprite <CCBAnimationManagerDelegate>

@property (nonatomic, assign, setter = setBulletColor:) RainbowColor bulletColor;

- (void)runDestroyAnimation;

@end
