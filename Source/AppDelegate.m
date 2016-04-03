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

#import "cocos2d.h"

#import "AppDelegate.h"
#import "CCBuilderReader.h"

@implementation AppController
{
    BOOL _bannerViewShowing;
    BOOL _bannerViewReady;
    BOOL _interstitialViewReady;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Configure Cocos2d with the options set in SpriteBuilder
    NSString* configPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Published-iOS"]; // TODO: add support for Published-Android support
    configPath = [configPath stringByAppendingPathComponent:@"configCocos2d.plist"];
    
    NSMutableDictionary* cocos2dSetup = [NSMutableDictionary dictionaryWithContentsOfFile:configPath];
    
    // Note: this needs to happen before configureCCFileUtils is called, because we need apportable to correctly setup the screen scale factor.
#ifdef APPORTABLE
    [UIScreen mainScreen].currentMode = ([cocos2dSetup[CCSetupScreenMode] isEqual:CCScreenModeFixed]) ? [UIScreenMode emulatedMode:UIScreenAspectFitEmulationMode] : [UIScreenMode emulatedMode:UIScreenScaledAspectFitEmulationMode];
#endif
    
    // Configure CCFileUtils to work with SpriteBuilder
    [CCBReader configureCCFileUtils];
    
    // Do any extra configuration of Cocos2d here (the example line changes the pixel format for faster rendering, but with less colors)
    //[cocos2dSetup setObject:kEAGLColorFormatRGB565 forKey:CCConfigPixelFormat];
    
    [self setupCocos2dWithOptions:cocos2dSetup];
    
    [self createAdmobAds];
    [self createAdmobFullScreenAd];
    
    return YES;
}

- (CCScene*)startScene
{
    return [CCBReader loadAsScene:@"StartScene"];
}

- (void)createAdmobFullScreenAd
{
    if (!_interstitialViewReady) {
        mInterstitialView = [[GADInterstitial alloc] init];
        mInterstitialView.adUnitID = ADMOB_INTERSTITIAL_UNIT_ID;
        
        mInterstitialView.delegate = self;
        
        GADRequest *request = [GADRequest request];
        [mInterstitialView loadRequest:request];
    }
}

- (void)showInterstitialView
{
    if (_interstitialViewReady) {
        [mInterstitialView presentFromRootViewController:self.navController];
        _interstitialViewReady = NO;
    }
}

- (void)createAdmobAds
{
    if (!_bannerViewReady) {
        _bannerViewShowing = NO;
        
        mBannerType = BANNER_TYPE;
        mBannerView = (mBannerType <= kBanner_Portrait_Bottom) ? [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait] : [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerLandscape];
        
        // Specify the ad's "unit identifier." This is your AdMob Publisher ID.
        mBannerView.adUnitID = ADMOB_BANNER_UNIT_ID;
        
        // Let the runtime know which UIViewController to restore after taking
        // the user wherever the ad goes and add it to the view hierarchy.
        
        mBannerView.rootViewController = self.navController;
        [self.navController.view addSubview:mBannerView];
        
        mBannerView.delegate = self;
        
        //#ifdef DEBUG
        //    GADRequest *request = [GADRequest request];
        //    request.testDevices = [NSArray arrayWithObjects:GAD_SIMULATOR_ID, nil];
        //#endif
        
        GADRequest *request = [GADRequest request];
        // Initiate a generic request to load it with an ad.
        [mBannerView loadRequest:request];
        
        CGSize s = [[CCDirector sharedDirector] viewSize];
        CGRect frame = mBannerView.frame;
        
        off_x = 0.0f;
        on_x = 0.0f;
        
        switch (mBannerType) {
            case kBanner_Portrait_Top:
            {
                off_y = -frame.size.height;
                on_y = 0.0f;
            }
                break;
            case kBanner_Portrait_Bottom:
            {
                off_y = s.height;
                on_y = s.height-frame.size.height;
            }
                break;
            case kBanner_Landscape_Top:
            {
                off_y = -frame.size.height;
                on_y = 0.0f;
            }
                break;
            case kBanner_Landscape_Bottom:
            {
                off_y = s.height;
                on_y = s.height-frame.size.height;
            }
                break;
                
            default:
                break;
        }
        
        frame.origin.y = off_y;
        frame.origin.x = off_x;
        
        mBannerView.frame = frame;
    }
}

- (void)showBannerView
{
    if (_bannerViewReady && !_bannerViewShowing) {
        NSLog(@"ad: showing banner");
        _bannerViewShowing = YES;
        
        //banner on bottom
        CGRect frame = mBannerView.frame;
        frame.origin.y = off_y;
        frame.origin.x = on_x;
        mBannerView.frame = frame;
        
        [UIView animateWithDuration:0.5 delay:0.1 options: UIViewAnimationOptionCurveEaseOut animations:^
        {
            CGRect frame = mBannerView.frame;
            frame.origin.y = on_y;
            frame.origin.x = on_x;
             
            mBannerView.frame = frame;
        } completion:nil];
    }
    else if (!_bannerViewReady) {
        [self createAdmobAds];
    }
}

- (void)hideBannerView
{
    if (_bannerViewReady && _bannerViewShowing) {
        NSLog(@"ad: hiding banner");
        _bannerViewShowing = NO;
        
        [UIView animateWithDuration:0.5 delay:0.1 options: UIViewAnimationOptionCurveEaseOut animations:^
        {
            CGRect frame = mBannerView.frame;
            frame.origin.y = off_y;
            frame.origin.x = off_x;
            mBannerView.frame = frame;
        } completion:nil];
    }
}

- (void)dismissAdView
{
    if (mBannerView) {
        [UIView animateWithDuration:0.5 delay:0.1 options: UIViewAnimationOptionCurveEaseOut animations:^
        {
            CGSize s = [[CCDirector sharedDirector] viewSize];
             
            CGRect frame = mBannerView.frame;
            frame.origin.y = frame.origin.y + frame.size.height ;
            frame.origin.x = (s.width/2.0f - frame.size.width/2.0f);
            mBannerView.frame = frame;
        } completion:^(BOOL finished)
        {
            [mBannerView setDelegate:nil];
            [mBannerView removeFromSuperview];
            mBannerView = nil;
        }];
    }
}

#pragma mark - Ads delegate
- (void)adView:(GADBannerView*)view didFailToReceiveAdWithError:(GADRequestError*)error
{
    NSLog(@"ad: failed to get banner ad %@", [error localizedDescription]);
    _bannerViewReady = NO;
}

- (void)interstitial:(GADInterstitial *)interstitial didFailToReceiveAdWithError:(GADRequestError *)error
{
    NSLog(@"ad: failed to get full screen ad %@", [error localizedDescription]);
    _interstitialViewReady = NO;
}

- (void)adViewDidReceiveAd:(GADBannerView *)view
{
    _bannerViewReady = YES;
}

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad
{
    _interstitialViewReady = YES;
}

@end
