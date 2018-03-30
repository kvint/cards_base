//
// Created by Александр Славщик on 25.02.2018.
// Copyright (c) 2018 Александр Славщик. All rights reserved.
//

import Foundation
class MockGameModel: GameModel {
    public var mockDeck: [Card]!
    override func createDeck() {
        deck = mockDeck
    }
}
class MockGame: Game {

    override public init() {
        super.init()
        self.model = MockGameModel()
        self.dealingType = .Linear
    }

    func setUp(deck: [Card]) -> Void {
        (model as! MockGameModel).mockDeck = deck.reversed()
    }
}
