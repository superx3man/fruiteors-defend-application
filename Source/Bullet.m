//
//  Bullet.m
//  ThroughTheFruiteors
//
//  Created by Calvin Ng on 4/17/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Bullet.h"

#import "CCNode+AntialisedUpdate.h"

#import "MainScene.h"
#import "Effect.h"

static const CGFloat effectSpawnRateSmoke = 0.15f;

@implementation Bullet
{
    CCSprite *_bullet;
    
    BOOL _isDestroying;
}

@synthesize bulletColor;

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
    [animationManager runAnimationsForSequenceNamed:@"Destroy"];
}

- (void)didLoadFromCCB
{
    _isDestroying = NO;
    
    [self setBulletColor:RainbowColorPurple];
}

#pragma mark - Time Update
- (void)update:(CCTime)delta
{
    [self updateSmokeEffect:delta];
    
    [CCNode setAntialised:NO onNode:self];
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

#pragma mark - Properties
- (void)setBulletColor:(RainbowColor)color
{
    bulletColor = color;
    _bullet.color = [Rainbow getCCColorFromRainbowColor:color];
}

#pragma mark - Animation Delegate
- (void)completedAnimationSequenceNamed:(NSString *)name
{
    if ([name isEqualToString:@"Destroy"]) {
        [self removeFromParentAndCleanup:YES];
    }
}

@end
