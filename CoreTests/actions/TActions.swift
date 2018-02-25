//
// Created by Александр Славщик on 25.02.2018.
// Copyright (c) 2018 Александр Славщик. All rights reserved.
//

import Foundation

import XCTest
@testable import Core

class TActions: XCTestCase {

    func testBasic() {
        self.checkActions("Basic",
                [Rank.c5, Rank.c2],
                shouldBe: [BJAction.Double, BJAction.Hit, BJAction.Stand])
    }
    func testSplit() {
        self.checkActions("Split",
                [Rank.Jack, Rank.Jack],
                shouldBe: [BJAction.Double, BJAction.Hit, BJAction.Stand, BJAction.Split])
    }
    func testBlackjack() {
        self.checkActions("Blackjack",
                [Rank.Jack, Rank.Ace],
                shouldBe: [])
    }
    func testStandHit() {
        self.checkActions("Stand/Hit",
                [Rank.c2, Rank.c4, Rank.Ace],
                shouldBe: [BJAction.Hit, BJAction.Stand])
    }
    func testBust() {
        self.checkActions("Bust",
                [Rank.Jack, Rank.Jack, Rank.Jack],
                shouldBe: [])
    }
    func checkActions(_ msg: String, _ ranks: [Rank], shouldBe: Set<BJAction>) -> Void {
        print("Check actions \(msg)")
        let hand = Hand()
        for rank in ranks {
            hand.cards.append(Card(rank))
        }
        let actions = hand.getActions()
        XCTAssert(actions == shouldBe, "failed \(msg)")
    }
}