//
//  Day15_2023Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/15/23.
//

import XCTest

final class Day15_2023Tests: XCTestCase {

    let sampleInput = """
        rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7
        """

    func testSimpleHashMethod() throws {
        let answer = "HASH".simpleHash
        XCTAssertEqual(answer, 52)
    }

    func testPart1() throws {
        let answer = Day15_2023().run(part: 1, sampleInput)
        XCTAssertEqual(1320, answer as? Int)
    }

    func testPart1Answer() throws {
        let answer = Day15_2023().run(part: 1)
        XCTAssertEqual(507769, answer as? Int)
    }

    func testLensHashMapParsing() throws {
        let hm = LensHashMap(sampleInput)
        XCTAssertEqual(11, hm.operations.count)
        XCTAssertEqual(hm.operations.first, .insert(lens: "rn", focal: 1))
        XCTAssertEqual(hm.operations[1], .remove(lens: "cm"))
    }

    func testLensHashMapProcess() throws {
        let hm = LensHashMap(sampleInput)
        XCTAssertEqual(0, hm.hashMap.count)
        hm.process()
        XCTAssertEqual(3, hm.hashMap.count)
        XCTAssertEqual([0,1,3], hm.hashMap.keys.sorted())
//        for key in hashmap.hashMap.keys.sorted() {
//            print("[\(key): \(hashmap.hashMap[key])]")
//        }
    }

    func testLensHashMapFocalCalculation() throws {
        let hm = LensHashMap(sampleInput)
        hm.process()
        let answer = hm.calculateFocalPower()
        XCTAssertEqual(145, answer)
    }

    func testPart2() throws {
        let answer = Day15_2023().run(part: 2, sampleInput)
        XCTAssertEqual(145, answer as? Int)
    }

    func testPart2Answer() throws {
        let answer = Day15_2023().run(part: 2)
        XCTAssertEqual(269747, answer as? Int)
    }
}
