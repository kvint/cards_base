//
//  TDeal.swift
//  CardsBaseTests
//
//  Created by Александр Славщик on 17.03.2018.
//  Copyright © 2018 Александр Славщик. All rights reserved.
//

import Foundation

import XCTest
@testable import CardsBase

class TDealAction: XCTestCase {
    
    let game = MockGame()
    
    func testInitial() {
        XCTAssertEqual(game.getActions(), [])
    }
    func testAfterBet() {
        try! game.bet(index: 5, stake: 10)
        
        XCTAssertEqual(game.getActions(), [BJAction.Deal])
    }
}
