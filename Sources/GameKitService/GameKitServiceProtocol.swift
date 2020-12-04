///
/// GameKitServiceProtocol.swift
/// 
/// 
/// Created by Sascha Müllner on 04.12.20.

import Combine
import Foundation
import GameKit

/// Custom delegate used to provide information to the application implementing GameKitServiceProtocol.
public protocol GameKitServiceProtocol {

    var authenticated: CurrentValueSubject<Bool, Never> { get }

    /// Method called when a match has been initiated.
    var started: PassthroughSubject<GKMatch, Never> { get }

    /// Method called when the device receives data about the match from another device in the match.
    var received: PassthroughSubject<(match: GKMatch, data: Data, player: GKPlayer), Never> { get }

    /// Method called when the match has ended.
    var ended: PassthroughSubject<GKMatch, Never> { get }

    func start(_ match: GKMatch)

    func send(_ data: Data) throws

    func send(_ data: Data, players: [GKPlayer]) throws
}
