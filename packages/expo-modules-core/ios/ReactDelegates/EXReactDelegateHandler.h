// Copyright 2018-present 650 Industries. All rights reserved.

#import <UIKit/UIKit.h>
#import <React/RCTBridge.h>
#import <React/RCTRootView.h>

@class EXReactDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface EXReactDelegateHandler : NSObject

- (nullable RCTBridge *)createBridge:(EXReactDelegate *)reactDelegate
                      bridgeDelegate:(id<RCTBridgeDelegate>)bridgeDelegate
                       launchOptions:(nullable NSDictionary *)launchOptions;

- (nullable RCTRootView *)createRootView:(EXReactDelegate *)reactDelegate
                                  bridge:(RCTBridge *)bridge
                              moduleName:(NSString *)moduleName
                       initialProperties:(nullable NSDictionary *)initialProperties;

- (nullable UIViewController *)createRootViewController:(EXReactDelegate *)reactDelegate;

// MARK - event callbacks

- (void)bridgeWillCreate;

- (void)bridgeDidCreate:(RCTBridge *)bridge;

@end

NS_ASSUME_NONNULL_END
