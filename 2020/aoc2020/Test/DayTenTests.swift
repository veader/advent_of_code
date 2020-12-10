//
//  DayTenTests.swift
//  Test
//
//  Created by Shawn Veader on 12/10/20.
//

import XCTest

class DayTenTests: XCTestCase {

    func testFindingAdapterChain() {
        let array = AdapterArray(adapters: testSampleOne.split(separator: "\n").map(String.init).compactMap(Int.init))
        let answer = array.adapterChain()
        // print(answer)
        XCTAssertEqual(22, answer.joltage)
        XCTAssertEqual(11, answer.chain.count)
        XCTAssertEqual(7, answer.deltaOne)
        XCTAssertEqual(5, answer.deltaThree)

        let array2 = AdapterArray(adapters: testSampleTwo.split(separator: "\n").map(String.init).compactMap(Int.init))
        let answer2 = array2.adapterChain()
        print(answer2)
        XCTAssertEqual(52, answer2.joltage)
        XCTAssertEqual(31, answer2.chain.count)
        XCTAssertEqual(22, answer2.deltaOne)
        XCTAssertEqual(10, answer2.deltaThree)
    }

    func testFindingAdapterPossibilities() {
        let array = AdapterArray(adapters: testSampleOne.split(separator: "\n").map(String.init).compactMap(Int.init))
        let possibilities = array.possibleAdapterChains()
        print(possibilities.map({ "\($0)" }).joined(separator: "\n"))
        XCTAssertEqual(8, possibilities.count)

        let array2 = AdapterArray(adapters: testSampleTwo.split(separator: "\n").map(String.init).compactMap(Int.init))
        let possibilities2 = array2.possibleAdapterChains()
        XCTAssertEqual(19208, possibilities2.count)
    }


    let testSampleOne = """
        16
        10
        15
        5
        1
        11
        7
        19
        6
        12
        4
        """

    let testSampleTwo = """
        28
        33
        18
        42
        31
        14
        46
        20
        48
        47
        24
        23
        49
        45
        19
        38
        39
        11
        1
        32
        25
        35
        8
        17
        7
        9
        4
        2
        34
        10
        3
        """

}
