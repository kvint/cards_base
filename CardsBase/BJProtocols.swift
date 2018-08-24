//
// Created by Alexander Slavschik on 2/16/18.
// Copyright (c) 2018 alexander.slavschik. All rights reserved.
//

import Foundation

public enum BJAction {
    case Deal, Double, Split, Hit, Stand, Insurance
}
public enum BJError: Error {
    case handError, betError, noCardsLeft
}
public protocol UserModel {
    var balance: Double {get}
}
public protocol BJGame {
    var delegate: GameDelegate? {get set}
    var live: Bool {get}

    func bet(index: Int, stake: Double) throws
    func bet(handId: String, stake: Double) throws
    func pullCard() -> Card?

    func deal() throws
    func double() throws
    func split() throws
    func insurance() throws
    func hit() throws
    func stand() throws

    func getActions() -> Set<BJAction>
}

public protocol BJModel {
    var deck: [Card] {get}
    var dealer: BJDealerHand {get set}
    var activeHand: BJUserHand? {get}
    var hands: [BJUserHand?] {get}

    func setActiveHand(index: Int?) -> Void
    func getNextHandIndex() -> Int?
    func createDeck() -> Void
    func createHand(id: String) -> BJUserHand
    func getHand(id: String) -> BJUserHand?

    func clear() -> Void
}

public protocol BJHand {
    var id: String {get}
    var cards: [Card] {get set}
    var payedOut: Bool {get set}
    func getScore() -> (hard: Int, soft: Int?)
    func gotBusted() -> Bool
    func gotBlackjack() -> Bool
    func gotCharlie() -> Bool
    func getFinalScore() -> Int
    func clear() -> Void
}

public protocol BJUserHand: BJHand {
    var stake: Double {get set}
    var win: Double {get set}
    var doubleBet: Double {get set}
    var doubleWin: Double {get set}
    var playing: Bool {get set}
    var isDone: Bool {get set}
    var totalBet: Double {get}
    var totalWin: Double {get}

    func split() -> BJUserHand?
    func getActions() -> Set<BJAction>
}

public protocol BJDealerHand: BJHand {
    var insuranceAvailable: Bool {get}
}

public protocol GameDelegate: class {
    func didHandChange(_ hand: inout BJHand)
    func roundStarted()
    func roundEnded()

    func didHandUpdate(_ hand: inout BJHand)
    func didDealCard(_ card: Card, _ hand: inout BJHand)
    func didHandDone(_ hand: inout BJUserHand)
    func betOnHand(handId: String) -> Void
}
