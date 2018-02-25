//
// Created by Александр Славщик on 25.02.2018.
// Copyright (c) 2018 Александр Славщик. All rights reserved.
//

import XCTest
@testable import Core

class THit: XCTestCase {

    let game = MockGame()

    override func setUp() {
        super.setUp()

        self.game.setUp(deck: [
            Card(Rank.Ace), Card(Rank.Ace),

            Card(Rank.Ace), Card(Rank.Ace),
            Card(Rank.Ace), Card(Rank.Ace),
            Card(Rank.Ace), Card(Rank.Ace),
            Card(Rank.Ace), Card(Rank.Ace),
            Card(Rank.Ace), Card(Rank.Ace),

            Card(Rank.Ace)
        ])

        self.game.bet(index: 1, stake: 10)

        self.game.deal()
    }

    func testHit() {
        let hand = self.game.model.activeHand!

        self.game.hit()
        XCTAssertEqual(hand.cards.count, 3)

        self.game.hit()
        XCTAssertEqual(hand.cards.count, 4)

        self.game.hit()
        XCTAssertEqual(hand.cards.count, 5)
    }
}