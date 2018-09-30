//
// Created by Александр Славщик on 25.02.2018.
// Copyright (c) 2018 Александр Славщик. All rights reserved.
//

import XCTest

class THitGotBust: TBJGameCase {

    override func setUp() {
        super.setUp()

        fillDeck([
            // Dealer
            Card(Rank.c10), Card(Rank.c10),

            //Hand
            Card(Rank.c10), Card(Rank.c3), Card(Rank.c7), Card(Rank.c5)
        ])

        try! self.game.bet(index: 1, stake: 10)
        try! self.game.deal()
    }

    func testHit() {
        try! self.game.hit()
        try! self.game.hit()

        XCTAssertFalse(self.game.state == .Idle, "Game round should be ended here")
    }
}
