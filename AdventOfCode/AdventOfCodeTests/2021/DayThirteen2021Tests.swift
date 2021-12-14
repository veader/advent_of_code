//
//  DayThirteen2021Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/14/21.
//

import XCTest

class DayThirteen2021Tests: XCTestCase {

    let sampleInput = """
        6,10
        0,14
        9,10
        0,3
        10,4
        4,11
        6,0
        6,12
        4,1
        0,13
        10,12
        3,4
        3,0
        8,4
        1,10
        2,14
        8,10
        9,0

        fold along y=7
        fold along x=5
        """

    func testFoldInstructionParsing() {
        var inst = TransparentPaper.FoldInstruction.parse("something")
        XCTAssertNil(inst)

        inst = TransparentPaper.FoldInstruction.parse("fold x=1")
        XCTAssertNil(inst)

        inst = TransparentPaper.FoldInstruction.parse("fold along x=1")
        XCTAssertNotNil(inst)
        XCTAssertEqual(.horizontal(x: 1), inst)

        inst = TransparentPaper.FoldInstruction.parse("fold along x=245")
        XCTAssertNotNil(inst)
        XCTAssertEqual(.horizontal(x: 245), inst)

        inst = TransparentPaper.FoldInstruction.parse("fold along y=2")
        XCTAssertNotNil(inst)
        XCTAssertEqual(.vertical(y: 2), inst)

        inst = TransparentPaper.FoldInstruction.parse("fold along y=78")
        XCTAssertNotNil(inst)
        XCTAssertEqual(.vertical(y: 78), inst)
    }

    func testTransparentPaperParsing() {
        let paper = TransparentPaper.parse(input: sampleInput)
        XCTAssertNotNil(paper)
        XCTAssertEqual(18, paper.dots.count)
        XCTAssertEqual(2, paper.foldInsructions.count)
    }

    func testTransparentPaperFoldingSingle() {
        let paper: TransparentPaper! = TransparentPaper.parse(input: sampleInput)
        print(paper!.debugDescription)
        paper.fold(direction: .vertical(y: 7))
        print("=========================")
        print(paper!.debugDescription)

        XCTAssertEqual(17, paper.dots.count)
    }

    func testTransparentPaperFoldingDouble() {
        let paper: TransparentPaper! = TransparentPaper.parse(input: sampleInput)
        print("Initial:")
        print(paper!.debugDescription)

        print("\n Fold y=7:")
        paper.fold(direction: .vertical(y: 7))
        print(paper!.debugDescription)

        print("=========================")
        print("\n Fold x=5:")
        paper.fold(direction: .horizontal(x: 5))
        print(paper!.debugDescription)

        XCTAssertEqual(16, paper.dots.count)
    }

    func testTransparentPaperFoldingAll() {
        let paper: TransparentPaper! = TransparentPaper.parse(input: sampleInput)
        print("Initial:")
        print(paper!.debugDescription)

        paper.followInstructions()
        print("\nFinal:")
        print(paper!.debugDescription)

        XCTAssertEqual(16, paper.dots.count)
    }

}
