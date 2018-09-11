//
//  TCards.swift
//  BlackjackTests
//
//  Created by Alexander Slavschik on 2/20/18.
//  Copyright © 2018 Alexander Slavschik. All rights reserved.
//

import XCTest
@testable import CardsBase

class TPWin: XCTestCase {

    let game = MockGame()

    func testPayout() {
        
        self.game.setUp(deck: [
            Card(Rank.c10),
            Card(Rank.King),
            
            Card(Rank.c5),
            Card(Rank.c5),
            Card(Rank.c5),
            Card(Rank.c6)
            ])
        
        try! self.game.bet(index: 1, stake: 10)
        try! self.game.deal()
        
        try! self.game.hit()
        try! self.game.hit()
        try? self.game.stand()
        XCTAssertEqual(self.game.model.hands[0]!.win, 20)
    }
    func testDealerTakes() {
        
        self.game.setUp(deck: [
            Card(Rank.c10),
            Card(Rank.King),
            
            Card(Rank.c5),
            Card(Rank.c5),
            Card(Rank.c5),
            Card(Rank.c6)
        ])
        
        try! self.game.bet(index: 1, stake: 10)
        try! self.game.deal()
        try? self.game.stand()
        
        XCTAssertEqual(self.game.model.dealer.cards.count, 2)
    }
}
