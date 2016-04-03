//
//  CCNode+AntialisedUpdate.m
//  ThroughTheFruiteors
//
//  Created by Calvin Ng on 4/17/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode+AntialisedUpdate.h"

@implementation CCNode (AntialisedUpdate)

+ (void)setAntialised:(BOOL)antialised onNode:(CCNode *)parentNode
{
    if ([parentNode isKindOfClass:[CCSprite class]]) {
        CCTexture *texture = [((CCSprite *)parentNode) texture];
        if (texture.antialiased != antialised) {
            texture.antialiased = antialised;
        }
    }
    for (CCNode *node in parentNode.children) {
        [self setAntialised:antialised onNode:node];
    }
}

@end
