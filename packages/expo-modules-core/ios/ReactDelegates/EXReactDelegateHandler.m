// Copyright 2018-present 650 Industries. All rights reserved.

#import <ExpoModulesCore/EXReactDelegateHandler.h>
#import <ExpoModulesCore/Swift.h>

@interface EXReactDelegateHandler()

@property (nonatomic, strong) ExpoReactDelegateHandler *handler;

@end

@implementation EXReactDelegateHandler

- (instancetype)initWithHandler:(ExpoReactDelegateHandler *)handler
{
  if (self = [super init]) {
    _handler = handler;
  }
  return self;
}

- (nullable RCTBridge *)createBridge:(EXReactDelegate *)reactDelegate
                      bridgeDelegate:(id<RCTBridgeDelegate>)bridgeDelegate
                       launchOptions:(nullable NSDictionary *)launchOptions
{
  return [_handler createBridgeWithReactDelegate:reactDelegate bridgeDelegate:bridgeDelegate launchOptions:launchOptions];
}

- (nullable RCTRootView *)createRootView:(EXReactDelegate *)reactDelegate
                                  bridge:(RCTBridge *)bridge
                              moduleName:(NSString *)moduleName
                       initialProperties:(nullable NSDictionary *)initialProperties
{
  return [_handler createRootViewWithReactDelegate:reactDelegate bridge:bridge moduleName:moduleName initialProperties:initialProperties];
}

- (nullable UIViewController *)createRootViewController:(EXReactDelegate *)reactDelegate
{
  return [_handler createRootViewControllerWithReactDelegate:reactDelegate];
}

- (void)bridgeWillCreate
{
  [_handler bridgeWillCreate];
}

- (void)bridgeDidCreate:(RCTBridge *)bridge
{
  [_handler bridgeDidCreateWithBridge:bridge];
}

@end
