//
//  MainScene.h
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "CCNode.h"

#define ARC4RANDOM_MAX 0x100000000

typedef NS_ENUM(NSInteger, MainSceneDrawingOrder)
{
    MainSceneDrawingOrderBackground,
    MainSceneDrawingOrderStarsSmall,
    MainSceneDrawingOrderStarsLarge,
    MainSceneDrawingOrderShootingStar,
    MainSceneDrawingOrderPhysicsNode,
    MainSceneDrawingOrderBullet,
    MainSceneDrawingOrderSparkling,
    MainSceneDrawingOrderFruit,
    MainSceneDrawingOrderSmoke,
    MainSceneDrawingOrderRainbow,
    MainSceneDrawingOrderInformation,
    MainSceneDrawingOrderGameOverDim,
    MainSceneDrawingOrderGameOverPopup
};

@interface MainScene : CCNode <CCPhysicsCollisionDelegate>

@end
