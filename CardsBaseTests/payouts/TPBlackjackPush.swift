//
//  TCards.swift
//  BlackjackTests
//
//  Created by Alexander Slavschik on 2/20/18.
//  Copyright © 2018 Alexander Slavschik. All rights reserved.
//

import XCTest
@testable import CardsBase

class TPBlackjackPush: XCTestCase {

    let game = MockGame()

    override func setUp() {
        super.setUp()

        self.game.setUp(deck: [
            Card(Rank.Jack),
            Card(Rank.Ace),

            Card(Rank.Ace),
            Card(Rank.Jack)
        ])

        try! self.game.bet(index: 1, stake: 10)
        try! self.game.deal()
    }
    func testPayout() {
        XCTAssertEqual(self.game.model.hands[0]!.win, 10)
    }
}
