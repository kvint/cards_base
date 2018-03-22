//
//  TCards.swift
//  BlackjackTests
//
//  Created by Alexander Slavschik on 2/20/18.
//  Copyright © 2018 Alexander Slavschik. All rights reserved.
//

import XCTest

class TCards: XCTestCase {

    func testOutput() {
        XCTAssert("♠️A" == Card(Rank.Ace, Suit.Spades).description)
    }
    func testUniq() {
        let card1 = Card(Rank.c2, Suit.Spades)
        let card2 = Card(Rank.c2, Suit.Hearts)

        XCTAssert(card1.suit != card2.suit)
        XCTAssert(card1.rank == card2.rank)
        XCTAssert(card1 != card2, "Cards with diff suits are equals")

        let card3 = Card(Rank.c2, Suit.Clubs)
        let card4 = Card(Rank.c3, Suit.Clubs)

        XCTAssert(card3.suit == card4.suit)
        XCTAssert(card3.rank != card4.rank)
        XCTAssert(card3 != card4, "Cards with diff ranks are equals")
    }

    func testDeck() {
        let deck = Deck()
        XCTAssert(deck.count == 52, "Deck should be counts 52")
    }

    func testDeckShuffle() {
        let deck = Deck().shuffled()
        XCTAssert(deck.count == 52, "Shuffled deck should be 52")
    }
    
}
