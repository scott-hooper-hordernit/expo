// Copyright 2018-present 650 Industries. All rights reserved.

#import <UIKit/UIKit.h>
#import <React/RCTBridge.h>
#import <React/RCTRootView.h>

@class EXReactDelegateHandler;

NS_ASSUME_NONNULL_BEGIN

@interface EXReactDelegate : NSObject

- (instancetype)initWithReactDelegateHandlers:(NSArray<EXReactDelegateHandler *> *)reactDelegateHandlers;

- (RCTBridge *)createBridgeWithDelegate:(id<RCTBridgeDelegate>)delegate
                          launchOptions:(nullable NSDictionary *)launchOptions;

- (RCTRootView *)createRootViewWithBridge:(RCTBridge *)bridge
                               moduleName:(NSString *)moduleName
                        initialProperties:(nullable NSDictionary *)initialProperties;

- (UIViewController *)createRootViewController;

@property (nonatomic, readonly, strong) NSArray<EXReactDelegateHandler *> *reactDelegateHandlers;

@end

NS_ASSUME_NONNULL_END
