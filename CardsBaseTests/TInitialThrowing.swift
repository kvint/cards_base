//
// Created by Александр Славщик on 17.03.2018.
// Copyright (c) 2018 Александр Славщик. All rights reserved.
//


import XCTest

class TInitialThrowing: TBJGameCase {

    func testDeal() {
        XCTAssertThrowsError(try self.game.deal(), "No stake deal case") { (error) -> Void in
            XCTAssertEqual(error as? BJError, BJError.betError)
        }
    }
    func testDouble() {
        XCTAssertThrowsError(try self.game.double(), "Double without hands") { (error) -> Void in
            XCTAssertEqual(error as? BJError, BJError.handError)
        }
    }
    func testHit() {
        XCTAssertThrowsError(try self.game.hit(), "Hit without hands") { (error) -> Void in
            XCTAssertEqual(error as? BJError, BJError.handError)
        }
    }
    func testStand() {
        XCTAssertThrowsError(try self.game.stand(), "Stand without hands") { (error) -> Void in
            XCTAssertEqual(error as? BJError, BJError.handError)
        }
    }
    func testSplit() {
        XCTAssertThrowsError(try self.game.split(), "Split without hands") { (error) -> Void in
            XCTAssertEqual(error as? BJError, BJError.handError)
        }
    }
    func testInsurance() {
        XCTAssertThrowsError(try self.game.insurance(), "Insurance without hands") { (error) -> Void in
            XCTAssertEqual(error as? BJError, BJError.handError)
        }
    }
}
