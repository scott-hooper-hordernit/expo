// Copyright 2018-present 650 Industries. All rights reserved.

internal struct ModulePriorities {
  static let SUPPORTED_MODULE = [
    "expo-screen-orientation": 10,
    "expo-updates": 5,
  ]

  static func get(_ packageName: String) -> Int {
    return SUPPORTED_MODULE[packageName] ?? 0
  }
}
