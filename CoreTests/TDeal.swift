//
//  TCards.swift
//  BlackjackTests
//
//  Created by Alexander Slavschik on 2/20/18.
//  Copyright © 2018 Alexander Slavschik. All rights reserved.
//

import XCTest
@testable import Core

class TDeal: XCTestCase {

    let game = MockGame()

    override func setUp() {
        super.setUp()

        self.game.setUp(deck: [
            Card(Rank.Ace),
            Card(Rank.Ace),
            Card(Rank.Ace),
            Card(Rank.Ace),
            Card(Rank.Ace),
            Card(Rank.Ace),
            Card(Rank.Ace),
            Card(Rank.Ace),
            Card(Rank.Ace),
            Card(Rank.Ace),
            Card(Rank.Ace),
            Card(Rank.Ace),
            Card(Rank.Ace)
        ])

        self.game.bet(index: 1, stake: 10)
        self.game.bet(index: 2, stake: 10)
        self.game.bet(index: 3, stake: 10)
        self.game.bet(index: 4, stake: 10)
        self.game.bet(index: 5, stake: 10)

        self.game.deal()
    }
    func testCardsCount() {
        XCTAssertEqual(self.game.model.dealer.cards.count, 2)
        XCTAssertEqual(self.game.model.getHand(id: "1")?.cards.count, 2)
        XCTAssertEqual(self.game.model.getHand(id: "2")?.cards.count, 2)
        XCTAssertEqual(self.game.model.getHand(id: "3")?.cards.count, 2)
        XCTAssertEqual(self.game.model.getHand(id: "4")?.cards.count, 2)
        XCTAssertEqual(self.game.model.getHand(id: "5")?.cards.count, 2)
    }
    func testActiveHand() {
        XCTAssertNotNil(self.game.model.activeHand)
        XCTAssertEqual(self.game.model.activeHandIndex, 0)
    }
}
