//
//  DayEighteen2021Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/19/21.
//

import XCTest

class DayEighteen2021Tests: XCTestCase {
    let sampleInput = """
        [[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]
        [[[5,[2,8]],4],[5,[[9,9],0]]]
        [6,[[[6,2],[5,6]],[[7,6],[4,7]]]]
        [[[6,[0,7]],[0,9]],[4,[9,[9,0]]]]
        [[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]]
        [[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]]
        [[[[5,4],[7,7]],8],[[8,3],8]]
        [[9,3],[[9,9],[6,[4,9]]]]
        [[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]
        [[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]]
        """

    func testSnailfishNumberParsingSimple() {
        var sn = SnailfishNumber.parse("nope")
        XCTAssertNil(sn)

        sn = SnailfishNumber.parse("[nope")
        XCTAssertNil(sn)

        sn = SnailfishNumber.parse("[1,nope")
        XCTAssertNil(sn)

        sn = SnailfishNumber.parse("[1,2")
        XCTAssertNil(sn)

        sn = SnailfishNumber.parse("[1,2]")
        XCTAssertNotNil(sn)
        XCTAssertEqual(.literal(number: 1), sn?.leftSide)
        XCTAssertEqual(.literal(number: 2), sn?.rightSide)
    }

    func testSnailfishNumberParsingNested() {
        var sn = SnailfishNumber.parse("[[nope,1]]")
        XCTAssertNil(sn)

        sn = SnailfishNumber.parse("[[1,2],3]")
        XCTAssertNotNil(sn)
        guard case .nested(number: let nestedNum) = sn!.leftSide else { XCTFail(); return }
        XCTAssertEqual(.literal(number: 1), nestedNum.leftSide)
        XCTAssertEqual(.literal(number: 2), nestedNum.rightSide)
        XCTAssertEqual(.literal(number: 3), sn?.rightSide)

        sn = SnailfishNumber.parse("[[1,2],[[3,4],5]]")
        XCTAssertNotNil(sn)
        guard
            case .nested(number: let nestedNum0) = sn!.rightSide,
            case .nested = nestedNum0.leftSide
        else { XCTFail(); return }

        sn = SnailfishNumber.parse("[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]")
        XCTAssertNotNil(sn)
    }

    func testSnailfishNumberDepth() {
        let sn = SnailfishNumber.parse("[[[[[9,8],1],2],3],4]")
        XCTAssertNotNil(sn)
        guard
            case .nested(let depth1) = sn!.leftSide,
            case .nested(let depth2) = depth1.leftSide,
            case .nested(let depth3) = depth2.leftSide,
            case .nested(let depth4) = depth3.leftSide
        else { XCTFail(); return }
        XCTAssertEqual("[9,8]", depth4.description)
//        XCTAssertEqual(4, depth4.depth)
    }

    func testSnailfishNumberExplode() {
        var sn = SnailfishNumber.parse("[[[[[9,8],1],2],3],4]")
        sn!.reduce()
        XCTAssertEqual("[[[[0,9],2],3],4]", sn!.description)

        sn = SnailfishNumber.parse("[7,[6,[5,[4,[3,2]]]]]")
        sn!.reduce()
        XCTAssertEqual("[7,[6,[5,[7,0]]]]", sn!.description)

        sn = SnailfishNumber.parse("[[6,[5,[4,[3,2]]]],1]")
        sn!.reduce()
        XCTAssertEqual("[[6,[5,[7,0]]],3]", sn!.description)

        sn = SnailfishNumber.parse("[[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]]")
        sn!.reduce()
        XCTAssertEqual("[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]", sn!.description)

        sn = SnailfishNumber.parse("[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]")
        sn!.reduce()
        XCTAssertEqual("[[3,[2,[8,0]]],[9,[5,[7,0]]]]", sn!.description)
    }

    func testSnailfishNumberSplit() {
        var sn = SnailfishNumber.parse("[10,4]")
        sn!.reduce()
        XCTAssertEqual("[[5,5],4]", sn!.description)

        sn = SnailfishNumber.parse("[11,4]")
        sn!.reduce()
        XCTAssertEqual("[[5,6],4]", sn!.description)

        sn = SnailfishNumber.parse("[15,14]")
        sn!.reduce(passes: 1)
        XCTAssertEqual("[[7,8],14]", sn!.description)
        sn!.reduce(passes: 1)
        XCTAssertEqual("[[7,8],[7,7]]", sn!.description)

        sn = SnailfishNumber.parse("[2,14]")
        sn!.reduce()
        XCTAssertEqual("[2,[7,7]]", sn!.description)
    }

    func testSnailfishNumberReduce() {
        let sn = SnailfishNumber.parse("[[[[[4,3],4],4],[7,[[8,4],9]]],[1,1]]")
        sn!.reduce()
        XCTAssertEqual("[[[[0,7],4],[[7,8],[6,0]]],[8,1]]", sn!.description)

        let sn1 = SnailfishNumber.parse("[[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]]")
        let sn2 = SnailfishNumber.parse("[7,[[[3,7],[4,3]],[[6,3],[8,8]]]]")
        let snAdded0 = SnailfishNumber.add(sn1!, sn2!)
        snAdded0.reduce()
        XCTAssertEqual("[[[[4,0],[5,4]],[[7,7],[6,0]]],[[8,[7,7]],[[7,9],[5,0]]]]", snAdded0.description)

        let sn3 = SnailfishNumber.parse("[[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]")
        let sn4 = SnailfishNumber.parse("[[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]")
        let snAdded1 = SnailfishNumber.add(sn3!, sn4!)
        snAdded1.reduce()
        XCTAssertEqual("[[[[7,8],[6,6]],[[6,0],[7,7]]],[[[7,8],[8,8]],[[7,9],[0,6]]]]", snAdded1.description)
        XCTAssertEqual(3993, snAdded1.magnitude())
    }

    func testSnailfishNumberMagnitude() {
        var sn = SnailfishNumber.parse("[9,1]")
        XCTAssertEqual(29, sn!.magnitude())

        sn = SnailfishNumber.parse("[1,9]")
        XCTAssertEqual(21, sn!.magnitude())

        sn = SnailfishNumber.parse("[[9,1],[1,9]]")
        XCTAssertEqual(129, sn!.magnitude())

        sn = SnailfishNumber.parse("[[[[0,7],4],[[7,8],[6,0]]],[8,1]]")
        XCTAssertEqual(1384, sn!.magnitude())

        sn = SnailfishNumber.parse("[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]")
        XCTAssertEqual(3488, sn!.magnitude())
    }

    func testDayEighteenParsingAndAdding() {
        let input0 = """
            [1,1]
            [2,2]
            [3,3]
            [4,4]
            """
        let day = DayEighteen2021()
        var numbers = day.parse(input0)
        var sn = day.add(numbers: numbers)
        XCTAssertEqual("[[[[1,1],[2,2]],[3,3]],[4,4]]", sn.description)

        let input1 = """
            [[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]]
            [7,[[[3,7],[4,3]],[[6,3],[8,8]]]]
            [[2,[[0,8],[3,4]]],[[[6,7],1],[7,[1,6]]]]
            [[[[2,4],7],[6,[0,5]]],[[[6,8],[2,8]],[[2,1],[4,5]]]]
            [7,[5,[[3,8],[1,4]]]]
            [[2,[2,2]],[8,[8,1]]]
            [2,9]
            [1,[[[9,3],9],[[9,0],[0,7]]]]
            [[[5,[7,4]],7],1]
            [[[[4,2],2],6],[8,7]]
            """
        numbers = day.parse(input1)
        sn = day.add(numbers: numbers)
        XCTAssertEqual("[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]", sn.description)
    }

    func testDayEighteenPart1() {
        let day = DayEighteen2021()
        let numbers = day.parse(sampleInput)
        let sn = day.add(numbers: numbers)
        XCTAssertEqual("[[[[6,6],[7,6]],[[7,7],[7,0]]],[[[7,7],[7,7]],[[7,8],[9,9]]]]", sn.description)
        XCTAssertEqual(4140, sn.magnitude())
    }

    func testDayEighteenPart2() {
        let day = DayEighteen2021()
        let largest = day.partTwo(input: sampleInput) as? Int
        XCTAssertEqual(3993, largest)
    }
}
