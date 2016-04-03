//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"

#import "AppDelegate.h"

#import "CCNode+ContentSizeUpdate.h"
#import "CCNode+AntialisedUpdate.h"
#import "CCNode+Pause.h"

#import "ShootingStar.h"
#import "Rainbow.h"
#import "Bullet.h"
#import "Fruit.h"
#import "Multiplier.h"
#import "WhiteOut.h"
#import "BlackOut.h"
#import "GameOverPopup.h"
#import "TryAgain.h"

static const CGFloat spriteScaleSize = 4.f;

static const CGFloat scrollSpeed = 80.f;
static const CGFloat scrollRatioBackground = 0.3f;
static const CGFloat scrollRatioStarsSmall = 0.7f;
static const CGFloat scrollRatioStarsLarge = 1.f;

static const CGFloat eventSpawnRateShootingStar = 5.f;
static const CGFloat eventSpawnRateFruiteorLevel1 = 2.f;
static const CGFloat eventSpawnRateFruiteorLevel2 = 1.2f;
static const CGFloat eventSpawnRateFruiteorLevel3 = 0.8f;
static const CGFloat eventFruitTravelSpeed = 0.5f;
static const CGFloat eventFruitSpinSpeed = 2000.f;
static const int eventFruitTypeChangeRateLevel1 = 5;
static const int eventFruitTypeChangeRateLevel2 = 4;
static const int eventFruitTypeChangeRateLevel3 = 3;

static const int touchRainbowChangeColorRate = 40;
static const CGFloat touchBulletTravelSpeed = 7.f;
static const CGFloat touchBulletSpinSpeed = 50000.f;

static int loseCount = 1;
static const int fullScreenAdLoseCount = 6;

@implementation MainScene
{
    CCNode *_background;
    CCNode *_starsSmall;
    CCNode *_starsLarge;
    Rainbow *_rainbow;
    
    CCNode *_northBoundary;
    CCNode *_eastBoundary;
    CCNode *_southBoundary;
    CCNode *_westBoundary;
    
    CCPhysicsNode *_physicsNode;
    
    CCNode *_information;
    CCLabelTTF *_scoreLabel;
    CCNode *_howTo;
    
    CGPoint _rainbowCenter;
    NSArray *_fruitList;
    NSArray *_fruitSpawnRateLevel;
    
    int _scorePoint;
    int _multiplier;
    
    BOOL _touchMoved;
    UITouch *_dragTouch;
    
    BOOL _gameStarted;
    BOOL _gameOver;
}

- (void)didLoadFromCCB
{
    self.userInteractionEnabled = YES;
    self.multipleTouchEnabled = YES;
    _dragTouch = nil;
    
    [CCNode setAntialised:NO onNode:self];
    _physicsNode.collisionDelegate = self;
    
    _rainbow.physicsBody.collisionType = @"rainbow";
    
    _background.zOrder = MainSceneDrawingOrderBackground;
    _starsSmall.zOrder = MainSceneDrawingOrderStarsSmall;
    _starsLarge.zOrder = MainSceneDrawingOrderStarsLarge;
    
    _physicsNode.zOrder = MainSceneDrawingOrderPhysicsNode;
    _rainbow.zOrder = MainSceneDrawingOrderRainbow;
    
    _information.zOrder = MainSceneDrawingOrderInformation;
    _howTo.cascadeOpacityEnabled = YES;
    
    CGSize screenSize = [CCDirector sharedDirector].designSize;
    _northBoundary.physicsBody = [CCPhysicsBody bodyWithRect:CGRectMake(0, 0, screenSize.width * 1.5f, screenSize.height * 0.1f) cornerRadius:0.f];
    _northBoundary.physicsBody.collisionType = @"boundary";
    _eastBoundary.physicsBody = [CCPhysicsBody bodyWithRect:CGRectMake(0, 0, screenSize.width * 0.1f, screenSize.height * 1.5f) cornerRadius:0.f];
    _eastBoundary.physicsBody.collisionType = @"boundary";
    _southBoundary.physicsBody = [CCPhysicsBody bodyWithRect:CGRectMake(0, 0, screenSize.width * 1.5f, screenSize.height * 0.1f) cornerRadius:0.f];
    _southBoundary.physicsBody.collisionType = @"boundary";
    _westBoundary.physicsBody = [CCPhysicsBody bodyWithRect:CGRectMake(0, 0, screenSize.width * 0.1f, screenSize.height * 1.5f) cornerRadius:0.f];
    _westBoundary.physicsBody.collisionType = @"boundary";
    
    _fruitList = @[@"Grape", @"Pear", @"Banana", @"Orange", @"Apple"];
    
    _scorePoint = 0;
    _multiplier = 0;
    
    _gameStarted = NO;
    _gameOver = NO;
    
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    [audio preloadEffect:@"Published-iOS/Sound/fire.caf"];
    [audio preloadEffect:@"Published-iOS/Sound/click.caf"];
    [audio preloadEffect:@"Published-iOS/Sound/explosion.caf"];
    [audio preloadEffect:@"Published-iOS/Sound/retry.caf"];
    [audio preloadEffect:@"Published-iOS/Sound/collide.caf"];
    
    if (loseCount == fullScreenAdLoseCount) {
        AppController *app = (AppController *)[UIApplication sharedApplication].delegate;
        [app createAdmobFullScreenAd];
    }
}

#pragma mark - Time Update
- (void)update:(CCTime)delta
{
    [self updateRainbowCenter];
    [self updateParallaxBackground:delta];
    if (_gameStarted && !_gameOver) {
        [self updateSpawnEvents:delta];
    }
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

- (void)updateSpawnEvents:(CCTime)delta
{
    static CCTime spawnShootingStar = 0.f;
    static CCTime spawnFruiteor = 0.f;
    
    spawnShootingStar += delta;
    if (spawnShootingStar > eventSpawnRateShootingStar) {
        spawnShootingStar = 0;
        [self spawnShootingStar];
    }
    
    spawnFruiteor += delta;
    CGFloat eventSpawnRateFruiteor = 0.f;
    if (_scorePoint <= 6) {
        eventSpawnRateFruiteor = eventSpawnRateFruiteorLevel1;
    }
    else if (_scorePoint <= 15) {
        eventSpawnRateFruiteor = eventSpawnRateFruiteorLevel2;
    }
    else {
        eventSpawnRateFruiteor = eventSpawnRateFruiteorLevel3;
    }
    if (spawnFruiteor > eventSpawnRateFruiteor) {
        spawnFruiteor = 0;
        [self spawnFruiteors];
    }
}

- (void)updateRainbowCenter
{
    if (_rainbowCenter.x == 0 && _rainbowCenter.y == 0) {
        _rainbowCenter = [self convertToNodeSpace:[_rainbow convertToWorldSpace:ccp(_rainbow.contentSize.width * 0.5f, _rainbow.contentSize.height * 0.5f)]];
    }
}

#pragma mark - Events
- (void)spawnShootingStar
{
    NSLog(@"event: spawning shooting star");
    
    ShootingStar *star = (ShootingStar *)[CCBReader load:@"Sprites/ShootingStar"];
    star.scale = spriteScaleSize;
    star.zOrder = MainSceneDrawingOrderShootingStar;
    [self addChild:star];
    
    CGSize screenSize = [CCDirector sharedDirector].designSize;
    CGPoint startPosition = ccp(screenSize.width + 100.f, ((double)arc4random() / ARC4RANDOM_MAX) * (screenSize.height / 2) + (screenSize.height / 2));
    CGPoint endPosition = ccp(-100.f, ((double)arc4random() / ARC4RANDOM_MAX) * (screenSize.height / 2) + (screenSize.height / 2));
    
    star.rotation = -1 * CC_RADIANS_TO_DEGREES(ccpToAngle(ccpSub(startPosition, endPosition)));
    if (arc4random() % 2 == 0) {
        CGPoint swapPosition = endPosition;
        endPosition = startPosition;
        startPosition = swapPosition;
        star.flipX = YES;
    }
    star.position = startPosition;
    
    CCActionMoveTo *actionMove = [CCActionMoveTo actionWithDuration:5.f position:endPosition];
    CCActionCallBlock *actionBlock = [CCActionCallBlock actionWithBlock:^{[star removeFromParentAndCleanup:YES];}];
    [star runAction:[CCActionSequence actions:actionMove, actionBlock, nil]];
}

- (void)spawnFruiteors
{
    static int lastFruitIndex = 0;
    static int sameFruitCount = 0;
    int eventFruitTypeChangeRate = 0;
    if (_scorePoint == 0) {
        eventFruitTypeChangeRate = -1;
    }
    else if (_scorePoint <= 10) {
        eventFruitTypeChangeRate = eventFruitTypeChangeRateLevel1;
    }
    else if (_scorePoint <= 20) {
        eventFruitTypeChangeRate = eventFruitTypeChangeRateLevel2;
    }
    else {
        eventFruitTypeChangeRate = eventFruitTypeChangeRateLevel3;
    }
    if (eventFruitTypeChangeRate != -1 && ((arc4random() % eventFruitTypeChangeRate) == 0 || sameFruitCount >= 4)) {
        int newFruitIndex = 0;
        do {
            newFruitIndex = arc4random() % [_fruitList count];
        }
        while (newFruitIndex == lastFruitIndex);
        lastFruitIndex = newFruitIndex;
        sameFruitCount = 0;
    }
    else {
        sameFruitCount++;
    }
    NSLog(@"event: spawning fruiteors %d", lastFruitIndex);
    
    Fruit *fruit = (Fruit *)[CCBReader load:[NSString stringWithFormat:@"Sprites/Fruits/%@", [_fruitList objectAtIndex:lastFruitIndex]]];
    fruit.scale = spriteScaleSize;
    fruit.anchorPoint = ccp(0.5f, 0.5f);
    fruit.zOrder = MainSceneDrawingOrderFruit;
    fruit.physicsBody.collisionType = @"fruit";
    
    CGSize screenSize = [CCDirector sharedDirector].designSize;
    CGPoint fruitSpawnPoint = ccp(((double)arc4random() / ARC4RANDOM_MAX) * screenSize.width, screenSize.height + 25.f);
    CGPoint fruitTargetPoint = ccp(((double)arc4random() / ARC4RANDOM_MAX) * 100.f + _rainbowCenter.x - 50.f, 0.f);
    fruitSpawnPoint = [_physicsNode convertToNodeSpace:[self convertToWorldSpace:fruitSpawnPoint]];
    fruitTargetPoint = [_physicsNode convertToNodeSpace:[self convertToWorldSpace:fruitTargetPoint]];
    
    fruit.position = fruitSpawnPoint;
    [_physicsNode addChild:fruit];
    
    CGFloat fruitTravelSpeed = eventFruitTravelSpeed * (1 + (double)arc4random() / ARC4RANDOM_MAX);
    [fruit.physicsBody applyForce:ccpMult(ccpSub(fruitTargetPoint, fruitSpawnPoint), fruitTravelSpeed)];
    [fruit.physicsBody applyTorque:eventFruitSpinSpeed];
}

#pragma mark - Touch Events
- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (_gameStarted && !_gameOver) {
        CGPoint touchPoint = [touch locationInNode:self];
        CGPoint previousTouchPoint = [self convertToNodeSpace:[[CCDirector sharedDirector] convertToGL:[touch previousLocationInView:[touch view]]]];
        
        if (!CGPointEqualToPoint(touchPoint, previousTouchPoint)) {
            if (_dragTouch == nil) {
                NSLog(@"Drag touch: set");
                _dragTouch = touch;
                [self touchOnRainbow:previousTouchPoint andIsFirstPoint:YES];
                [self touchOnRainbow:touchPoint andIsFirstPoint:NO];
            }
            else if (_dragTouch == touch) {
                [self touchOnRainbow:touchPoint andIsFirstPoint:NO];
            }
        }
    }
}

- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [touch locationInNode:self];
    
    if (_gameStarted && !_gameOver) {
        if (_dragTouch != touch && ![self isTouchOnRainbow:touchPoint]) {
            [self touchToFire:touchPoint];
        }
        if (_dragTouch == touch) {
            _dragTouch = nil;
        }
    }
    else if (!_gameOver && !_gameStarted){
        _gameStarted = YES;
        
        CCActionFadeOut *actionFade = [CCActionFadeOut actionWithDuration:1.f];
        CCActionCallBlock *actionBlock = [CCActionCallBlock actionWithBlock:^{[_howTo removeFromParentAndCleanup:YES];}];
        [_howTo runAction:[CCActionSequence actions:actionFade, actionBlock, nil]];
    }
    else {
        if ([self isTouchOnRainbow:touchPoint]) {
            AppController *app = (AppController *)[UIApplication sharedApplication].delegate;
            [app hideBannerView];
            
            [[OALSimpleAudio sharedInstance] playEffect:@"Published-iOS/Sound/retry.caf"];
            [[CCDirector sharedDirector] replaceScene:[CCBReader loadAsScene:@"MainScene"] withTransition:[CCTransition transitionFadeWithDuration:0.5f]];
        }
    }
}

- (BOOL)isTouchOnRainbow:(CGPoint)touchPoint
{
    CGFloat touchDistance = ccpDistance(_rainbowCenter, touchPoint);
    return (touchDistance <= _rainbow.boundingBox.size.height / 2);
}

- (void)touchOnRainbow:(CGPoint)touchPoint andIsFirstPoint:(BOOL)isFirst
{
    static CGFloat lastTouchDistance = 0.f;
    
    CGFloat touchDistance = ccpDistance(_rainbowCenter, touchPoint);
    if (!isFirst) {
        int distanceMoved = roundf(lastTouchDistance - touchDistance);
        if (abs(distanceMoved) >= touchRainbowChangeColorRate) {
            int moveStep = abs(distanceMoved) / touchRainbowChangeColorRate;
            for (int i = 0; i < moveStep; i++) {
                (distanceMoved > 0) ? [_rainbow moveColorsDown] : [_rainbow moveColorsUp];
                [[OALSimpleAudio sharedInstance] playEffect:@"Published-iOS/Sound/click.caf"];
            }
            lastTouchDistance = touchDistance;
        }
    }
    else {
        lastTouchDistance = touchDistance;
    }
}

- (void)touchToFire:(CGPoint)touchPoint
{
    NSLog(@"touch: fire");
    
    Bullet *bullet = (Bullet *)[CCBReader load:@"Sprites/Bullet"];
    bullet.bulletColor = _rainbow.currentColor;
    bullet.physicsBody.collisionType = @"bullet";
    
    bullet.position = [_physicsNode convertToNodeSpace:[self convertToWorldSpace:_rainbowCenter]];
    bullet.anchorPoint = ccp(0.5f, 0.5f);
    bullet.scale = spriteScaleSize;
    bullet.zOrder = MainSceneDrawingOrderBullet;
    
    [_physicsNode addChild:bullet];
    
    CGPoint nodeTouchPoint = [_physicsNode convertToNodeSpace:[self convertToWorldSpace:touchPoint]];
    [bullet.physicsBody applyForce:ccpMult(ccpSub(nodeTouchPoint, bullet.position), touchBulletTravelSpeed)];
    [bullet.physicsBody applyTorque:touchBulletSpinSpeed];
    
    [[OALSimpleAudio sharedInstance] playEffect:@"Published-iOS/Sound/fire.caf"];
}

#pragma mark - Collision Events
#pragma mark Bullet
- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair bullet:(CCNode *)nodeA rainbow:(CCNode *)nodeB
{
    return false;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair bullet:(CCNode *)nodeA bullet:(CCNode *)nodeB
{
    return false;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair bullet:(CCNode *)nodeA boundary:(CCNode *)nodeB
{
    [nodeA removeFromParentAndCleanup:YES];
    return false;
}

#pragma mark Fruit
- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair fruit:(CCNode *)nodeA rainbow:(CCNode *)nodeB
{
    NSLog(@"collision: fruit and rainbow");
    
    Fruit *fruit = (Fruit *)nodeA;
    
    [CCNode pauseAll:_physicsNode];
    _gameOver = YES;
    
    BlackOut *blackOut = (BlackOut *)[CCBReader load:@"Sprites/Effects/BlackOut"];
    blackOut.scale = spriteScaleSize;
    blackOut.anchorPoint = ccp(0.5f, 0.5f);
    blackOut.positionType = CCPositionTypeNormalized;
    blackOut.position = ccp(0.5f, 0.5f);
    blackOut.zOrder = MainSceneDrawingOrderGameOverDim;
    blackOut.opacity = 0.6f;
    [self addChild:blackOut];
    
    WhiteOut *whiteOut = (WhiteOut *)[CCBReader load:@"Sprites/Effects/WhiteOut"];
    whiteOut.scale = spriteScaleSize;
    whiteOut.anchorPoint = ccp(0.5f, 0.5f);
    whiteOut.positionType = CCPositionTypeNormalized;
    whiteOut.position = ccp(0.5f, 0.5f);
    whiteOut.zOrder = MainSceneDrawingOrderGameOverDim;
    
    [self addChild:whiteOut];
    [whiteOut runAnimation];
    
    [[OALSimpleAudio sharedInstance] playEffect:@"Published-iOS/Sound/explosion.caf"];
    _scoreLabel.visible = NO;
    
    GameOverPopup *gameOverPopup = (GameOverPopup *)[CCBReader load:@"Nodes/GameOverPopup"];
    gameOverPopup.anchorPoint = ccp(0.5f, 0.5f);
    gameOverPopup.positionType = CCPositionTypeNormalized;
    gameOverPopup.position = ccp(0.5f, 0.65f);
    gameOverPopup.zOrder = MainSceneDrawingOrderGameOverPopup;
    
    gameOverPopup.fruit = fruit.fruitType;
    gameOverPopup.score = _scorePoint;
    
    [self addChild:gameOverPopup];
    
    TryAgain *tryAgain = (TryAgain *)[CCBReader load:@"Nodes/TryAgain"];
    tryAgain.anchorPoint = ccp(0.5f, 0.f);
    tryAgain.positionType = CCPositionTypeMake(CCPositionUnitNormalized, CCPositionUnitPoints, CCPositionReferenceCornerBottomLeft);
    tryAgain.position = ccp(0.5f, 70.f);
    tryAgain.zOrder = MainSceneDrawingOrderGameOverPopup;
    
    [self addChild:tryAgain];
    
    AppController *app = (AppController *)[UIApplication sharedApplication].delegate;
    if (loseCount == fullScreenAdLoseCount) {
        [app showInterstitialView];
        loseCount = 0;
    }
    [app showBannerView];
    loseCount++;
    
    return true;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair fruit:(CCNode *)nodeA fruit:(CCNode *)nodeB
{
    return false;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair fruit:(CCNode *)nodeA boundary:(CCNode *)nodeB
{
    [nodeA removeFromParentAndCleanup:YES];
    return false;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair fruit:(CCNode *)nodeA bullet:(CCNode *)nodeB
{
    Fruit *fruit = (Fruit *)nodeA;
    Bullet *bullet = (Bullet *)nodeB;
    [bullet runDestroyAnimation];
    
    if (bullet.bulletColor == fruit.fruitColor) {
        [fruit runDestroyAnimation];
        
        _scorePoint += 1;
        _scoreLabel.string = [NSString stringWithFormat:@"%d", _scorePoint];
        
        Multiplier *popupText = (Multiplier *)[CCBReader load:@"Nodes/Multiplier"];
        popupText.position = [_information convertToNodeSpace:[self convertToWorldSpace:fruit.position]];
        popupText.zOrder = MainSceneDrawingOrderInformation;
        popupText.anchorPoint = ccp(0.5f, 0.5f);
        popupText.multiplier = _multiplier;
        
        [_information addChild:popupText];
        [popupText runAnimation];
        
        _multiplier = _multiplier + 1;
        [[OALSimpleAudio sharedInstance] playEffect:@"Published-iOS/Sound/collide.caf"];
    }
    else {
        _multiplier = 0;
    }
    return false;
}

@end
