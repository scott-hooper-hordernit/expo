// Copyright 2018-present 650 Industries. All rights reserved.

#import <ExpoModulesCore/EXReactDelegate.h>
#import <ExpoModulesCore/EXReactDelegateHandler.h>

@implementation EXReactDelegate

- (instancetype)initWithHandlers:(NSArray<EXReactDelegateHandler *> *)handlers
{
  if (self = [super init]) {
    _handlers = handlers;
  }
  return self;
}

- (RCTBridge *)createBridgeWithDelegate:(id<RCTBridgeDelegate>)delegate
                          launchOptions:(nullable NSDictionary *)launchOptions
{
  for (EXReactDelegateHandler *handler in self.handlers) {
    [handler bridgeWillCreate];
  }

  RCTBridge *bridge;
  for (EXReactDelegateHandler *handler in self.handlers) {
    bridge = [handler createBridge:self bridgeDelegate:delegate launchOptions:launchOptions];
    if (bridge != nil) {
      break;
    }
  }
  if (bridge == nil) {
    bridge = [[RCTBridge alloc] initWithDelegate:delegate launchOptions:launchOptions];
  }

  for (EXReactDelegateHandler *handler in self.handlers) {
    [handler bridgeDidCreate:bridge];
  }

  return bridge;
}

- (RCTRootView *)createRootViewWithBridge:(RCTBridge *)bridge
                               moduleName:(NSString *)moduleName
                        initialProperties:(nullable NSDictionary *)initialProperties
{
  for (EXReactDelegateHandler *handler in self.handlers) {
    RCTRootView *rootView = [handler createRootView:self bridge:bridge moduleName:moduleName initialProperties:initialProperties];
    if (rootView != nil) {
      return rootView;
    }
  }

  return [[RCTRootView alloc] initWithBridge:bridge moduleName:moduleName initialProperties:initialProperties];
}

- (UIViewController *)createRootViewController
{
  for (EXReactDelegateHandler *handler in self.handlers) {
    UIViewController *rootViewController = [handler createRootViewController:self];
    if (rootViewController != nil) {
      return rootViewController;
    }
  }

  return [UIViewController new];
}

@end
