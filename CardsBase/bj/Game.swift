//
// Created by Александр Славщик on 02.03.2018.
// Copyright (c) 2018 Александр Славщик. All rights reserved.
//
import Foundation

public class Game: BJGame {

    internal enum Dealing {
        case Linear, Classic
    }
    internal var dealingType: Dealing = .Classic

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
        
        if let activeHand = self.model.activeHand  {
            var bjHand = activeHand as BJUserHand
            self.delegate?.onDone(hand: &bjHand)
        }
        self.nextStep()
    }

    internal func endRound() {
        self.live = false
        self.model.setActiveHand(index: nil)

        var dealer = self.model.dealer as BJHand
        self.delegate?.onChanged(toHand: &dealer)
        
        var dealerFirstCard = dealer.cards[0]
        dealer.cards[0].hidden = false
        
        self.delegate?.revealDealerCard(dealerFirstCard)
        while dealer.getFinalScore() < BlackJackConstants.DEALER_STAYS {
            do {
                try self.dealCardTo(hand: &dealer)
            } catch BJError.noCardsLeft {
                // no cards left, so just stop dealing
                break;
            } catch {
                fatalError("Unhandled error during dealing to dealer")
            }
        }

        self.model.hands.forEach { (h) in
            if var hand = h {
                if hand.playing {
                    hand.isDone = true
                    self.payoutHand(&hand)
                }
            }
        }

        self.delegate?.roundEnded()
    }

    internal func dealCardToUser(hand: inout BJUserHand) throws -> Void {
        guard var uhnd = hand as BJHand? else {
            return
        }
        try self.dealCardTo(hand: &uhnd)
    }

    internal func dealCardTo(hand: inout BJHand, hidden: Bool = false) throws -> Void {
        guard var card = model.deck.popLast() else {
            throw BJError.noCardsLeft
        }
        card.hidden = hidden
        hand.cards.append(card)
        self.delegate?.onDealCard(toHand: &hand, card: card)
    }

    public func pullCard() -> Card? {
        return self.model.deck.popLast()
    }

    private func nextStep() -> Void {
        guard var hand = self.model.activeHand else {
            return self.endRound()
        }
        self.payoutHand(&hand)
        if hand.isDone {
            self.delegate?.onDone(hand: &hand)

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
            self.delegate?.onChanged(toHand: &bjHand)
        }
    }
    public func payoutHand(_ hand: inout BJUserHand) -> Void {
        guard !hand.payedOut else {
            return
        }
        let handScore = hand.getFinalScore()
        let dealerScore = self.model.dealer.getFinalScore()
        let stake = hand.stake

        if hand.gotBusted() {
            hand.playing = false
            hand.isDone = true
            hand.payedOut = true
            hand.win = 0
            self.delegate?.onBust(atHand: &hand)
        }
        if handScore == BlackJackConstants.MAX_SCORE {
            if hand.gotBlackjack() {
                if self.model.dealer.facedCard?.rank == Rank.Ace || self.model.dealer.facedCard?.score.hard == 10 {
                    hand.win = stake // possible push case
                } else {
                    hand.win = stake * 2.5
                    hand.payedOut = true
                    hand.playing = false
                }
                self.delegate?.onBlackjack(atHand: &hand)
            }
            hand.isDone = true
        }
        if !live && hand.isDone && !hand.payedOut {
            if handScore > dealerScore {
                hand.win = stake * 2
            } else if handScore == dealerScore {
                hand.win = stake // push
            } else {
                hand.win = 0
            }
            hand.payedOut = true
        }
        if hand.payedOut {
            self.delegate?.onPayout(hand: &hand)
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
        hand!.playing = true
        hand!.isDone = false
        hand!.stake = finalStake
        self.delegate?.onBet(toHand: &hand!)
    }

    public func deal() throws {
        let stake = self.totalStake
        
        guard stake > 0 else {
            throw BJError.betError
        }
        // create deck
        self.model.createDeck()

        //deal the cards
        try self.dealCards()
        self.startRound()
    }

    internal func dealCards() throws {
        var dealer = self.model.dealer as BJHand
        switch dealingType {
        case .Linear:
            for i in 1...2 {
                try self.dealCardTo(hand: &dealer, hidden: i == 1) // TODO: rethrow
            }
            try self.model.hands.forEach {
                if var hand = $0 {
                    if hand.playing {
                        for _ in 1...2 {
                            try self.dealCardToUser(hand: &hand)
                        }
                    }
                }
            }
        break;
        case .Classic:
            for i in 1...2 {
                try self.dealCardTo(hand: &dealer, hidden: i == 1) // TODO: rethrow
                if i == 2 {
                    self.delegate?.onUpdate(hand: &dealer)
                }
                try self.model.hands.forEach {
                    if var hand = $0 {
                        if hand.playing {
                            try self.dealCardToUser(hand: &hand)
                            if i == 2 {
                                var bjHand = hand as BJHand
                                self.delegate?.onUpdate(hand: &bjHand)
                            }
                        }
                    }
                }
            }
        break;
        }
    }

    public func double() throws {
        guard var hand = self.model.activeHand else {
            throw BJError.handError
        }
        let curStake = hand.stake
        hand.stake = curStake * 2
        try self.dealCardToUser(hand: &hand)
        hand.isDone = true

        var bjHand = hand as BJHand
        self.delegate?.onUpdate(hand: &bjHand)
        var bjUserHand = hand as BJUserHand
        self.delegate?.onBet(toHand: &bjUserHand)
        
        self.nextStep()
    }

    public func split() throws {
        guard let hand = self.model.activeHand else {
            throw BJError.handError
        }

        let newHands = self.model.splitHand(id: hand.id) // TODO: add try

        var aHand = newHands.active
        var sHand = newHands.additional

        defer {
            self.nextStep()
        }

        try self.dealCardToUser(hand: &aHand)
        try self.dealCardToUser(hand: &sHand)

        if aHand.cards.first?.rank == Rank.Ace && sHand.cards.first?.rank == Rank.Ace {
            // two aces case
            aHand.isDone = true
            sHand.isDone = true
        }
    }

    public func insurance() throws {
        throw BJError.handError
    }

    public func hit() throws {
        guard var hand = self.model.activeHand else {
            throw BJError.handError
        }

        defer {
            self.nextStep()
        }

        try self.dealCardToUser(hand: &hand)

        var bjHand = hand as BJHand
        self.delegate?.onUpdate(hand: &bjHand)
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
