//
// Created by Александр Славщик on 25.02.2018.
// Copyright (c) 2018 Александр Славщик. All rights reserved.
//

import XCTest

class TStand: TBJGameCase {

    override func setUp() {
        super.setUp()

        fillDeck([
            Card(Rank.Ace), Card(Rank.Ace),

            Card(Rank.Ace), Card(Rank.Ace),
            Card(Rank.Ace), Card(Rank.Ace),
            Card(Rank.Ace), Card(Rank.Ace),
            Card(Rank.Ace), Card(Rank.Ace),
            Card(Rank.Ace), Card(Rank.Ace),
            Card(Rank.Ace), Card(Rank.Ace),

            Card(Rank.Ace), Card(Rank.Ace),
            Card(Rank.Ace), Card(Rank.Ace)
        ])

        try! self.game.bet(index: 1, stake: 10)

        try! self.game.deal()
    }

    func testStand() {

        XCTAssertEqual(self.game.model.activeHandIndex!, 0)
        try! self.game.stand()

        XCTAssertNil(self.game.model.activeHand)
    }
}
