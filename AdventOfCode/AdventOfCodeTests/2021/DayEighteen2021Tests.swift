//
//  DayEighteen2021Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/19/21.
//

import XCTest

class DayEighteen2021Tests: XCTestCase {

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
//        XCTAssertEqual(1, nestedNum.depth)
        XCTAssertEqual(.literal(number: 3), sn?.rightSide)

        sn = SnailfishNumber.parse("[[1,2],[[3,4],5]]")
        XCTAssertNotNil(sn)
        guard
            case .nested(let nestedNum0) = sn!.rightSide,
            case .nested(let nestedNum1) = nestedNum0.leftSide
        else { XCTFail(); return }
//        XCTAssertEqual(2, nestedNum1.depth)

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
}
