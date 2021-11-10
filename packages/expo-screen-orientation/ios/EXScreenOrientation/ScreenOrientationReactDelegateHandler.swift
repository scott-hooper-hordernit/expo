// Copyright 2018-present 650 Industries. All rights reserved.

import ExpoModulesCore

public class ScreenOrientationReactDelegateHandler: EXReactDelegateHandler {
  public override func createRootViewController(_ reactDelegate: EXReactDelegate) -> UIViewController? {
    return EXScreenOrientationViewController()
  }
}
