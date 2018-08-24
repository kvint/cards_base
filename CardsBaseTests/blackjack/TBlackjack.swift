//
// Created by Alexander Slavschik on 3/30/18.
// Copyright (c) 2018 Александр Славщик. All rights reserved.
//

import XCTest

class TBlackjack: TBJGameCase {

    func testSingleHandBlackjack() {
        fillDeck([
            // Dealer
            Card(Rank.Queen), Card(Rank.Queen),

            //Hands
            Card(Rank.c10), Card(Rank.Ace)
        ]);

        try! game.bet(handId: "0", stake: 20)
        try! game.deal()

        XCTAssertFalse(game.live, "Game is done")
    }
    func testPayouts() {

    }
}
