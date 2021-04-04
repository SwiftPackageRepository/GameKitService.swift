///
/// MIT License
///
/// Copyright (c) 2020 Sascha Müllner
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in all
/// copies or substantial portions of the Software.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
/// SOFTWARE.
///
/// Created by Sascha Müllner on 04.12.20.

import Combine
import Foundation
import GameKit

/// GameKitService
public class GameKitService : NSObject, GKMatchDelegate, GKLocalPlayerListener, GameKitServiceProtocol {

    fileprivate var players = [String : GKPlayer]()

    public var authenticated = CurrentValueSubject<Bool, Never>(false)
    public var started = PassthroughSubject<GKMatch, Never>()
    public var received = PassthroughSubject<(match: GKMatch, data: Data, player: GKPlayer), Never>()
    public var ended = PassthroughSubject<GKMatch, Never>()

    public var match: GKMatch?

    public static let shared = GameKitService()

    private override init() {
        super.init()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(GameKitService.authenticationChanged),
            name: Notification.Name.GKPlayerAuthenticationDidChangeNotificationName,
            object: nil)

        GKLocalPlayer.local.register(self)
    }

    // MARK: Public functions

    public func start(_ match: GKMatch) {
        self.match = match
        match.delegate = self
    }

    public func send(_ data: Data) throws {
        guard let match = self.match else { return }
        try match.sendData(toAllPlayers: data, with: .reliable)
    }

    public func send(_ data: Data, players: [GKPlayer]) throws {
        guard let match = self.match else { return }
        try match.send(data, to: players, dataMode: .reliable)
    }

    // MARK: GKMatchDelegate

    public func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
        if self.match != match {
            return
        }
        self.received.send((match: match, data: data, player: player))
    }

    public func match(_ match: GKMatch, player: GKPlayer, didChange state: GKPlayerConnectionState) {
        switch state {
            case .connected:
                self.lookupPlayers()
                break
            case .disconnected:
                self.ended.send(match)
                self.match = nil
                break
            default:
                break
        }
    }

    public func match(_ match: GKMatch, didFailWithError error: Error?) {
        if self.match != match {
            return
        }

        print("Match failed with error: \(String(describing: error?.localizedDescription))")
        self.ended.send(match)
    }


    // MARK: GKLocalPlayerListener
    public func player(_ player: GKPlayer, didAccept invite: GKInvite) {
    }

    // MARK: Private functions
    @objc fileprivate func authenticationChanged() {
        if GKLocalPlayer.local.isAuthenticated && !self.authenticated.value  {
            self.authenticated.value = true
        } else {
            self.authenticated.value  = false
        }
    }

    fileprivate func lookupPlayers() {
        guard let match = self.match else { return }

        let playerIDs = match.players.map { $0.teamPlayerID }

        GKPlayer.loadPlayers(forIdentifiers: playerIDs) { (players, error) in
            guard error == nil else {
                print("Error retrieving player info: \(String(describing: error?.localizedDescription))")
                self.ended.send(match)
                return
            }

            guard let players = players else {
                print("Error retrieving players; returned nil")
                return
            }

            for player in players {
                print("Found player: \(String(describing: player.alias))")
                self.players[player.teamPlayerID] = player
            }

            GKMatchmaker.shared().finishMatchmaking(for: match)
            self.started.send(match)
        }
    }
}
