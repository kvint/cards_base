//
//  UserHand.swift
//  Core
//
//  Created by Alexander Slavschik on 3/3/18.
//  Copyright © 2018 Александр Славщик. All rights reserved.
//

import Foundation

class UserHand: Hand, BJUserHand {
    
    var isDone: Bool = false
    var stake: Double = 0
    var playing: Bool = false

    func getActions() -> Set<BJAction> {
        guard self.cards.count > 1 else {
            return [] // TODO: throw exception?
        }
        
        let score = self.getScore().hard
        guard score < BlackJackConstants.MAX_SCORE else {
            return []
        }
        
        var actions: Set<BJAction> = [BJAction.Stand, BJAction.Hit];
        
        if self.cards.count == 2 {
            
            actions.insert(BJAction.Double)
            
            let card1 = self.cards.first!
            let card2 = self.cards.last!
            
            let score1 = card1.score.hard
            let score2 = card2.score.hard
            
            // check for split
            if score1 == score2 {
                actions.insert(BJAction.Split)
            } else {
                let hasTen = score1 == 10 || score2 == 10
                let hasAce = card1.rank == Rank.Ace || card2.rank == Rank.Ace
                if hasTen && hasAce {
                    return []
                }
            }
        }
        return actions;
    }
    func split() -> BJUserHand? {
        guard self.cards.count == 2 else {
            return nil
        }
        var sHand = UserHand(self.id + "s")
        let card: Card = self.cards.popLast()!
        sHand.cards.append(card)
        return sHand
    }
    override func clear() {
        super.clear()
        self.stake = 0
        self.playing = false
    }
}
