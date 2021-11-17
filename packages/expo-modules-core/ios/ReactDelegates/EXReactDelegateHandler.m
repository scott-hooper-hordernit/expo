// Copyright 2018-present 650 Industries. All rights reserved.

#import <ExpoModulesCore/EXReactDelegateHandler.h>

@implementation EXReactDelegateHandler

- (nullable RCTBridge *)createBridge:(EXReactDelegate *)reactDelegate
                      bridgeDelegate:(id<RCTBridgeDelegate>)bridgeDelegate
                       launchOptions:(nullable NSDictionary *)launchOptions
{
  return nil;
}

- (nullable RCTRootView *)createRootView:(EXReactDelegate *)reactDelegate
                                  bridge:(RCTBridge *)bridge
                              moduleName:(NSString *)moduleName
                       initialProperties:(nullable NSDictionary *)initialProperties
{
  return nil;
}

- (nullable UIViewController *)createRootViewController:(EXReactDelegate *)reactDelegate
{
  return nil;
}

- (void)bridgeWillCreate
{
}

- (void)bridgeDidCreate:(RCTBridge *)bridge
{
}

@end
