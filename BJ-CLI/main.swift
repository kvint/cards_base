//
//  main.swift
//  BJ-CLI
//
//  Created by Александр Славщик on 24.02.2018.
//  Copyright © 2018 Александр Славщик. All rights reserved.
//

import Darwin

func bet(handIndex: Int) -> Void {
    
    print("Place your bet for hand \(handIndex) (100 by default)")
    
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
    
    guard let actions = game.model.activeHand?.getActions() else {
        return;
    }
    print("------------------------")
    usleep(400000)
    
    let actionsString = {() -> String in
        var str = ""
        for (i, a) in actions.enumerated() {
            str += "\(i) \(a)  "
        }
        return str
    }()
    print(actionsString)
    guard let actionInput = readLine() else {
        return
    }
    guard let n = Int(actionInput) else {
        return userAction()
    }
    guard n < actions.count else {
        return userAction()
    }

    let action = actions.enumerated()

//
//    switch action {
//    case BJAction.Double: return double()
//    case BJAction.Hit: return hit()
//    case BJAction.Stand: return stand()
//    case BJAction.Split: return split()
//    default: return userAction()
//    }
}
func double() -> Void {
    print("-> Double")
    print()
    game.double()
    userAction()
}
func hit() -> Void {
    print("-> Hit")
    print()
    game.hit()
    userAction()
}
func stand() -> Void {
    print("-> Stand")
    print()
    game.stand()
    userAction()
}
func split() -> Void {
    print("-> Split")
    print()
    game.split()
    userAction()
}
func deal() {
    game.deal()
    print()
    userAction()
}
func dumpResults() {
    print("------------------------")
    
    guard var userHand = game.model.activeHand else {
        return
    }
    print("hand: \(userHand.id)")
    
    print("Dealer")
    print(game.model.dealer.cards.first!)
    print("You:");
    printResults(hand: &userHand)
}
func printResults(hand: inout BJUserHand) {
    let scoreString = {() -> String in
        let score: (hard: Int, soft: Int?) = hand.getScore()
        guard let softScore = score.soft else {
            return "(\(score.hard))"
        }
        return "(\(score.hard)/\(softScore))"
    }()
    
    print("\(hand.cards) \(scoreString)");
}
func gameCycle() {
    var i = 0;
    repeat {
        bet(handIndex: i)
        i += 1
    } while i < 5
    
    deal();
    
    print()
    print()
    print("GAME END")
    print("--------")
    gameCycle();
}

class GameInterface: GameDelegate {
    func roundStarted() {
        print("-------------")
        print("Round started")
    }
    
    func roundEnded() {
        print("Round ended")
        print("-------------")
    }
    
    func didDealCard(_ card: Card, _ hand: inout BJHand) {
        print("\(hand.id) --> \(card)")
    }
    
    func didHandDone(_ hand: inout BJUserHand) {
        print("Hand \(hand.id) is done with:")
        printResults(hand: &hand)
    }
}

var game: Game = Game()
var gameInterface = GameInterface()
game.delegate = gameInterface

gameCycle()

