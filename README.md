# GameKitService.swift

## GameKit (GameCenter) helper for Swift

GameKitService is **created and maintaned with ❥** by Sascha Muellner.

---
[![Swift](https://github.com/SwiftPackageRepository/GameKitService.swift/workflows/Swift/badge.svg)](https://github.com/SwiftPackageRepository/GameKitService.swift/actions?query=workflow%3ASwift)
[![codecov](https://codecov.io/gh/SwiftPackageRepository/GameKitService.swift/branch/main/graph/badge.svg)](https://codecov.io/gh/SwiftPackageRepository/GameKitService.swift)
[![Platform](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FSwiftPackageRepository%2FGameKitService.swift%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/SwiftPackageRepository/GameKitService.swift)
[![License](https://img.shields.io/github/license/SwiftPackageRepository/GameKitService.swift)](https://github.com/SwiftPackageRepository/GameKitService.swift/blob/main/LICENSE)
![Version](https://img.shields.io/github/v/tag/SwiftPackageRepository/GameKitService.swift)
[![Swift Version](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FSwiftPackageRepository%2FGameKitService.swift%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/SwiftPackageRepository/GameKitService.swift)
[![SPM compatible](https://img.shields.io/badge/SPM-compatible-orange.svg?style=flat)](https://github.com/apple/swift-package-manager)
[![README](https://img.shields.io/badge/-README-lightgrey)](https://SwiftPackageRepository.github.io/GameKitService.swift)

## What?
This is a **Swift** package with support for iOS/macOS/tvOS that focuses on bridging the current GameKit implementation to a single service structure utilizing Combine to simplify and modernize GameKit's match handling. 

## Requirements

The latest version of GameKitService requires:

- Swift 5+
- iOS 13+
- Xcode 11+

## Installation

### Swift Package Manager
Using SPM add the following to your dependencies

``` 'GameKitService', 'master', 'https://github.com/SwiftPackageRepository/GameKitService.swift.git' ```

## How to use?

### Starting a match

Given you already authenticated the user and did initiate a match you, using for example [GCHelper](https://github.com/jackcook/GCHelper.git) or [GameKitUI](https://github.com/SwiftPackageRepository/GameKitUI.swift.git), you can now start it using **start** method from the **GameKitService**:

```swift
import GameKit
import GameKitService

let match: GKMatch

GameKitService
    .shared
    .start(match)
```

### Subscribing to match data changes

The following match data changes can be subscribed using the **GameKitService**. 

#### Authenticated

Subscribe to the `authenticated: CurrentValueSubject<Bool, Never>` CurrentValueSubject, to receive when the user is authenticated at the GameCenter.

```swift
import GameKit
import GameKitService

let match: GKMatch

GameKitService
    .shared
    .authenticated(match)
```

#### Match start

Subscribe to the `started: PassthroughSubject<GKMatch, Never>` PassthroughSubject, to receive data about the starting of the match.

```swift
var cancellable: AnyCancellable?

self.cancellable = GameKitService
    .ended
    .received.sink { (match: GKMatch) in
        // match: the ending match
    }
```

#### Match data

Subscribe to the `received: PassthroughSubject<(match: GKMatch, data: Data, player: GKPlayer), Never>` PassthroughSubject, to receive data about the match from another player's device in the match.

```swift
var cancellable: AnyCancellable?

self.cancellable = GameKitService
    .shared
    .received.sink { (match: GKMatch, data: Data, player: GKPlayer) in
        // match: the current match
        // data: the data send from
        // player: the player that did send the data  
    }
```

#### Match ended

Subscribe to the `ended: PassthroughSubject<GKMatch, Never>` PassthroughSubject, to receive data about the ending of the match.

```swift
var cancellable: AnyCancellable?

self.cancellable = GameKitService
    .ended
    .received.sink { (match: GKMatch) in
        // match: the ending match
    }
```

### Sending match data

To send data to other players in the match there are two possibilites. In the first one the data is send to all players in the match:

```swift
let data = "Hello Players!".data(using: .utf8)!

do {
    try GameKitService
        .shared
        .send(data)
} catch {
}
```

Where as the second possibility allows you to send to a dedicated group (one or more) of players in the match.

```swift
let playerOne: GKPlayer
let data = "Hello Player One!".data(using: .utf8)!

do {
    try GameKitService
        .shared
        .send(data, players: [playerOne])
} catch {
}
```



## Documentation
+ [Apple Documentation GameKit](https://developer.apple.com/documentation/gamekit/)
+ [raywenderlich.com: Game Center for iOS: Building a Turn-Based Game](https://www.raywenderlich.com/7544-game-center-for-ios-building-a-turn-based-game)
+ [raywenderlich.com: Game Center Tutorial: How To Make A Simple Multiplayer Game with Sprite Kit: Part 1/2](https://www.raywenderlich.com/7544-game-center-for-ios-building-a-turn-based-game)
+ [Medium: GameKit Real Time Multiplayer Tutorial](https://link.medium.com/Mwg3mSi4Ebb)


