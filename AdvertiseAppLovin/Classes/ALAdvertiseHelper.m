//
//  ALAdvertiseHelper.m
//  Pods
//
//  Created by geekgy on 16/6/16.
//
//

#import "ALAdvertiseHelper.h"
#import "IOSSystemUtil.h"
#import "ALSdk.h"
#import "ALInterstitialAd.h"
#import "ALIncentivizedInterstitialAd.h"

@interface SpotDelegate : NSObject <ALAdLoadDelegate, ALAdDisplayDelegate>
@property (nonatomic, retain) ALAdvertiseHelper* helper;
@property (nonatomic, assign) void(^clickFunc)(BOOL);
@end

@interface VideoDelegate : NSObject <ALAdLoadDelegate, ALAdDisplayDelegate, ALAdVideoPlaybackDelegate, ALAdRewardDelegate>
@property (nonatomic, retain) ALAdvertiseHelper* helper;
@property (nonatomic, assign) void(^viewFunc)(BOOL);
@property (nonatomic, assign) void(^clickFunc)(BOOL);
@end

@interface ALAdvertiseHelper()
@property (nonatomic, retain) SpotDelegate* spotDelegate;
@property (nonatomic, retain) VideoDelegate* videoDelegate;
- (void)preloadVideoAd;
@end

#pragma mark - SpotDelegate

@implementation SpotDelegate
{
    BOOL _clicked;
}
- (void)adService:(ALAdService *)adService didLoadAd:(ALAd *)ad {
//    NSLog(@"spot adService %@ didLoadAd: %@", adService, ad);
}

-(void)adService:(ALAdService *)adService didFailToLoadAdWithError:(int)code {
//    NSLog(@"spot adService %@ didFailToLoadAdWithError: %d", adService, code);
}

-(void) ad:(ALAd *) ad wasDisplayedIn: (UIView *)view {
    if (ad == nil) {return;}
    _clicked = NO;
//    NSLog(@"spot ad %@ wasDisplayedIn", ad);
}

-(void) ad:(ALAd *) ad wasClickedIn: (UIView *)view {
    if (ad == nil) {return;}
    _clicked = YES;
//    NSLog(@"spot ad %@ wasClickedIn", ad);
}

-(void) ad:(ALAd *) ad wasHiddenIn: (UIView *)view {
    if (ad == nil) {return;}
    _clickFunc(_clicked);
//    NSLog(@"spot ad %@ wasHiddenIn", ad);
}

@end

@implementation VideoDelegate
{
    BOOL _viewed;
    BOOL _clicked;
}

- (void)adService:(ALAdService *)adService didLoadAd:(ALAd *)ad {
    NSLog(@"video adService %@ didLoadAd: %@", adService, ad);
}

-(void)adService:(ALAdService *)adService didFailToLoadAdWithError:(int)code {
    NSLog(@"video adService %@ didFailToLoadAdWithError: %d", adService, code);
    [_helper preloadVideoAd];
}

-(void) ad:(ALAd *) ad wasDisplayedIn: (UIView *)view {
    if (ad == nil) {return;}
    _viewed = NO;
    _clicked = NO;
//    NSLog(@"video ad %@ wasDisplayedIn", ad);
}

-(void) ad:(ALAd *) ad wasClickedIn: (UIView *)view {
    if (ad == nil) {return;}
    _clicked = YES;
//    NSLog(@"video ad %@ wasClickedIn", ad);
}

-(void) ad:(ALAd *) ad wasHiddenIn: (UIView *)view {
    if (ad == nil) {return;}
    _viewFunc(_viewed);
    _clickFunc(_clicked);
    [_helper preloadVideoAd];
//    NSLog(@"video ad %@ wasHiddenIn", ad);
}

- (void)videoPlaybackBeganInAd:(ALAd *)ad {
//    NSLog(@"videoPlaybackBeganInAd %@", ad);
}

- (void)videoPlaybackEndedInAd:(ALAd *)ad atPlaybackPercent:(NSNumber *)percentPlayed fullyWatched:(BOOL)wasFullyWatched {
//    NSLog(@"videoPlaybackEndedInAd %@ atPlaybackPercent %@ fullyWatched %@", ad, percentPlayed, wasFullyWatched?@"YES":@"NO");
    _viewed = wasFullyWatched;
}

-(void) rewardValidationRequestForAd: (ALAd*) ad didSucceedWithResponse: (NSDictionary*) response {
//    NSLog(@"video rewardValidationRequestForAd %@ didSucceedWithResponse %@", ad, response);
}

-(void) rewardValidationRequestForAd: (ALAd*) ad didExceedQuotaWithResponse: (NSDictionary*) response {
//    NSLog(@"video rewardValidationRequestForAd %@ didExceedQuotaWithResponse %@", ad, response);
}

-(void) rewardValidationRequestForAd: (ALAd*) ad wasRejectedWithResponse: (NSDictionary*) response {
//    NSLog(@"video rewardValidationRequestForAd %@ wasRejectedWithResponse %@", ad, response);
}

-(void) rewardValidationRequestForAd: (ALAd*) ad didFailWithError: (NSInteger) responseCode {
//    NSLog(@"video rewardValidationRequestForAd %@ didFailWithError %ld", ad, responseCode);
}

-(void) userDeclinedToViewAd: (ALAd*) ad {
//    NSLog(@"video userDeclinedToViewAd %@ ", ad);
}

@end

#pragma mark - ALAdvertiseHelper

@implementation ALAdvertiseHelper
{
    ALInterstitialAd* _interstitialAd;
    ALIncentivizedInterstitialAd* _incentivizedInterstitialAd;
}

SINGLETON_DEFINITION(ALAdvertiseHelper)

- (void)preloadVideoAd {
    [_incentivizedInterstitialAd preloadAndNotify:_videoDelegate];
}

#pragma mark - AdvertiseDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"%@ : %@", AppLovin_Name, [ALSdk version]);
    
    SpotDelegate* spotDelegate = [[SpotDelegate alloc] init];
    spotDelegate.helper = self;
    VideoDelegate* videoDelegate = [[VideoDelegate alloc] init];
    videoDelegate.helper = self;
    [self setSpotDelegate:spotDelegate];
    [self setVideoDelegate:videoDelegate];
    
    NSString* appLovinKey = [[IOSSystemUtil getInstance] getConfigValueWithKey:AppLovin_Key];
    ALSdk* sdk = [ALSdk sharedWithKey:appLovinKey];

    _interstitialAd = [[ALInterstitialAd alloc] initWithSdk:sdk];
    _incentivizedInterstitialAd = [[ALIncentivizedInterstitialAd alloc] initWithSdk:sdk];
    
    _interstitialAd.adLoadDelegate = _spotDelegate;
    _interstitialAd.adDisplayDelegate = _spotDelegate;
    _incentivizedInterstitialAd.adDisplayDelegate = _videoDelegate;
    _incentivizedInterstitialAd.adVideoPlaybackDelegate = _videoDelegate;
    
    [self preloadVideoAd];
    return YES;
}

- (int)showBannerAd:(BOOL)portrait :(BOOL)bottom {
    return NO;
}

- (void)hideBannerAd {
    
}

- (BOOL)showSpotAd:(void (^)(BOOL))func {
    if([_interstitialAd isReadyForDisplay]){
        _spotDelegate.clickFunc = func;
        [_interstitialAd show];
        return YES;
    }
    return NO;
}

- (BOOL)isVedioAdReady {
    return [_incentivizedInterstitialAd isReadyForDisplay];
}

- (BOOL)showVedioAd:(void (^)(BOOL))viewFunc :(void (^)(BOOL))clickFunc {
    if([self isVedioAdReady]){
        _videoDelegate.viewFunc = viewFunc;
        _videoDelegate.clickFunc = clickFunc;
        [_incentivizedInterstitialAd showAndNotify: _videoDelegate];
        return YES;
    }
    return NO;
}

- (NSString *)getName {
    return AppLovin_Name;
}

@end
