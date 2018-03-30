//
// Created by Alexander Slavschik on 3/30/18.
// Copyright (c) 2018 Александр Славщик. All rights reserved.
//

import XCTest

class TBlackjack: TBJGameCase {

    override func setUp() {
        super.setUp()

        fillDeck([
            // Dealer
            Card(Rank.Queen), Card(Rank.Queen),

            //Hands
            Card(Rank.c10), Card(Rank.Ace),
            Card(Rank.King), Card(Rank.Ace),
            Card(Rank.Ace), Card(Rank.Jack),
            Card(Rank.Queen), Card(Rank.Ace),
            Card(Rank.Ace), Card(Rank.Ace),
        ]);

        try! self.game.bet(index: 1, stake: 10)
        try! self.game.bet(index: 2, stake: 10)
        try! self.game.bet(index: 3, stake: 10)
        try! self.game.bet(index: 5, stake: 10)

        try! self.game.deal()
    }

}
