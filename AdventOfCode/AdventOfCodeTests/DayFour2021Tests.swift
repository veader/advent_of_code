//
//  DayFour2021Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/4/21.
//

import XCTest

class DayFour2021Tests: XCTestCase {
    let sampleBoardInput = """
    22 13 17 11  0
     8  2 23  4 24
    21  9 14 16  7
     6 10  3 18  5
     1 12 20 15 19
    """

    let sampleGameInput = """
    7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

    22 13 17 11  0
     8  2 23  4 24
    21  9 14 16  7
     6 10  3 18  5
     1 12 20 15 19

     3 15  0  2 22
     9 18 13 17  5
    19  8  7 25 23
    20 11 10 24  4
    14 21 16 12  6

    14 21 17 24  4
    10 16 15  9 19
    18  8 23 26 20
    22 11 13  6  5
     2  0 12  3  7
    """

    func testBingoBoardParsing() {
        let lines = sampleBoardInput.split(separator: "\n").map(String.init)
        let board = BingoBoard.parse(lines)
        XCTAssertNotNil(board)
        XCTAssertEqual(5, board!.board.count)
        var row = board!.board.first
        XCTAssertEqual(22, row?.first)
        row = board!.board.last
        XCTAssertEqual(19, row?.last)

//        print(board!)
    }

    func testBoardWinningRow() {
        let draws = [22, 13, 17, 11, 0]
        let lines = sampleBoardInput.split(separator: "\n").map(String.init)
        let board: BingoBoard! = BingoBoard.parse(lines)
        XCTAssertFalse(board.hasBingo())
        draws.forEach { board.mark($0) }
        XCTAssertTrue(board.hasBingo())
    }

    func testBoardWinningColumn() {
        let draws = [22, 8, 21, 6, 1]
        let lines = sampleBoardInput.split(separator: "\n").map(String.init)
        let board: BingoBoard! = BingoBoard.parse(lines)
        XCTAssertFalse(board.hasBingo())
        draws.forEach { board.mark($0) }
        XCTAssertTrue(board.hasBingo())
    }

    func testBoardSum() {
        let draws = [22, 13, 17, 11, 0]
        let lines = sampleBoardInput.split(separator: "\n").map(String.init)
        let board: BingoBoard! = BingoBoard.parse(lines)
        draws.forEach { board.mark($0) }
        XCTAssertEqual(237, board.sum())
    }

    func testBingoGameParsing() {
        let game = BingoGame.parse(sampleGameInput)
        XCTAssertEqual(27, game.draws.count)
        XCTAssertEqual(3, game.boards.count)
    }

    func testGamePlay() {
        let game = BingoGame.parse(sampleGameInput)
        game.play()
        XCTAssertEqual(4512, game.finalScore)
    }
}
