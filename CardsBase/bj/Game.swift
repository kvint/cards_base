//
// Created by Александр Славщик on 02.03.2018.
// Copyright (c) 2018 Александр Славщик. All rights reserved.
//
import Foundation

public class Game: BJGame {
    
    public weak var delegate: GameDelegate? = nil

    public var model: GameModel = GameModel()
    public var live: Bool = false //TODO: make private

    public init() {}
    
    var totalStake: Double {
        get {
            var total = 0.0
            self.model.hands.forEach{
                if let hand = $0 {
                    total = total + hand.stake
                }
            }
            return total
        }
    }
    
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
        self.delegate?.didHandChange(&dealer)
        
        while dealer.getFinalScore() < BlackJackConstants.MAX_SCORE {
            self.dealCardTo(hand: &dealer)
        }
        self.delegate?.roundEnded()
    }

    internal func dealCardToUser(hand: inout BJUserHand) {
        guard var uhnd = hand as BJHand? else {
            return
        }
        self.dealCardTo(hand: &uhnd)
    }

    internal func dealCardTo(hand: inout BJHand) {
        guard let card = model.deck.popLast() else {
            fatalError("There is no cards left in deck")
        }
        hand.cards.append(card)
        self.delegate?.didDealCard(card, &hand)
    }

    public func pullCard() -> Card? {
        return self.model.deck.popLast()
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

    public func bet(index: Int, stake: Double) throws -> Void {
        return try self.bet(handId: String(index), stake: stake)
    }
    public func bet(handId: String, stake: Double) throws -> Void {
        var hand: BJUserHand? = self.model.getHand(id: handId)
        if hand == nil {
            hand = self.model.createHand(id: handId)
        }
        guard hand != nil else {
            throw BJError.handError
        }
        let finalStake = hand!.stake + stake;
        guard finalStake >= 0 else {
            throw BJError.betError
        }
        hand!.stake = finalStake
    }

    public func deal() throws {
        let stake = self.totalStake
        
        guard stake > 0 else {
            throw BJError.betError
        }
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
            self.model.hands.forEach {
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

    public func double() throws {
        guard var hand = self.model.activeHand else {
            throw BJError.handError
        }
        hand.stake += hand.stake
        self.dealCardToUser(hand: &hand)
        hand.isDone = true

        var bjHand = hand as BJHand
        self.delegate?.didHandUpdate(&bjHand)

        self.nextStep()
    }

    public func split() throws {
        guard let hand = self.model.activeHand else {
            throw BJError.handError
        }

        let newHands = self.model.splitHand(id: hand.id)

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

    public func insurance() throws {
        throw BJError.handError
    }

    public func hit() throws {
        guard var hand = self.model.activeHand else {
            throw BJError.handError
        }
        self.dealCardToUser(hand: &hand)

        var bjHand = hand as BJHand
        self.delegate?.didHandUpdate(&bjHand)

        self.nextStep()
    }

    public func stand() throws {
        guard var hand = self.model.activeHand else {
            throw BJError.handError
        }
        hand.isDone = true;
        print("do next step")
        self.nextStep()
    }
    public func getActions() -> Set<BJAction> {
        if !live && totalStake > 0 {
            return [BJAction.Deal]
        }
        
        guard let actions = self.model.activeHand?.getActions() else {
            return []
        }
        return actions
    }
}
