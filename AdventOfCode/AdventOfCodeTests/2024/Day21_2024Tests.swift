//
//  Day21_2024Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 1/3/25.
//

import Testing

struct Day21_2024Tests {

    @Test func testNumPadToDPadTranslateion() async throws {
        let dPad = DPad()

        var moves = dPad.translateNumToDPad("02")
        #expect(moves == [.left, .up])

        moves = dPad.translateNumToDPad("024")
        #expect(moves == [.left, .up, .left, .up])

        moves = dPad.translateNumToDPad("30A")
        #expect(moves == [.up, .left, .down, .right])

        moves = dPad.translateNumToDPad("81A")
        #expect(moves == [.up, .up, .up, .left, .left, .down, .down, .right, .right, .down])
    }

}
