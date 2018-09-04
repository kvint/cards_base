//
// Created by Александр Славщик on 02.03.2018.
// Copyright (c) 2018 Александр Славщик. All rights reserved.
//

import Foundation

public class GameModel: BJModel {

    public var deck: [Card] = []
    public var dealer: BJDealerHand = Dealer()
    public var activeHandIndex: Int? = nil

    public var hands: [BJUserHand?] = []
    private var handsDict: [String: BJUserHand] = [:]

    public var activeHand: BJUserHand? {
        get {
            guard let i = self.activeHandIndex else {
                return nil
            }
            return self.hands[i]
        }
    }

    public func createDeck() {
        self.deck = []
        for _ in 1...4 {
            self.deck += Deck()
        }
        self.deck.shuffle()
    }

    public func getHand(id: String) -> BJUserHand? {
        return self.handsDict[id]
    }

    public func createHand(id: String) -> BJUserHand {
        return self.addHand(UserHand(id))
    }
    public func addHand(_ hand: BJUserHand) -> BJUserHand {
        self.handsDict[hand.id] = hand
        self.hands.append(hand)
        return hand
    }

    public func setActiveHand(index: Int?) -> Void {
        guard let i = index else {
            self.activeHandIndex =  nil
            return
        }
        self.activeHandIndex = i
    }

    public func getNextHandIndex() -> Int? {

        guard let index = self.activeHandIndex else {
            return self.hands.index(where: { $0 != nil && ($0?.playing)! && !($0?.isDone)! })
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
        _ = self.addHand(sHand)

        return (active: aHand, additional: sHand)
    }

    public func clear() {
        self.activeHandIndex = nil
        self.deck = []
        self.hands = []
        self.handsDict = [:]
        self.dealer.clear()
    }
}
