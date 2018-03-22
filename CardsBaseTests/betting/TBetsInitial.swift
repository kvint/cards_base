//
//  TCards.swift
//  BlackjackTests
//
//  Created by Alexander Slavschik on 2/20/18.
//  Copyright © 2018 Alexander Slavschik. All rights reserved.
//

import XCTest
@testable import CardsBase

class TBetsInitial: XCTestCase {

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

        try! self.game.bet(index: 1, stake: 10)
        try! self.game.bet(index: 2, stake: 20)
        try! self.game.bet(index: 3, stake: 30)
        try! self.game.bet(index: 4, stake: 40)
        try! self.game.bet(index: 5, stake: 50)
    }
    func testInitialStake() {
        XCTAssertEqual(self.game.model.getHand(id: "1")?.stake, 10)
        XCTAssertEqual(self.game.model.getHand(id: "2")?.stake, 20)
        XCTAssertEqual(self.game.model.getHand(id: "3")?.stake, 30)
        XCTAssertEqual(self.game.model.getHand(id: "4")?.stake, 40)
        XCTAssertEqual(self.game.model.getHand(id: "5")?.stake, 50)
    }
    func testThrows() {
        let _: BJUserHand? = self.game.model.getHand(id: "1")

        XCTAssertThrowsError(try self.game.bet(handId: "1", stake: -20), "Negative stake case") { (error) -> Void in
            XCTAssertEqual(error as? BJError, BJError.betError)
        }

        XCTAssertNoThrow(try self.game.bet(handId: "1", stake: -10), "Zero stake case")

//        XCTAssertEqual(firstHand?.stake, 10)
        XCTAssertEqual(self.game.model.getHand(id: "2")?.stake, 20)
        XCTAssertEqual(self.game.model.getHand(id: "3")?.stake, 30)
        XCTAssertEqual(self.game.model.getHand(id: "4")?.stake, 40)
        XCTAssertEqual(self.game.model.getHand(id: "5")?.stake, 50)
    }
}
