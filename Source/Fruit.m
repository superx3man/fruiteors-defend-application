//
//  Fruit.m
//  ThroughTheFruiteors
//
//  Created by Calvin Ng on 4/17/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Fruit.h"

#import "CCNode+AntialisedUpdate.h"

#import "MainScene.h"
#import "Effect.h"

static const CGFloat effectSpawnRateTail = 0.15f;
static const CGFloat effectSpawnRateSmoke = 0.15f;

@implementation Fruit
{
    BOOL _isDestroying;
}

@synthesize fruitType, fruitColor;

- (void)runDestroyAnimation
{
    _isDestroying = YES;
    
    self.physicsBody.force = ccp(0.f, 0.f);
    self.physicsBody.velocity = ccp(0.f, 0.f);
    self.physicsBody.torque = 0.f;
    self.physicsBody.angularVelocity = 0.f;
    
    self.physicsBody.collisionMask = @[];
    
    CCBAnimationManager* animationManager = self.userObject;
    animationManager.delegate = self;
    [animationManager runAnimationsForSequenceNamed:@"Animate"];
}

- (void)didLoadFromCCB
{
    _isDestroying = NO;
    
    [CCNode setAntialised:NO onNode:self];
}

#pragma mark - Time Update
- (void)update:(CCTime)delta
{
    [self updateTailingEffect:delta];
    [self updateSmokeEffect:delta];
    
    [CCNode setAntialised:NO onNode:self];
}

- (void)updateTailingEffect:(CCTime)delta
{
    static CCTime deltaTotal = 0;
    if (!_isDestroying) {
        deltaTotal += delta;
        if (deltaTotal > effectSpawnRateTail) {
            deltaTotal = 0;
            
            Effect *effect = (Effect *)[CCBReader load:[NSString stringWithFormat:@"Sprites/Effects/Sparkling%d", (arc4random() % 2 + 1)]];
            effect.scale = self.scale;
            effect.position = ccp(self.position.x + arc4random() % 30 - 15, self.position.y + arc4random() % 30 - 15);
            effect.anchorPoint = self.anchorPoint;
            effect.zOrder = MainSceneDrawingOrderSparkling;
            
            [self.parent addChild:effect];
            [effect runAnimation];
        }
    }
}

- (void)updateSmokeEffect:(CCTime)delta
{
    static CCTime deltaTotal = 0;
    if (_isDestroying) {
        deltaTotal += delta;
        if (deltaTotal > effectSpawnRateSmoke) {
            deltaTotal = 0;
            
            Effect *effect = (Effect *)[CCBReader load:@"Sprites/Effects/Smoke"];
            effect.scale = self.scale;
            effect.position = ccp(self.position.x + arc4random() % 40 - 20, self.position.y + arc4random() % 40 - 20);
            effect.anchorPoint = self.anchorPoint;
            effect.zOrder = MainSceneDrawingOrderSmoke;
            
            [self.parent addChild:effect];
            [effect runAnimation];
        }
    }
}

#pragma mark - Animation Delegate
- (void)completedAnimationSequenceNamed:(NSString *)name
{
    [self removeFromParentAndCleanup:YES];
}

@end
