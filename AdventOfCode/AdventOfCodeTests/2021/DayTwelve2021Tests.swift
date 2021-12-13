//
//  DayTwelve2021Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/12/21.
//

import XCTest

class DayTwelve2021Tests: XCTestCase {

    let sampleInput1 = """
        dc-end
        HN-start
        start-kj
        dc-start
        dc-HN
        LN-dc
        HN-end
        kj-sa
        kj-HN
        kj-dc
        """

    let sampleInput2 = """
        fs-end
        he-DX
        fs-he
        start-DX
        pj-DX
        end-zg
        zg-sl
        zg-pj
        pj-he
        RW-he
        fs-DX
        pj-RW
        zg-RW
        start-pj
        he-WI
        zg-he
        pj-fs
        start-RW
        """

    func testCavePathParsing() {
        let day = DayTwelve2021()
        let paths = day.parse(sampleInput1)
        XCTAssertEqual(10, paths.count)
    }

    func testCaveMap() {
        let day = DayTwelve2021()
        let map = CaveMap(paths: day.parse(sampleInput1))
        XCTAssertEqual(10, map.paths.count)
        XCTAssertEqual(7, map.endPoints.count)

        var possibilities = map.paths(from: "start")
//        print("From 'start': \(possibilities)")
        XCTAssertEqual(3, possibilities.count)

        possibilities = map.paths(from: "end")
//        print("From 'end': \(possibilities)")
        XCTAssertEqual(2, possibilities.count)
    }

    func testCaveSizeMethod() {
        let map = CaveMap(paths: [])
        XCTAssertTrue(map.isSmall(cave: "start"))
        XCTAssertTrue(map.isSmall(cave: "end"))
        XCTAssertTrue(map.isSmall(cave: "dc"))
        XCTAssertFalse(map.isSmall(cave: "HN"))
        XCTAssertFalse(map.isSmall(cave: "GA"))
    }

    func testCavePathing() {
        let day = DayTwelve2021()
        var map = CaveMap(paths: day.parse(sampleInput1))
        var paths = map.findAllPaths(debugPrint: false)
//        paths.sorted(by: { $0.count < $1.count }).forEach { path in
//            print(path.joined(separator: ","))
//        }
        XCTAssertEqual(19, paths.count)

        map = CaveMap(paths: day.parse(sampleInput2))
        paths = map.findAllPaths(debugPrint: false)
//        paths.sorted(by: { $0.count < $1.count }).forEach { path in
//            print(path.joined(separator: ","))
//        }
        XCTAssertEqual(226, paths.count)
    }
}
