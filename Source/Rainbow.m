//
//  Rainbow.m
//  ThroughTheFruiteors
//
//  Created by Calvin Ng on 4/16/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Rainbow.h"

static const int eventSpawnRateRainbowDisco = 3;

static NSArray *_colors = nil;

@implementation Rainbow
{
    CCSprite *_base1;
    CCSprite *_base2;
    CCSprite *_base3;
    CCSprite *_base4;
    CCSprite *_base5;
    NSArray *_bases;
    
    CCSprite *_shading1;
    CCSprite *_shading2;
    CCSprite *_shading3;
    CCSprite *_shading4;
    CCSprite *_shading5;
    NSArray *_shadings;
}

@synthesize currentColor;

- (void)didLoadFromCCB
{
    CCColor *purple = [CCColor colorWithRed:(163 / 255.f) green:(73 / 255.f) blue:(164 / 255.f)];
    CCColor *green = [CCColor colorWithRed:(47 / 255.f) green:(160 / 255.f) blue:(27 / 255.f)];
    CCColor *yellow = [CCColor colorWithRed:(255 / 255.f) green:(201 / 255.f) blue:(14 / 255.f)];
    CCColor *orange = [CCColor colorWithRed:(255 / 255.f) green:(104 / 255.f) blue:(4 / 255.f)];
    CCColor *red = [CCColor colorWithRed:(198 / 255.f) green:(0 / 255.f) blue:(15 / 255.f)];
    _colors = @[purple, green, yellow, orange, red];
    
    _base1.color = [_colors objectAtIndex:RainbowColorPurple];
    _base2.color = [_colors objectAtIndex:RainbowColorGreen];
    _base3.color = [_colors objectAtIndex:RainbowColorYellow];
    _base4.color = [_colors objectAtIndex:RainbowColorOrange];
    _base5.color = [_colors objectAtIndex:RainbowColorRed];
    
    _bases = @[_base1, _base2, _base3, _base4, _base5];
    _shadings = @[_shading1, _shading2, _shading3, _shading4, _shading5];
    
    currentColor = RainbowColorPurple;
}

#pragma mark - Time Update
- (void)update:(CCTime)delta
{
    static CCTime deltaTotal = 0;
    deltaTotal += delta;
    if (deltaTotal > 0.3) {
        deltaTotal = 0;
        
        for (CCSprite *shading in _shadings) {
            if (arc4random() % eventSpawnRateRainbowDisco == 0) {
                shading.visible = !shading.visible;
            }
        }
    }
}

#pragma mark - Rainbow Colors
- (void)moveColorsDown
{
    int lastIndex = (int)[_bases count] - 1;
    CCColor *tmpColor = ((CCSprite *)[_bases objectAtIndex:lastIndex]).color;
    for (int i = lastIndex; i >= 0; i--) {
        CCSprite *target = (CCSprite *)[_bases objectAtIndex:i];
        target.color = (i == 0) ? tmpColor : ((CCSprite *)[_bases objectAtIndex:(i - 1)]).color;
    }
    currentColor = (currentColor == 0) ? ([_colors count] - 1) : (currentColor - 1);
}

- (void)moveColorsUp
{
    int lastIndex = (int)[_bases count] - 1;
    CCColor *tmpColor = ((CCSprite *)[_bases objectAtIndex:0]).color;
    for (int i = 0; i <= lastIndex; i++) {
        CCSprite *target = (CCSprite *)[_bases objectAtIndex:i];
        target.color = (i == lastIndex) ? tmpColor : ((CCSprite *)[_bases objectAtIndex:(i + 1)]).color;
    }
    currentColor = (currentColor == ([_colors count] - 1)) ? 0 : (currentColor + 1);
}

+ (CCColor *)getCCColorFromRainbowColor:(RainbowColor)color
{
    return [_colors objectAtIndex:color];
}

@end
