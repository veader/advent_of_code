//
//  ArrayTests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/9/24.
//

import Testing

struct ArrayTests {

    @Test func testPairCombinations() async throws {
        let p1 = [1].pairCombinations()
        #expect(p1.isEmpty)

        let p2 = [1,2].pairCombinations()
        #expect(p2.count == 1)

        let p3 = [1,2,3].pairCombinations()
        #expect(p3.count == 3)

        let p4 = [1,2,3,4].pairCombinations()
        #expect(p4.count == 6)
    }

}
