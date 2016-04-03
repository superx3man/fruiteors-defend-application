//
//  StartScene.h
//  ThroughTheFruiteors
//
//  Created by Calvin Ng on 4/20/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCScene.h"

typedef NS_ENUM(NSInteger, StartSceneDrawingOrder)
{
    StartSceneDrawingOrderBackground,
    StartSceneDrawingOrderStarsSmall,
    StartSceneDrawingOrderStarsLarge,
    StartSceneDrawingOrderRainbow,
    StartSceneDrawingOrderFruit,
    StartSceneDrawingOrderLogo,
    StartSceneDrawingOrderStartButton
};

@interface StartScene : CCScene

@end
