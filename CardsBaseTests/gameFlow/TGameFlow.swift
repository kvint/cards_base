//
//  TGameFlow.swift
//  CardsBaseTests
//
//  Created by Александр Славщик on 17.03.2018.
//  Copyright © 2018 Александр Славщик. All rights reserved.
//

import Foundation
import XCTest

class TGameFlow: XCTestCase {
    
    var game: MockGame = MockGame()
    
    func testNotLiveAfterRoundEnds() {
        
        game.setUp(deck: [
            Card(Rank.Ace), Card(Rank.Ace),
            Card(Rank.Ace), Card(Rank.Ace),
            Card(Rank.Ace), Card(Rank.Ace),
            Card(Rank.c10), Card(Rank.c10)
        ]);
        
        try! game.bet(index: 0, stake: 10)

        try! game.deal()
        XCTAssertTrue(game.state == .Idle)

        try! game.stand()
        XCTAssertFalse(game.state == .Idle)
    }
    func testNotLiveAfter21() {
        
        game.setUp(deck: [
            Card(Rank.c2), Card(Rank.c2),
            Card(Rank.c8), Card(Rank.c3),
            Card(Rank.c10), Card(Rank.Ace),
            Card(Rank.c10), Card(Rank.c10)
            ]);
        
        try! game.bet(index: 0, stake: 10)
        
        try! game.deal()
        XCTAssertTrue(game.state == .Idle)
        
        try! game.hit()
        XCTAssertTrue(game.state == .Betting)
    }
}
