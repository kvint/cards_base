//
// Created by Александр Славщик on 02.03.2018.
// Copyright (c) 2018 Александр Славщик. All rights reserved.
//
import Foundation

class Game: BJGame {
    var delegate: GameDelegate? = nil

    var model: GameModel = GameModel()
    private(set) var live: Bool = false

    internal func startRound() {
        self.live = true

        self.model.setActiveHand(index: self.model.getNextHandIndex())
        self.delegate?.roundStarted()
        self.nextStep()
    }

    internal func endRound() {
        self.live = false
        self.model.setActiveHand(index: nil)

        var dealer = self.model.dealer as BJHand

        while (self.model.dealer as! Hand).getFinalScore() < 17 {
            self.dealCardTo(hand: &dealer)
        }
        self.delegate?.didHandChange(&dealer)
        self.delegate?.roundEnded()
    }

    internal func dealCardToUser(hand: inout BJUserHand) {
        guard var uhnd = hand as BJHand? else {
            return
        }
        self.dealCardTo(hand: &uhnd)
    }

    internal func dealCardTo(hand: inout BJHand) {
        let card = self.pullCard()
        hand.cards.append(card)
        self.delegate?.didDealCard(card, &hand)
    }

    private func nextStep() -> Void {
        guard var hand = self.model.activeHand else {
            return self.endRound()
        }
        if hand.getScore().hard >= BlackJackConstants.MAX_SCORE {
            hand.isDone = true
            hand.playing = false // got bust
        }
        if hand.isDone {
            self.delegate?.didHandDone(&hand)

            guard let nextHandIndex = self.model.getNextHandIndex() else {
                return self.endRound()
            }
            self.model.setActiveHand(index: nextHandIndex)

            guard let aHand = self.model.activeHand else {
                return self.nextStep()
            }
            var bjHand = aHand as BJHand

            guard aHand.getActions().count > 0 else {
                return self.nextStep()
            }
            self.delegate?.didHandChange(&bjHand)
        }
    }

    func bet(index: Int, stake: Double) {
        return self.bet(handId: String(index), stake: stake)
    }
    func bet(handId: String, stake: Double) {
        var hand = self.model.getHand(id: handId)
        if hand == nil {
            hand = self.model.createHand(id: handId)
        }
        hand!.stake = stake
    }

    func pullCard() -> Card {
        guard let card = self.model.deck.popLast() else {
            fatalError("Cards deck is empty")
        }
        return card
    }

    func deal() {
        // create deck
        self.model.createDeck()

        //deal the cards
        self.dealCards()
        self.startRound()
    }

    internal func dealCards() {
        var dealer = self.model.dealer as BJHand
        for i in 1...2 {
            self.dealCardTo(hand: &dealer)
            if i == 2 {
                self.delegate?.didHandUpdate(&dealer)
            }
            self.model.hands.forEach{
                if var hand = $0 {
                    hand.isDone = false
                    hand.playing = true
                    self.dealCardToUser(hand: &hand)
                    
                    if i == 2 {
                        var bjHand = hand as BJHand
                        self.delegate?.didHandUpdate(&bjHand)
                    }
                }
            }
        }
    }

    func double() {
        guard var hand = self.model.activeHand else {
            return;
        }
        hand.stake += hand.stake
        self.dealCardToUser(hand: &hand)
        hand.isDone = true

        var bjHand = hand as BJHand
        self.delegate?.didHandUpdate(&bjHand)

        self.nextStep()
    }

    func split() {
        guard var hand = self.model.activeHand else {
            return;
        }

        var newHands = self.model.splitHand(id: hand.id)

        var aHand = newHands.active
        var sHand = newHands.additional

        self.dealCardToUser(hand: &aHand)
        self.dealCardToUser(hand: &sHand)

        if aHand.cards.first?.rank == Rank.Ace && sHand.cards.first?.rank == Rank.Ace {
            // two aces case
            aHand.isDone = true
            sHand.isDone = true
        }

        self.nextStep();
    }

    func insurance() {
        fatalError("insurance() has not been implemented")
    }

    func hit() {
        guard var hand = self.model.activeHand else {
            return;
        }
        self.dealCardToUser(hand: &hand)

        var bjHand = hand as BJHand
        self.delegate?.didHandUpdate(&bjHand)

        self.nextStep()
    }

    func stand() {
        guard var hand = self.model.activeHand else {
            return;
        }
        hand.isDone = true;
        self.nextStep()
    }
    func getActions() -> Set<BJAction> {
        guard let actions = self.model.activeHand?.getActions() else {
            return []
        }
        return actions
    }
}
