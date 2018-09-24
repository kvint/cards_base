//
//  main.swift
//  BJ-CLI
//
//  Created by Александр Славщик on 24.02.2018.
//  Copyright © 2018 Александр Славщик. All rights reserved.
//

import Foundation

var game: Game = Game()
let msg = MessagesQueue()

let SEP1 = "                                      ROUND /"
let SEP2 = "                                      NEXT HAND /"
let SEP3 = "_______________________"

func getResults(hand: inout BJHand) -> String {
    let scoreString = {() -> String in
        let score: (hard: Int, soft: Int?) = hand.getScore()
        guard let softScore = score.soft else {
            return "\(score.hard)"
        }
        return "\(score.hard)/\(softScore)"
    }()
    return "\(hand.cards) (\(scoreString))"
}

func printResults(_ prefix: String, hand: inout BJHand, wait: Int? = nil) {
    msg.push("\(prefix) \(getResults(hand: &hand))", wait);
}

class GameInterface: GameDelegate {
    func focusChanged(to: inout BJHand) {
        printResults("You:", hand: &to, wait: 400)
    }
    
    func updated(hand: inout BJHand) {
        printResults("", hand: &hand, wait: 200)
    }
    
    func cardDealt(toHand: inout BJHand, card: Card) {
        //msg.push("\(hand.id) --> \(card)", 100)
        guard toHand.cards.count > 2 else {
            return
        }
        msg.push("\(card)", 400)
    }
    
    func onBet(onHand: inout BJUserHand, regularBet: Bool) {
        
    }
    
    
    func onDealCard(toHand: inout BJHand, card: Card) {
        
    }
    
    func onDone(hand: inout BJUserHand) {
        var bjHand = hand as BJHand
        if hand.cards.count <= 2 {
            msg.push(getResults(hand: &bjHand))
        }
        msg.push(SEP2)
    }
    
    func revealDealerCard(_ card: Card) {
        //
        msg.push("\(card)", 400)
    }
    

    func roundStarted() {
        msg.push()
        msg.push()
        msg.push("Dealer: [\(game.model.dealer.cards.first!), ?*]")
        msg.push(SEP1)
        msg.push("", 500)
    }

    func roundEnded() {
        msg.push()

        var dealer = game.model.dealer as BJHand
        printResults("Dealer", hand: &dealer)
        msg.push("", 800)

        for hand in game.model.hands {
            guard let hnd = hand else {
                continue
            }
            var simpleHand = hnd as BJHand
            printResults("Hand \(hnd.id)", hand: &simpleHand)
        }
        msg.push()
        msg.push()
        msg.push(SEP1)
    }
}

var gameInterface = GameInterface()
game.delegate = gameInterface

func bet(handIndex: Int) -> Void {
    
    msg.push("Place your bet for hand \(handIndex) (100 by default)")
    
    //    guard let betValue = readLine() else {
    //        return
    //    }
    //
    //    guard let betDigit = Double(betValue) else {
    //        return game.bet(index: handIndex, stake: 100);
    //    }
    //    game.bet(index: handIndex, stake: betDigit);
    try! game.bet(index: handIndex, stake: 100);
}
func userAction() -> Void {
    
    let actions = game.getActions()

    let actionsString = {() -> String in
        var str = ""
        for (i, a) in actions.enumerated() {
            str += "\(i) \(a)  "
        }
        return str
    }()
    msg.push(SEP3)
    msg.push(actionsString)
    guard let actionInput = readLine() else {
        return
    }
    guard let n = Int(actionInput) else {
        return userAction()
    }
    guard n < actions.count else {
        return userAction()
    }

    for (i, a) in actions.enumerated() {
        if i == n {
            switch a {
            case BJAction.Double:
                msg.push("double ", 0, "")
                try! game.double()
                break
            case BJAction.Hit:
                msg.push("hit ", 0, "")
                try! game.hit()
                break
            case BJAction.Stand:
                try! game.stand()
                break
            case BJAction.Split:
                try! game.split()
                break
            default: break
            }
        }
    }
    return userAction()
}

func gameCycle() {
    let totalHands = 5
    var i = 0;
    repeat {
        bet(handIndex: i)
        i += 1
    } while i < totalHands

    try! game.deal();
    if let hand = game.model.activeHand {
        var bjHand = hand as BJHand
        printResults("You:", hand: &bjHand, wait: 400)
    }
    userAction()

    msg.push("GAME END")
    _ = readLine()
    game.model.clear()
    gameCycle();
}

gameCycle()

