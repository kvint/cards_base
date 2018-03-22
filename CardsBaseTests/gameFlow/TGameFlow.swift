//
//  TGameFlow.swift
//  CardsBaseTests
//
//  Created by Александр Славщик on 17.03.2018.
//  Copyright © 2018 Александр Славщик. All rights reserved.
//

import Foundation
import XCTest

class TGameFlow: XCTestCase {
    
    var game: MockGame = MockGame()
    
    override func setUp() {
        game.setUp(deck: [
            Card(Rank.Ace), Card(Rank.Ace),
            Card(Rank.Ace), Card(Rank.Ace),
            Card(Rank.Ace), Card(Rank.Ace),
            Card(Rank.c10), Card(Rank.c10)
        ]);
    }
    func testNotLiveAfterRoundEnds() {
        try! game.bet(index: 0, stake: 10)
        try! game.deal()
        XCTAssert(game.live)
        try! game.stand()
        XCTAssert(!game.live)
    }
}
