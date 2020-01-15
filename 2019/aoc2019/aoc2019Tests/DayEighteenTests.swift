//
//  DayEighteenTests.swift
//  aoc2019Tests
//
//  Created by Shawn Veader on 12/18/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import XCTest

class DayEighteenTests: XCTestCase {

    func testVaultParsing() {
        var vault: Vault

        vault = Vault(input: testInput1)
        XCTAssertEqual(2, vault.keys.count)
        XCTAssertEqual(1, vault.doors.count)
        XCTAssertEqual(Coordinate(x: 5, y: 1), vault.startLocation)

        vault = Vault(input: testInput2)
        XCTAssertEqual(6, vault.keys.count)
        XCTAssertEqual(5, vault.doors.count)
        XCTAssertEqual(Coordinate(x: 15, y: 1), vault.startLocation)
    }

    func testVaultSearch() {
        var vault: Vault
        var result: Vault.SearchStep?

        vault = Vault(input: testInput1)
        result = vault.shortestPathToAllKeys()
        XCTAssertEqual(8, result?.stepCount)

        vault = Vault(input: testInput2)
        result = vault.shortestPathToAllKeys()
        XCTAssertEqual(86, result?.stepCount)

        vault = Vault(input: testInput3)
        result = vault.shortestPathToAllKeys()
        XCTAssertEqual(132, result?.stepCount)

//        // this one works but takes a bit too long...
//        vault = Vault(input: testInput4)
//        result = vault.shortestPathToAllKeys()
//        XCTAssertEqual(136, result?.stepCount)

        vault = Vault(input: testInput5)
        result = vault.shortestPathToAllKeys()
        XCTAssertEqual(81, result?.stepCount)
    }

    let testInput1 = """
                     #########
                     #b.A.@.a#
                     #########
                     """

    let testInput2 = """
                     ########################
                     #f.D.E.e.C.b.A.@.a.B.c.#
                     ######################.#
                     #d.....................#
                     ########################
                     """

    let testInput3 = """
                     ########################
                     #...............b.C.D.f#
                     #.######################
                     #.....@.a.B.c.d.A.e.F.g#
                     ########################
                     """

    let testInput4 = """
                     #################
                     #i.G..c...e..H.p#
                     ########.########
                     #j.A..b...f..D.o#
                     ########@########
                     #k.E..a...g..B.n#
                     ########.########
                     #l.F..d...h..C.m#
                     #################
                     """

    let testInput5 = """
                     ########################
                     #@..............ac.GI.b#
                     ###d#e#f################
                     ###A#B#C################
                     ###g#h#i################
                     ########################
                     """

}
