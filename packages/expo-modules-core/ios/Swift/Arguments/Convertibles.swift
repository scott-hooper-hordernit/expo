// Copyright 2018-present 650 Industries. All rights reserved.

import UIKit
import CoreGraphics

/// Here we extend some common iOS types to implement `ConvertibleArgument` protocol and
/// describe how they can be converted from primitive types received from JavaScript runtime.
/// This allows these types to be used as argument types of functions callable from JavaScript.
/// As an example, when the `CGPoint` type is used as an argument type, its instance can be
/// created from an array of two doubles or an object with `x` and `y` fields.

// MARK: - Foundation

extension URL: ConvertibleArgument {
  public static func convert(from value: Any?) throws -> Self {
    if let uri = value as? String, let url = URL(string: uri) {
      // `URL(string:)` is an optional init but it doesn't imply it's a valid URL,
      // so here we don't check for the correctness of the URL.
      // If it has no scheme, we assume it was the file path.
      return url.scheme != nil ? url : URL(fileURLWithPath: uri)
    }
    throw Conversions.ConvertingError<URL>(value: value)
  }
}

// MARK: - UIKit

extension UIColor: ConvertibleArgument {
  public static func convert(from value: Any?) throws -> Self {
    if let value = value as? String {
      return try Conversions.toColor(hexString: value) as! Self
    }
    if let components = value as? [Double] {
      let alpha = components.count > 3 ? components[3] : 1.0
      return Self.init(red: components[0], green: components[1], blue: components[2], alpha: alpha)
    }
    if let value = value as? Int {
      return try Conversions.toColor(argb: UInt64(value)) as! Self
    }
    throw Conversions.ConvertingError<UIColor>(value: value)
  }
}

// MARK: - CoreGraphics

extension CGPoint: ConvertibleArgument {
  public static func convert(from value: Any?) throws -> CGPoint {
    if let value = value as? [Double], value.count == 2 {
      return CGPoint(x: value[0], y: value[1])
    }
    if let value = value as? [String: Any] {
      let args = try Conversions.pickValues(from: value, byKeys: ["x", "y"], as: Double.self)
      return CGPoint(x: args[0], y: args[1])
    }
    throw Conversions.ConvertingError<CGPoint>(value: value)
  }
}

extension CGSize: ConvertibleArgument {
  public static func convert(from value: Any?) throws -> CGSize {
    if let value = value as? [Double], value.count == 2 {
      return CGSize(width: value[0], height: value[1])
    }
    if let value = value as? [String: Any] {
      let args = try Conversions.pickValues(from: value, byKeys: ["width", "height"], as: Double.self)
      return CGSize(width: args[0], height: args[1])
    }
    throw Conversions.ConvertingError<CGSize>(value: value)
  }
}

extension CGVector: ConvertibleArgument {
  public static func convert(from value: Any?) throws -> CGVector {
    if let value = value as? [Double], value.count == 2 {
      return CGVector(dx: value[0], dy: value[1])
    }
    if let value = value as? [String: Any] {
      let args = try Conversions.pickValues(from: value, byKeys: ["dx", "dy"], as: Double.self)
      return CGVector(dx: args[0], dy: args[1])
    }
    throw Conversions.ConvertingError<CGVector>(value: value)
  }
}

extension CGRect: ConvertibleArgument {
  public static func convert(from value: Any?) throws -> CGRect {
    if let value = value as? [Double], value.count == 4 {
      return CGRect(x: value[0], y: value[1], width: value[2], height: value[3])
    }
    if let value = value as? [String: Any] {
      let args = try Conversions.pickValues(from: value, byKeys: ["x", "y", "width", "height"], as: Double.self)
      return CGRect(x: args[0], y: args[1], width: args[2], height: args[3])
    }
    throw Conversions.ConvertingError<CGRect>(value: value)
  }
}

extension CGColor: ConvertibleArgument {
  public static func convert(from value: Any?) throws -> Self {
    do {
      return try UIColor.convert(from: value).cgColor as! Self
    } catch _ as Conversions.ConvertingError<UIColor> {
      // Rethrow `ConvertingError` with proper type
      throw Conversions.ConvertingError<CGColor>(value: value)
    }
  }
}
