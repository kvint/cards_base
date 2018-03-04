//
// Created by Александр Славщик on 02.03.2018.
// Copyright (c) 2018 Александр Славщик. All rights reserved.
//

import Foundation

class GameModel: BJModel {

    var deck: [Card] = []
    var dealer: BJDealerHand = Dealer()
    var activeHandIndex: Int? = nil

    private var handsDict: [Int: BJUserHand] = [:]
    private(set) var hands: [BJUserHand?] = []
    private(set) var activeHand: BJUserHand? = nil

    func createDeck() {
        self.deck = []
        for _ in 1...4 {
            self.deck += Deck()
        }
        self.deck.shuffle()
    }

    func getHand(at: Int, create: Bool = false) -> BJUserHand? {
        guard let hand = self.handsDict[at] else {
            if create {
                return self.createHand(at)
            }
            return nil
        }
        return hand
    }

    func createHand(_ at: Int) -> BJUserHand? {
        guard let newHand = UserHand(String(at)) as? BJUserHand else {
            return nil
        }
        self.handsDict[at] = newHand
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

    func getNextHand() -> BJUserHand? {
        guard let aHandId = self.activeHand?.id else {
            return nil
        }
        // TODO: refactor-refactor
        var n = false;
        for hand in hands {
            if hand != nil && n {
                return hand
            }
            if let handId = hand?.id {
                if handId == aHandId {
                    n = true
                }
            }
        }
        return nil
    }

    func clear() {
        self.activeHandIndex = nil
        self.deck = []
        self.hands = []
        self.handsDict = [:]
        self.dealer.clear()
    }
}
