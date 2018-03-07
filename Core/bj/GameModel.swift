//
// Created by Александр Славщик on 02.03.2018.
// Copyright (c) 2018 Александр Славщик. All rights reserved.
//

import Foundation

class GameModel: BJModel {

    var deck: [Card] = []
    var dealer: BJDealerHand = Dealer()
    var activeHandIndex: Int? = nil

    private var handsDict: [String: BJUserHand] = [:]
    private(set) var hands: [BJUserHand?] = []
    private(set) var activeHand: BJUserHand? = nil

    func createDeck() {
        self.deck = []
        for _ in 1...4 {
            self.deck += Deck()
        }
        self.deck.shuffle()
    }

    func getHand(id: String) -> BJUserHand? {
        return self.handsDict[id]
    }

    func createHand(id: String) -> BJUserHand {
        let newHand = UserHand(id)
        self.handsDict[id] = newHand
        self.hands.append(newHand)
        return newHand
    }

    func setActiveHand(index: Int?) -> Void {
        guard let i = index else {
            self.activeHand = nil
            self.activeHandIndex =  nil
            return
        }
        self.activeHandIndex = i
        self.activeHand = self.hands[i]
    }

    func getNextHandIndex() -> Int? {

        guard let index = self.activeHandIndex else {
            return self.hands.index(where: { $0 != nil })
        }

        for i in index..<self.hands.count {
            guard let hand: BJUserHand = self.hands[i] else {
                continue
            }
            if !hand.isDone && hand.playing {
                return i
            }
        }
        return nil
    }

    func splitHand(id: String) -> (active: BJUserHand, additional: BJUserHand) {
        guard let aHand = self.getHand(id: id) else {
            fatalError("Failed to split")
        }
        guard let sHand = aHand.split() else {
            fatalError("Failed to split")
        }

        self.handsDict[sHand.id] = sHand
        self.hands.append(sHand)

        return (active: aHand, additional: sHand)
    }

    func clear() {
        self.activeHandIndex = nil
        self.deck = []
        self.hands = []
        self.handsDict = [:]
        self.dealer.clear()
    }
}
