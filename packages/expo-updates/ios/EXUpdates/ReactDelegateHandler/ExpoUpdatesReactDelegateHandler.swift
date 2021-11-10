// Copyright 2018-present 650 Industries. All rights reserved.

import ExpoModulesCore

public class ExpoUpdatesReactDelegateHandler: EXReactDelegateHandler, EXUpdatesAppControllerDelegate, RCTBridgeDelegate {
  private weak var reactDelegate: EXReactDelegate?
  private weak var bridge: RCTBridge?
  private var bridgeDelegate: RCTBridgeDelegate?
  private var launchOptions: [AnyHashable : Any]?
  private var deferredRootView: DeferredRCTRootView?
  private var rootViewModuleName: String?
  private var rootViewInitialProperties: [AnyHashable : Any]?
  private lazy var shouldEnableAutoSetup: Bool = {
    // if Expo.plist not found or its content is invalid, disable the auto setup
    guard
      let configPath = Bundle.main.path(forResource: EXUpdatesConfigPlistName, ofType: "plist"),
      let config = NSDictionary(contentsOfFile: configPath)
    else {
      return false
    }

    // if `EXUpdatesAutoSetup` is false, disable the auto setup
    let enableAutoSetupValue = config[EXUpdatesConfigEnableAutoSetupKey]
    if let enableAutoSetup = enableAutoSetupValue as? NSNumber, enableAutoSetup.boolValue == false {
      return false
    }

    // Backward compatible if main AppDelegate already has expo-updates setup,
    // we just skip in this case.
    if (EXUpdatesAppController.sharedInstance().isStarted) {
      return false
    }

    return true
  }()

  public override func createBridge(_ reactDelegate: EXReactDelegate, bridgeDelegate: RCTBridgeDelegate, launchOptions: [AnyHashable : Any]? = nil) -> RCTBridge? {
    if (!shouldEnableAutoSetup) {
      return nil
    }

    self.reactDelegate = reactDelegate
    let controller = EXUpdatesAppController.sharedInstance()
    controller.delegate = self

    // TODO: launch screen should move to expo-splash-screen
    // or assuming expo-splash-screen KVO will make it works even we don't show it explicitly.
    // controller.startAndShowLaunchScreen(UIApplication.shared.delegate!.window!!)
    controller.start()

    self.bridgeDelegate = RCTBridgeDelegateInterceptor(bridgeDelegate: bridgeDelegate, interceptor: self)
    self.launchOptions = launchOptions

    return DeferredRCTBridge(delegate: self.bridgeDelegate!, launchOptions: self.launchOptions)
  }

  public override func createRootView(_ reactDelegate: EXReactDelegate, bridge: RCTBridge, moduleName: String, initialProperties: [AnyHashable : Any]?) -> RCTRootView? {
    if (!shouldEnableAutoSetup) {
      return nil
    }

    self.rootViewModuleName = moduleName
    self.rootViewInitialProperties = initialProperties
    self.deferredRootView = DeferredRCTRootView(bridge: bridge, moduleName: moduleName, initialProperties: initialProperties)
    return self.deferredRootView
  }

  // MARK: EXUpdatesAppControllerDelegate implementations

  public func appController(_ appController: EXUpdatesAppController, didStartWithSuccess success: Bool) {
    self.bridge = RCTBridge(delegate: self.bridgeDelegate, launchOptions: self.launchOptions)
    appController.bridge = self.bridge

    let rootView = RCTRootView(bridge: self.bridge!, moduleName: self.rootViewModuleName!, initialProperties: self.rootViewInitialProperties)
    rootView.backgroundColor = self.deferredRootView?.backgroundColor ?? UIColor.white
    let window = UIApplication.shared.delegate!.window!!
    window.rootViewController = self.reactDelegate?.createRootViewController()
    window.rootViewController!.view = rootView
    window.makeKeyAndVisible()
    self.deferredRootView = nil
  }

  // MARK: RCTBridgeDelegate implementations

  public func sourceURL(for bridge: RCTBridge!) -> URL! {
    return EXUpdatesAppController.sharedInstance().launchAssetUrl
  }
}
