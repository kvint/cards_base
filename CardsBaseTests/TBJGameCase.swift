//
// Created by Alexander Slavschik on 3/30/18.
// Copyright (c) 2018 Александр Славщик. All rights reserved.
//

import Foundation

import XCTest
@testable import CardsBase

class TBJGameCase: XCTestCase {

    let game = MockGame()
    let bank = MockBank()
    private var cards: [Card] = []

    func fillDeck(_ cards: [Card]) {
        self.cards = cards;
        self.game.setUp(deck: cards)
        self.game.bank = bank
        
    }
}
