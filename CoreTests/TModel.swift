//
//  TCards.swift
//  BlackjackTests
//
//  Created by Alexander Slavschik on 2/20/18.
//  Copyright © 2018 Alexander Slavschik. All rights reserved.
//

import XCTest
@testable import Core

class TModel: XCTestCase {

    var model: GameModel = GameModel()

    func testGameStart() {
        XCTAssert(self.model.deck.count == 0, "Deck should be zero")
        self.model.createDeck()

        XCTAssert(self.model.deck.count == 208, "Deck should be 208 but it is \(self.model.deck.count)")

        let hand0: BJUserHand? = self.model.createHand(id: "0")
        XCTAssert(hand0 != nil, "0 hand should not be nil")

        let hand1: BJUserHand? = self.model.getHand(id: "0")

        XCTAssert((hand0 as! Hand) == (hand1 as! Hand), "same index hands should be equal")
        XCTAssert(self.model.createHand(id: "100") != nil, "100 hand should not be nil")
        XCTAssert(self.model.getHand(id: "1") == nil, "1 should be nil")
    }
    func testNextHand() {
        /*let _: BJUserHand = self.model.getHand(id: "0")!

        self.model.setActiveHand(index: 0)

        let nextHand: BJUserHand? = self.model.getNextHand()

        XCTAssert(nextHand == nil, "Hand after zero should be nil")*/
    }

    override func tearDown() {
        self.model.clear();
        super.tearDown()
    }
}
