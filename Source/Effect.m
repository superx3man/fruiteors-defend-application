//
//  Effect.m
//  ThroughTheFruiteors
//
//  Created by Calvin Ng on 4/18/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Effect.h"

#import "CCNode+AntialisedUpdate.h"

@implementation Effect

- (void)runAnimation
{
    CCBAnimationManager* animationManager = self.userObject;
    animationManager.delegate = self;
    [animationManager runAnimationsForSequenceNamed:@"Animate"];
}

#pragma mark - Time Update
- (void)update:(CCTime)delta
{
    [CCNode setAntialised:NO onNode:self];
}

#pragma mark - Animation Delegate
- (void)completedAnimationSequenceNamed:(NSString *)name
{
    if ([name isEqualToString:@"Animate"]) {
        [self removeFromParentAndCleanup:YES];
    }
}

@end
