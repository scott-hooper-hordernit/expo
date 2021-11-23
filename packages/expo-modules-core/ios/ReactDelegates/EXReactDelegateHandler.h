// Copyright 2018-present 650 Industries. All rights reserved.

#import <UIKit/UIKit.h>
#import <React/RCTBridge.h>
#import <React/RCTRootView.h>

@class ExpoReactDelegateHandler;
@class EXReactDelegate;

NS_ASSUME_NONNULL_BEGIN

/**
 This class is an adapter for swift `ExpoReactDelegateHandler` class.
 We do this because `EXReactDelegate` is implemented by Objective-C and we need the adapter for Swift <-> Objective-C.
 There are two design considerations:
   1. Modules should inherit Swift based `ExpoReactDelegateHandler` class. They don't need to worry about mixing Swift/Objective-C.
   2. The generated `ExpoReactDelegateHandler` class in ExpoModulesCore-Swift.h is only used inside .m file.
 */
@interface EXReactDelegateHandler : NSObject

- (instancetype)initWithHandler:(ExpoReactDelegateHandler *)handler;

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
