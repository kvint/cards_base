//
// Created by Александр Славщик on 25.02.2018.
// Copyright (c) 2018 Александр Славщик. All rights reserved.
//

import Foundation
class MockGame: Game {

    func setUp(deck: [Card]) -> Void {
        self.model.deck = deck
    }

    override func deal() {
        //deal the cards
        self.dealCards()
        self.startRound()
    }
}