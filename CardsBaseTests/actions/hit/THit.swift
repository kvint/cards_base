//
// Created by Александр Славщик on 25.02.2018.
// Copyright (c) 2018 Александр Славщик. All rights reserved.
//

import XCTest
@testable import CardsBase

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

        try! self.game.bet(index: 1, stake: 10)

        try! self.game.deal()
    }

    func testHit() {
        let hand = self.game.model.activeHand!

        try! self.game.hit()
        XCTAssertEqual(hand.cards.count, 3)

        try! self.game.hit()
        XCTAssertEqual(hand.cards.count, 4)

        try! self.game.hit()
        XCTAssertEqual(hand.cards.count, 5)
    }
}
