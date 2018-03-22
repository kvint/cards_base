//
// Created by Александр Славщик on 25.02.2018.
// Copyright (c) 2018 Александр Славщик. All rights reserved.
//

import XCTest
@testable import CardsBase

class TDouble: XCTestCase {

    let game = MockGame()

    override func setUp() {
        super.setUp()

        self.game.setUp(deck: [
            // Dealer
            Card(Rank.Queen), Card(Rank.Queen),

            //Hand
            Card(Rank.c10), Card(Rank.c3),

            Card(Rank.c7),
            Card(Rank.c5)

        ])

        try! self.game.bet(index: 1, stake: 10)

        try! self.game.deal()
    }

    func testDouble() {
        let activeHand: BJUserHand = self.game.model.activeHand!
        try! self.game.double()

        XCTAssertEqual(activeHand.stake, 20)

        XCTAssertNil(self.game.model.activeHand)
    }
}
