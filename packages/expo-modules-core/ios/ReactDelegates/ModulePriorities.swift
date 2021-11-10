//
//  ModulePriorities.swift
//  ExpoModulesCore
//
//  Created by Kudo Chien on 2021/11/9.
//

import Foundation

internal struct ModulePriorities {
  static let SUPPORTED_MODULE = [
    "expo-screen-orientation": 10,
    "expo-updates": 5,
  ]

  static func get(_ packageName: String) -> Int {
    return SUPPORTED_MODULE[packageName] ?? 0
  }
}
