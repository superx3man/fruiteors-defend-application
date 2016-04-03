//
//  CCNode+Pause.m
//  ThroughTheFruiteors
//
//  Created by Calvin Ng on 4/20/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode+Pause.h"

@implementation CCNode (Pause)

+ (void)pauseAll:(CCNode *)parentNode
{
    parentNode.paused = YES;
    for (CCNode *node in parentNode.children) {
        [self pauseAll:node];
    }
}

@end
