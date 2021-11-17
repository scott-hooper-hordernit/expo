// Copyright 2018-present 650 Industries. All rights reserved.

#import <ExpoModulesCore/EXReactDelegate.h>
#import <ExpoModulesCore/EXReactDelegateHandler.h>

@implementation EXReactDelegate

- (instancetype)initWithReactDelegateHandlers:(NSArray<EXReactDelegateHandler *> *)reactDelegateHandlers
{
  if (self = [super init]) {
    _reactDelegateHandlers = reactDelegateHandlers;
  }
  return self;
}

- (RCTBridge *)createBridgeWithDelegate:(id<RCTBridgeDelegate>)delegate
                          launchOptions:(nullable NSDictionary *)launchOptions
{
  for (EXReactDelegateHandler *handler in self.reactDelegateHandlers) {
    [handler bridgeWillCreate];
  }

  RCTBridge *bridge;
  for (EXReactDelegateHandler *handler in self.reactDelegateHandlers) {
    bridge = [handler createBridge:self bridgeDelegate:delegate launchOptions:launchOptions];
    if (bridge != nil) {
      break;
    }
  }
  if (bridge == nil) {
    bridge = [[RCTBridge alloc] initWithDelegate:delegate launchOptions:launchOptions];
  }

  for (EXReactDelegateHandler *handler in self.reactDelegateHandlers) {
    [handler bridgeDidCreate:bridge];
  }

  return bridge;
}

- (RCTRootView *)createRootViewWithBridge:(RCTBridge *)bridge
                               moduleName:(NSString *)moduleName
                        initialProperties:(nullable NSDictionary *)initialProperties
{
  for (EXReactDelegateHandler *handler in self.reactDelegateHandlers) {
    RCTRootView *rootView = [handler createRootView:self bridge:bridge moduleName:moduleName initialProperties:initialProperties];
    if (rootView != nil) {
      return rootView;
    }
  }

  return [[RCTRootView alloc] initWithBridge:bridge moduleName:moduleName initialProperties:initialProperties];
}

- (UIViewController *)createRootViewController
{
  for (EXReactDelegateHandler *handler in self.reactDelegateHandlers) {
    UIViewController *rootViewController = [handler createRootViewController:self];
    if (rootViewController != nil) {
      return rootViewController;
    }
  }

  return [UIViewController new];
}

@end
