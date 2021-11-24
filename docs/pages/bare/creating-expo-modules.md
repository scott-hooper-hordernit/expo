---
title: Creating Expo modules
---

import { CodeBlocksTable } from '~/components/plugins/CodeBlocksTable';

## Get Started

If you would like to create a new Expo module from scratch, we have prepared a dedicated command for this: `npx create-expo-module`. <br/>
In case you just want to use something from Expo Modules API in your existing React Native library (yes, you can!), follow these steps 👇

1️⃣ If it doesn't exist, create **expo-module.config.json** file just near your **package.json** and start from the empty object `{}` in there.<br/>
2️⃣ Add `expo-modules-core` as a dependency in your podspec and **build.gradle** files.<br/>

<CodeBlocksTable tabs={["Ruby (*.podspec)", "Gradle (build.gradle)"]}>

```ruby
# ...
Pod::Spec.new do |s|
  # ...
  s.dependency 'ExpoModulesCore'
end
```

```groovy
// ...
dependencies {
  // ...
  implementation project(':expo-modules-core')
}
```

</CodeBlocksTable>

3️⃣ Add `expo` package as a peer dependency in your **package.json** — we recommend using `*` as a version range.<br/>

```json
{
  // ...
  "peerDependencies": {
    "expo": "*"
  }
}
```

## Native Modules

Expo Modules API is an abstraction layer of top of React Native modules that helps you build native modules in an easy to use and convenience way. As opposed to standard React Native modules, Expo Modules ecosystem is designed from the ground up to be used with only modern native languages — Swift and Kotlin. After many years of maintaining a bunch of various native modules as part of Expo SDK, we have found out that many issues were caused by not handling null values or using the wrong types. The lack of optional types and Objective-C being too dynamic, makes most bugs unable to get caught in the compile time — which would be caught in modern languages.

Another big pain point that we have encountered is the validation of arguments passed from JavaScript to native functions. This is especially painful when it comes to `NSDictionary` or `ReadableMap`, where the type of values is unknown in runtime and each property needs to be validated separately by yourself. A valuable feature of the Expo Modules API is that it has full knowledge of the argument types the native function expects, so it can pre-validate and convert the arguments for you! The dictionaries can be represented as native structs that we call [Records](#records). Knowing the argument types, we are also able to automatically convert parameters to some platform-specific types (e.g. `{ x: number, y: number }` or `[number, number]` can be translated to CoreGraphics's `CGPoint`).

1️⃣ Create Swift and Kotlin files with your module's code.

<CodeBlocksTable>

```swift
import ExpoModulesCore

public class MyModule: Module {
  public func definition() -> ModuleDefinition {
    // Definition components go here
  }
}
```

```kotlin
package my.module.package

import expo.modules.kotlin.modules.Module
import expo.modules.kotlin.modules.ModuleDefinition

class MyModule : Module() {
  override fun definition() = ModuleDefinition {
    // Definition components go here
  }
}
```

```
// `import` from Kotlin seems to be breaking syntax highlighting in VSCode :O
// Adding another code block solves the issue.
```

</CodeBlocksTable>

2️⃣ Make sure that your module class is included in `modulesClassNames` in the **expo-module.config.json** config.

```json
{
  "ios": {
    "modulesClassNames": ["MyModule"]
  },
  "android": {
    "modulesClassNames": ["my.module.package.MyModule"]
  }
}
```

3️⃣ On iOS you also need to run `pod install` to properly link the new class. On Android it will be linked automatically before building. Now you are ready to go and add some definition components in there!

## Module Definition Components

### `name`

Sets the name of the module that JavaScript code will use to refer to the module. Takes a string as an argument. Can be inferred from module's class name, but it's recommended to use it explicitly for clarity.

<CodeBlocksTable tabs={["Swift / Kotlin"]}>

```swift
name("MyModuleName")
```

</CodeBlocksTable>

### `constants`

Sets constant properties on the module. Can take the dictionary or the closure that returns the dictionary.

<CodeBlocksTable>

```swift
// Created from the dictionary
constants([
  "PI": 3.14159
])

// or returned by the closure
constants {
  return [
    "PI": 3.14159
  ]
}
```

```kotlin
constants(
  mapOf(
    "PI" to 3.14159
  )
)
```

</CodeBlocksTable>

### `function`

Defines the native function that will be exported to JavaScript.

#### Arguments

- **name**: `String` — Name of the function that you'll use in JavaScript to call the function.
- **body**: `(args...) -> ReturnType` — The closure to run when the function is called.

If the type of the last argument is `Promise`, the function is considered to be asynchronous which means it awaits for the promise to be resolved or rejected before the response is passed back to JavaScript. Otherwise, the function is immediately resolved with the returned value or rejected if it throws an error. Note that this is different than synchronous/asynchronous calls in JavaScript — at this moment all functions are _asynchronous_ from the JavaScript perspective.

The function can take only up to 8 arguments (including the promise) — due to the limitations of generics in both Swift and Kotlin, this component must be implemented separately for each number of arguments.

<CodeBlocksTable>

```swift
function("synchronousFunction") { (message: String) in
  return message
}

function("asynchronousFunction") { (message: String, promise: Promise) in
  DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
    promise.resolve(message)
  }
}
```

</CodeBlocksTable>

### `events`

Defines event names that the module can send to JavaScript.

<CodeBlocksTable>

```swift
events("onCameraReady", "onPictureSaved", "onBarCodeScanned")
```

```kotlin
events("onCameraReady", "onPictureSaved", "onBarCodeScanned")
```

</CodeBlocksTable>

### `viewManager`

Enables the module to be used as a view manager. The view manager definition is built from the components used in the closure passed to the component. Components that are accepted as part of the view manager definition: [`view`](#view), [`prop`](#prop).

<CodeBlocksTable>

```swift
viewManager {
  view {
    UIView()
  }

  prop("isHidden") { (view: UIView, hidden: Bool) in
    view.isHidden = hidden
  }
}
```

</CodeBlocksTable>

### `view`

Defines the factory creating a native view when the module is used as a view.

### `prop`

- **name**: `String` - Name of view prop that you want to define a setter.
- **setter**: `(view: ViewType, value: ValueType) -> ()` - Closure that is invoked when the view rerenders.

Defines a setter for the view prop of given name.

### `onCreate`

Defines module's lifecycle listener that is called right after module initialization. If you need to set up something when the module gets initialized, use this component instead of module's class initializer.

### `onDestroy`

Defines module's lifecycle listener that is called when the module is about to be deallocated. Use it instead of module's class destructor.

### `onStartObserving`

Defines the function that is invoked when the first event listener is added.

### `onStopObserving`

Defines the function that is invoked when all event listeners are removed.

### `onAppContextDestroys`

Defines module's lifecycle listener that is called when the app context owning the module is about to be deallocated.

### `onAppEntersForeground` 🍏

Defines the listener that is called when the app is about to enter the foreground mode.

> Note: It's not available on Android — you may want to use `onActivityEntersForeground` instead.

### `onAppEntersBackground` 🍏

Defines the listener that is called when the app enters the background mode.

> Note: It's not available on Android — you may want to use `onActivityEntersBackground` instead.

### `onAppBecomesActive` 🍏

Defines the listener that is called when the app becomes active again (after `onAppEntersForeground`).

> Note: It's not available on Android — you may want to use `onAppEntersForeground` instead.

### `onActivityEntersForeground` 🤖

> Note: It's not available on iOS — you may want to use `onAppEntersForeground` instead.

### `onActivityEntersBackground` 🤖

> Note: It's not available on iOS — you may want to use `onAppEntersBackground` instead.

### `onActivityDestroys` 🤖

Defines the listener that is called when the activity owning the JavaScript context is about to be destroyed.

> Note: It's not available on iOS — you may want to use `onAppEntersBackground` instead.

## Argument Types

Fundamentally, only some primitive and serializable data can be passed back and forth between the runtimes. However, usually native modules need to receive custom data structures — more sophisticated than just the dictionary/map where the values are of unknown (`Any`) type and so each value has to be validated and casted on its own. Expo Modules API offers some protocols to make it easier to work with data objects, to provide automatic validation, and finally, to ensure native type-safety on each object member.

### Convertibles

_Convertibles_ are the native types that can be initialized from some specific kind of data received from JavaScript. Such types are allowed to be used as an argument type in `function`'s body. As a good example, when the `CGPoint` type is used as a function argument type, its instance can be created from an array of two numbers (_x_, _y_) or a JavaScript object with numeric `x` and `y` properties.

Some common iOS types from `CoreGraphics` and `UIKit` system frameworks are already made convertible.

| Native Type | TypeScript                                                                                                         |
| ----------- | ------------------------------------------------------------------------------------------------------------------ |
| `URL`       | `string` with a URL. When scheme is not provided, it's assumed to be a file URL.                                   |
| `CGFloat`   | `number`                                                                                                           |
| `CGPoint`   | `{ x: number, y: number }` or `number[]` with _x_ and _y_ coords                                                   |
| `CGSize`    | `{ width: number, height: number }` or `number[]` with _width_ and _height_                                        |
| `CGVector`  | `{ dx: number, dy: number }` or `number[]` with _dx_ and _dy_ vector differentials                                 |
| `CGRect`    | `{ x: number, y: number, width: number, height: number }` or `number[]` with _x_, _y_, _width_ and _height_ values |
| `CGColor`   | Color hex strings in formats: `#RRGGBB`, `#RRGGBBAA`, `#RGB`, `#RGBA`                                              |
| `UIColor`   | Color hex strings in formats: `#RRGGBB`, `#RRGGBBAA`, `#RGB`, `#RGBA`                                              |

### Records

_Record_ is a convertible type and an equivalent of the dictionary (Swift) or map (Kotlin), but represented as a struct where each field can have its own well-known type and provides the default value.

<CodeBlocksTable>

```swift
struct FileReadOptions: Record {
  @Field
  var encoding: String = "utf8"

  @Field
  var position: Int = 0

  @Field
  var length: Int?
}

// Now this record can be used as an argument of the functions or the view prop setters.
function("readFile") { (path: String, options: FileReadOptions) -> String in
  // Read the file using given `options`
}
```

</CodeBlocksTable>

### Enums

With enums we can go even further with the above example (with `FileReadOptions` record) and limit supported encodings to `"utf8"` and `"base64"`. To use an enum as an argument or record field, it must represent a primitive value (e.g. `String`, `Int`) and conform to `EnumArgument`.

<CodeBlocksTable>

```swift
enum FileEncoding: String, EnumArgument {
  case utf8
  case base64
}

struct FileReadOptions: Record {
  @Field
  var encoding: FileEncoding = .utf8
  // ...
}
```

</CodeBlocksTable>

## Config Plugins

## Autolinking

## AppDelegate Subscribers

## Module Config

- `platforms` — An array of supported platforms.
- `ios` — Config with options specific to iOS platform
  - `modulesClassNames` — Names of Swift native modules classes to put to the generated modules provider file.
  - `appDelegateSubscribers` — Names of Swift classes that hooks into `ExpoAppDelegate` to receive AppDelegate life-cycle events.
- `android` — Config with options specific to Android platform
  - `modulesClassNames` — Full names (package + class name) of Kotlin native modules classes to put to the generated package provider file.

## Examples

<CodeBlocksTable>

```swift
public class MyModule: Module {
  public func definition() -> ModuleDefinition {
    name("MyFirstExpoModule")

    function("hello") { (name: String) in
      return "Hello \(name)!"
    }
  }
}
```

```kotlin
class MyModule : Module() {
  override fun definition() = ModuleDefinition {
    name("MyFirstExpoModule")

    function("hello") { name: String ->
      return "Hello $name!"
    }
  }
}
```

</CodeBlocksTable>

For more examples you can take a look on GitHub at some of Expo modules that already use this API:

- `expo-cellular` ([Swift](https://github.com/expo/expo/blob/master/packages/expo-cellular/ios/CellularModule.swift), [Kotlin](https://github.com/expo/expo/blob/master/packages/expo-cellular/android/src/main/java/expo/modules/cellular/CellularModule.kt))
- `expo-linear-gradient` ([Swift](https://github.com/expo/expo/blob/master/packages/expo-linear-gradient/ios/LinearGradientModule.swift))
- `expo-haptics` ([Swift](https://github.com/expo/expo/blob/master/packages/expo-haptics/ios/HapticsModule.swift))
