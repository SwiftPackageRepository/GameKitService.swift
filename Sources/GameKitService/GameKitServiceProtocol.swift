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
