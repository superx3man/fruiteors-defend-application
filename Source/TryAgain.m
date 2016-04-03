//
//  TryAgain.m
//  ThroughTheFruiteors
//
//  Created by Calvin Ng on 4/20/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "TryAgain.h"

#import "CCNode+AntialisedUpdate.h"

@implementation TryAgain

- (void)didLoadFromCCB
{
    [CCNode setAntialised:NO onNode:self];
}

@end
