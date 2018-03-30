//
// Created by Александр Славщик on 25.02.2018.
// Copyright (c) 2018 Александр Славщик. All rights reserved.
//

import XCTest

class TSplit: TBJGameCase {

    override func setUp() {
        super.setUp()

        fillDeck([
            Card(Rank.Ace), Card(Rank.Ace),

            Card(Rank.c2), Card(Rank.c2),

            Card(Rank.Ace), Card(Rank.c10),

            Card(Rank.Ace), Card(Rank.Ace),
            Card(Rank.Ace), Card(Rank.Ace),
            Card(Rank.Ace), Card(Rank.Ace),
            Card(Rank.Ace), Card(Rank.Ace),

            Card(Rank.Ace), Card(Rank.Ace),
            Card(Rank.Ace), Card(Rank.Ace)
        ]);

        try! self.game.bet(index: 1, stake: 10)

        try! self.game.deal()
    }

    func testSplit() {

        XCTAssertEqual(self.game.model.hands.count, 1)
        try! self.game.split()
        for hand in self.game.model.hands {
            print(String(describing: hand?.id))
        }
        XCTAssertEqual(self.game.model.hands.count, 2)

        let activeHand: BJUserHand? = self.game.model.activeHand

        XCTAssertNotNil(activeHand)
        XCTAssertEqual(activeHand!.cards, [Card(Rank.c2), Card(Rank.Ace)])

        let sHand: BJUserHand? = self.game.model.getHand(id: "1s")
        XCTAssertNotNil(sHand)
        XCTAssertEqual(sHand!.cards, [Card(Rank.c2), Card(Rank.c10)])
    }

}
