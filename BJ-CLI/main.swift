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

func printResults(_ prefix: String, hand: inout BJHand, wait: Int? = nil) {
    let scoreString = {() -> String in
        let score: (hard: Int, soft: Int?) = hand.getScore()
        guard let softScore = score.soft else {
            return "\(score.hard)"
        }
        return "\(score.hard)/\(softScore)"
    }()

    msg.push("\(prefix) \(hand.cards) (\(scoreString))", wait);
}

class GameInterface: GameDelegate {

    func roundStarted() {
        msg.push("------------------------------------------------------------------------------")
        msg.push("Dealer cards: \(game.model.dealer.cards.first!)")
        msg.push(nil, 250)
    }

    func roundEnded() {
        msg.push("Round ended ------------------------------------------------------------------------------")
        msg.push()

        var dealer = game.model.dealer as BJHand
        printResults("Dealer", hand: &dealer)

        for hand in game.model.hands {
            guard let hnd = hand else {
                continue
            }
            var simpleHand = hnd as BJHand
            printResults("Hand \(hnd.id)", hand: &simpleHand)
        }
    }

    func didDealCard(_ card: Card, _ hand: inout BJHand) {
        msg.push("\(hand.id) --> \(card)", 100)
    }

    func didHandDone(_ hand: inout BJUserHand) {
        var simpleHand = hand as BJHand
        printResults("Hand \(hand.id) is done with:", hand: &simpleHand, wait: 800)
        msg.push("", 300)
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
    game.bet(index: handIndex, stake: 100);
}
func userAction() -> Void {

    dumpResults()
    guard game.live else {
        return
    }

    let actions = game.getActions()

    let actionsString = {() -> String in
        var str = ""
        for (i, a) in actions.enumerated() {
            str += "\(i) \(a)  "
        }
        return str
    }()
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
                game.double()
                return userAction()
            case BJAction.Hit:
                game.hit()
                return userAction()
            case BJAction.Stand:
                game.stand()
                return userAction()
            case BJAction.Split:
                game.split()
                return userAction()
            default: return userAction()
            }
        }
    }
}

func dumpResults() {
    guard var userHand = game.model.activeHand as BJHand! else {
        return
    }
    printResults("You:", hand: &userHand, wait: 400)
}

func gameCycle() {
    let totalHands = 5
    var i = 0;
    repeat {
        bet(handIndex: i)
        i += 1
    } while i < totalHands
    
    game.deal();
    userAction()

    msg.push("GAME END")
    _ = readLine()
    game.model.clear()
    gameCycle();
}

gameCycle()

