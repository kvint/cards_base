//
// Created by Alexander Slavschik on 2/16/18.
// Copyright (c) 2018 alexander.slavschik. All rights reserved.
//

import Foundation

enum BJAction {
    case Deal, Double, Split, Hit, Stand, Insurance
}
protocol UserModel {
    var balance: Double {get}
}
protocol BJGame {
    weak var delegate: GameDelegate? {get set}
    var live: Bool {get}

    func bet(index: Int, stake: Double)
    func bet(handId: String, stake: Double)
    func pullCard() -> Card

    func deal()
    func double()
    func split()
    func insurance()
    func hit()
    func stand()

    func getActions() -> Set<BJAction>
}

protocol BJModel {
    var deck: [Card] {get}
    var dealer: BJDealerHand {get set}
    var activeHand: BJUserHand? {get}
    var hands: [BJUserHand?] {get}

    func setActiveHand(index: Int?) -> Void
    func createDeck() -> Void
    func createHand(id: String) -> BJUserHand
    func getHand(id: String) -> BJUserHand?

    func clear() -> Void
}

protocol BJHand {
    var id: String {get}
    var cards: [Card] {get set}

    func getScore() -> (hard: Int, soft: Int?)
    func clear() -> Void
}

protocol BJUserHand: BJHand {
    var stake: Double {get set}
    var playing: Bool {get set}
    var isDone: Bool {get set}

    func split() -> BJUserHand?
    func getActions() -> Set<BJAction>
}

protocol BJDealerHand: BJHand {
    var insuranceAvailable: Bool {get}
}

protocol GameDelegate: class {
    func didHandChange(_ hand: inout BJHand)
    func roundStarted()
    func roundEnded()

    func didHandUpdate(_ hand: inout BJHand)
    func didDealCard(_ card: Card, _ hand: inout BJHand)
    func didHandDone(_ hand: inout BJUserHand)
}
