// Copyright 2018-present 650 Industries. All rights reserved.

import ExpoModulesCore

public class ExpoDevLauncherReactDelegateHandler: EXReactDelegateHandler, RCTBridgeDelegate, EXDevLauncherControllerDelegate {
  private weak var reactDelegate: EXReactDelegate?
  private var bridgeDelegate: RCTBridgeDelegate?
  private var launchOptions: [AnyHashable : Any]?
  private var deferredRootView: DeferredRCTRootView?
  private var rootViewModuleName: String?
  private var rootViewInitialProperties: [AnyHashable : Any]?
  private lazy var shouldEnableAutoSetup: Bool = {
    // TODO: disable in release build (needs EXAppDefines)

    // Backward compatible if main AppDelegate already has expo-dev-launcher setup,
    // we just skip in this case.
    if (EXDevLauncherController.sharedInstance().isStarted) {
      return false
    }

    return true
  }()

  public override func createBridge(_ reactDelegate: EXReactDelegate, bridgeDelegate: RCTBridgeDelegate, launchOptions: [AnyHashable : Any]? = nil) -> RCTBridge? {
    self.reactDelegate = reactDelegate
    self.bridgeDelegate = RCTBridgeDelegateInterceptor(bridgeDelegate: bridgeDelegate, interceptor: self)
    self.launchOptions = launchOptions

    EXDevLauncherController.sharedInstance().autoSetupPrepare(self, launchOptions: launchOptions)
    return DeferredRCTBridge(delegate: self.bridgeDelegate!, launchOptions: self.launchOptions)
  }

  public override func createRootView(_ reactDelegate: EXReactDelegate, bridge: RCTBridge, moduleName: String, initialProperties: [AnyHashable : Any]?) -> RCTRootView? {
    self.rootViewModuleName = moduleName
    self.rootViewInitialProperties = initialProperties
    self.deferredRootView = DeferredRCTRootView(bridge: bridge, moduleName: moduleName, initialProperties: initialProperties)
    return self.deferredRootView
  }

  // MARK: RCTBridgeDelegate implementations

  public func sourceURL(for bridge: RCTBridge!) -> URL! {
    return EXDevLauncherController.sharedInstance().sourceUrl()
  }

  // MARK: EXDevelopmentClientControllerDelegate implementations

  public func devLauncherController(_ developmentClientController: EXDevLauncherController, didStartWithSuccess success: Bool) {
    let bridge = RCTBridge(delegate: self.bridgeDelegate, launchOptions: self.launchOptions)
    developmentClientController.appBridge = bridge

    let rootView = RCTRootView(bridge: bridge!, moduleName: self.rootViewModuleName!, initialProperties: self.rootViewInitialProperties)
    rootView.backgroundColor = self.deferredRootView?.backgroundColor ?? UIColor.white
    let window = getWindow()
    window.rootViewController = self.reactDelegate?.createRootViewController()
    window.rootViewController!.view = rootView
    window.makeKeyAndVisible()
    self.deferredRootView = nil
  }

  // MARK: Internals

  private func getWindow() -> UIWindow {
    var window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
    if (window == nil) {
      window = UIApplication.shared.delegate?.window ?? nil
    }
    if (window == nil) {
      fatalError("Cannot find the current window.")
    }
    return window!
  }
}
