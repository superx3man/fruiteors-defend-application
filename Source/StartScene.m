//
//  StartScene.m
//  ThroughTheFruiteors
//
//  Created by Calvin Ng on 4/20/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "StartScene.h"

#import "CCNode+AntialisedUpdate.h"
#import "GameCenterHelper.h"

#import "MainScene.h"
#import "Rainbow.h"
#import "Fruit.h"
#import "TryAgain.h"

static const CGFloat spriteScaleSize = 4.f;

static const CGFloat scrollSpeed = 80.f;
static const CGFloat scrollRatioBackground = 0.3f;
static const CGFloat scrollRatioStarsSmall = 0.7f;
static const CGFloat scrollRatioStarsLarge = 1.f;

@implementation StartScene
{
    CCNode *_background;
    CCNode *_starsSmall;
    CCNode *_starsLarge;
    Rainbow *_rainbow;
    
    CCNode *_logo;
    
    CCSprite *_grape;
    CCSprite *_banana;
    CCSprite *_pear;
    CCSprite *_apple;
    CCSprite *_orange;
}

- (void)didLoadFromCCB
{
    self.userInteractionEnabled = YES;
    
    [CCNode setAntialised:NO onNode:self];
    
    _background.zOrder = StartSceneDrawingOrderBackground;
    _starsSmall.zOrder = StartSceneDrawingOrderStarsSmall;
    _starsLarge.zOrder = StartSceneDrawingOrderStarsLarge;
    
    _rainbow.zOrder = StartSceneDrawingOrderRainbow;
    _logo.zOrder = StartSceneDrawingOrderLogo;
    
    _grape.zOrder = StartSceneDrawingOrderFruit;
    CCActionRotateBy *grapeRotateBy = [CCActionRotateBy actionWithDuration:1.f angle:90.f];
    CCActionRepeatForever *grapeRepeatForever = [CCActionRepeatForever actionWithAction:grapeRotateBy];
    [_grape runAction:grapeRepeatForever];
    
    _banana.zOrder = StartSceneDrawingOrderFruit;
    CCActionRotateBy *bananaRotateBy = [CCActionRotateBy actionWithDuration:1.f angle:-70.f];
    CCActionRepeatForever *bananaRepeatForever = [CCActionRepeatForever actionWithAction:bananaRotateBy];
    [_banana runAction:bananaRepeatForever];
    
    _pear.zOrder = StartSceneDrawingOrderFruit;
    CCActionRotateBy *pearRotateBy = [CCActionRotateBy actionWithDuration:1.f angle:-85.f];
    CCActionRepeatForever *pearRepeatForever = [CCActionRepeatForever actionWithAction:pearRotateBy];
    [_pear runAction:pearRepeatForever];
    
    _orange.zOrder = StartSceneDrawingOrderFruit;
    CCActionRotateBy *orangeRotateBy = [CCActionRotateBy actionWithDuration:1.f angle:75.f];
    CCActionRepeatForever *orangeRepeatForever = [CCActionRepeatForever actionWithAction:orangeRotateBy];
    [_orange runAction:orangeRepeatForever];
    
    _apple.zOrder = StartSceneDrawingOrderFruit;
    CCActionRotateBy *appleRotateBy = [CCActionRotateBy actionWithDuration:1.f angle:80.f];
    CCActionRepeatForever *appleRepeatForever = [CCActionRepeatForever actionWithAction:appleRotateBy];
    [_apple runAction:appleRepeatForever];
    
    TryAgain *tryAgain = (TryAgain *)[CCBReader load:@"Nodes/TryAgain"];
    tryAgain.anchorPoint = ccp(0.5f, 0.f);
    tryAgain.positionType = CCPositionTypeMake(CCPositionUnitNormalized, CCPositionUnitPoints, CCPositionReferenceCornerBottomLeft);
    tryAgain.position = ccp(0.5f, 70.f);
    tryAgain.zOrder = StartSceneDrawingOrderStartButton;
    
    [self addChild:tryAgain];
}

#pragma mark - Time Update
- (void)update:(CCTime)delta
{
    [self updateParallaxBackground:delta];
}

- (void)updateParallaxBackground:(CCTime)delta
{
    _background.position = ccp(_background.position.x, _background.position.y - (delta * scrollSpeed * scrollRatioBackground));
    for (CCNode *background in _background.children) {
        CGPoint worldPosition = [_background convertToWorldSpace:background.position];
        CGPoint screenPosition = [self convertToNodeSpace:worldPosition];
        
        if (screenPosition.y <= (-1 * background.contentSize.height * spriteScaleSize)) {
            background.position = ccp(background.position.x, background.position.y + 2 * background.contentSize.height * spriteScaleSize);
        }
    }
    
    _starsSmall.position = ccp(_starsSmall.position.x, _starsSmall.position.y - (delta * scrollSpeed * scrollRatioStarsSmall));
    for (CCNode *starsSmall in _starsSmall.children) {
        CGPoint worldPosition = [_starsSmall convertToWorldSpace:starsSmall.position];
        CGPoint screenPosition = [self convertToNodeSpace:worldPosition];
        
        if (screenPosition.y <= (-1 * starsSmall.contentSize.height * spriteScaleSize)) {
            starsSmall.position = ccp(starsSmall.position.x, starsSmall.position.y + 2 * starsSmall.contentSize.height * spriteScaleSize);
        }
    }
    
    _starsLarge.position = ccp(_starsLarge.position.x, _starsLarge.position.y - (delta * scrollSpeed * scrollRatioStarsLarge));
    for (CCNode *starsLarge in _starsLarge.children) {
        CGPoint worldPosition = [_starsLarge convertToWorldSpace:starsLarge.position];
        CGPoint screenPosition = [self convertToNodeSpace:worldPosition];
        
        if (screenPosition.y <= (-1 * starsLarge.contentSize.height * spriteScaleSize)) {
            starsLarge.position = ccp(starsLarge.position.x, starsLarge.position.y + 2 * starsLarge.contentSize.height * spriteScaleSize);
        }
    }
}

#pragma mark - Touch Events
- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
}

- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    [[OALSimpleAudio sharedInstance] playEffect:@"Published-iOS/Sound/retry.caf"];
    [[CCDirector sharedDirector] replaceScene:[CCBReader loadAsScene:@"MainScene"] withTransition:[CCTransition transitionFadeWithDuration:0.5f]];
}


@end
