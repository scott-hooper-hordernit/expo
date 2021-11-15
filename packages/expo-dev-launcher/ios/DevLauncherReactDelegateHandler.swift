// Copyright 2018-present 650 Industries. All rights reserved.

import ExpoModulesCore

public class DevLauncherReactDelegateHandler: EXReactDelegateHandler {
  public override func createBridge(_ reactDelegate: EXReactDelegate, bridgeDelegate: RCTBridgeDelegate, launchOptions: [AnyHashable : Any]? = nil) -> RCTBridge? {
    return nil
  }
}
