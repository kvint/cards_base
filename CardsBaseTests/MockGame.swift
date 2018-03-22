//
// Created by Александр Славщик on 25.02.2018.
// Copyright (c) 2018 Александр Славщик. All rights reserved.
//

import Foundation
class MockGame: Game {

    func setUp(deck: [Card]) -> Void {
        self.model.deck = deck.reversed()
    }
    internal override func dealCards() {
        for _ in 1...2 {
            var dealer = self.model.dealer as BJHand
            self.dealCardTo(hand: &dealer)
        }

        for h in self.model.hands {
            guard var hand = h else {
                continue
            }
            hand.isDone = false
            hand.playing = true
            for _ in 1...2 {
                self.dealCardToUser(hand: &hand)
            }
        }
    }

    override func deal() throws {
        print("dealing...")
        //deal the cards
        self.dealCards()
        print("dealt")
        self.startRound()
        print("round started")
    }
}
