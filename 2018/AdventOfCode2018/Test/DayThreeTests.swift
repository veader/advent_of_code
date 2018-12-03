//
//  DayThreeTests.swift
//  Test
//
//  Created by Shawn Veader on 12/3/18.
//  Copyright © 2018 Shawn Veader. All rights reserved.
//

import XCTest

class DayThreeTests: XCTestCase {

    func testSuitCloth() {
        let empty = """
                    ....
                    ....
                    ....

                    """
        XCTAssertEqual(empty, DayThree.SuitCloth(width: 4, height: 3).debugDescription)

        let marked = """
                     ....
                     .X..
                     ....

                     """
        var cloth = DayThree.SuitCloth(width: 4, height: 3)
        cloth[DayThree.Coordinate(x: 1, y: 1)] = "X"
        XCTAssertEqual(marked, cloth.debugDescription)
    }

    func testSuitClothClaim() {
        let claim = DayThree.SuitClothClaim(input: "#123 @ 3,2: 5x4")
        XCTAssertEqual(123, claim?.claimID)
        XCTAssertEqual(DayThree.Coordinate(x: 3, y: 2), claim?.coordinate)
        XCTAssertEqual(5, claim?.width)
        XCTAssertEqual(4, claim?.height)

        let otherClaim = DayThree.SuitClothClaim(input: "#2 @ 3,1: 4x4")
        XCTAssertEqual(2, otherClaim?.claimID)
        XCTAssertEqual(DayThree.Coordinate(x: 3, y: 1), otherClaim?.coordinate)
        XCTAssertEqual(4, otherClaim?.width)
        XCTAssertEqual(4, otherClaim?.height)
    }

    func testSuitClothClaiming() {
        let marked = """
                     .oo.
                     .oo.
                     ....

                     """
        var cloth = DayThree.SuitCloth(width: 4, height: 3)
        if let claim = DayThree.SuitClothClaim(input: "#1 @ 1,0: 2x2") {
            cloth.markClaim(to: claim)
        }
        XCTAssertEqual(marked, cloth.debugDescription)

        let marked2 = """
                      .o..
                      .o..
                      ....

                      """
        var cloth2 = DayThree.SuitCloth(width: 4, height: 3)
        if let claim2 = DayThree.SuitClothClaim(input: "#1 @ 1,0: 1x2") {
            cloth2.markClaim(to: claim2)
        }
        XCTAssertEqual(marked2, cloth2.debugDescription)

        let marked3 = """
                      .oo.
                      ....
                      ....

                      """
        var cloth3 = DayThree.SuitCloth(width: 4, height: 3)
        if let claim3 = DayThree.SuitClothClaim(input: "#1 @ 1,0: 2x1") {
            cloth3.markClaim(to: claim3)
        }
        XCTAssertEqual(marked3, cloth3.debugDescription)

        let marked4 = """
                      ....
                      .oo.
                      .oo.

                      """
        var cloth4 = DayThree.SuitCloth(width: 4, height: 3)
        if let claim4 = DayThree.SuitClothClaim(input: "#1 @ 1,1: 2x2") {
            cloth4.markClaim(to: claim4)
        }
        XCTAssertEqual(marked4, cloth4.debugDescription)
    }

    func testPartOne() {
        let input = """
                    #1 @ 1,3: 4x4
                    #2 @ 3,1: 4x4
                    #3 @ 5,5: 2x2
                    """

        let day = DayThree()
        XCTAssertEqual(4, day.run(input, 1) as? Int)
    }
}
