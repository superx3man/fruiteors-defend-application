/*
 * SpriteBuilder: http://www.spritebuilder.org
 *
 * Copyright (c) 2012 Zynga Inc.
 * Copyright (c) 2013 Apportable Inc.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import <UIKit/UIKit.h>
#import "cocos2d.h"

#import "GADBannerView.h"
#import "GADInterstitial.h"

#define ADMOB_BANNER_UNIT_ID @"ca-app-pub-4961934469470022/3787071591";
#define ADMOB_INTERSTITIAL_UNIT_ID @"ca-app-pub-4961934469470022/4227723599"

typedef enum _bannerType
{
    kBanner_Portrait_Top,
    kBanner_Portrait_Bottom,
    kBanner_Landscape_Top,
    kBanner_Landscape_Bottom,
} CocosBannerType;

#define BANNER_TYPE kBanner_Portrait_Bottom

@interface AppController : CCAppDelegate <GADBannerViewDelegate, GADInterstitialDelegate>
{
    CocosBannerType mBannerType;
    GADBannerView *mBannerView;
    float on_x, on_y, off_x, off_y;
    
    GADInterstitial *mInterstitialView;
}

- (void)hideBannerView;
- (void)showBannerView;
- (void)createAdmobFullScreenAd;
- (void)showInterstitialView;

@end
