//
//  ShootingStar.m
//  ThroughTheFruiteors
//
//  Created by Calvin Ng on 4/16/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "ShootingStar.h"

#import "CCNode+AntialisedUpdate.h"

@implementation ShootingStar

#pragma mark - Time Update
- (void)update:(CCTime)delta
{
    [CCNode setAntialised:NO onNode:self];
}

@end
