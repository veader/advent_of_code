//
//  DayTwelve2021Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/12/21.
//

import XCTest

class DayTwelve2021Tests: XCTestCase {

    let sampleInput0 = """
        start-A
        start-b
        A-c
        A-b
        b-d
        A-end
        b-end
        """

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
        XCTAssertTrue(CaveMap.isSmall(cave: "start"))
        XCTAssertTrue(CaveMap.isSmall(cave: "end"))
        XCTAssertTrue(CaveMap.isSmall(cave: "dc"))
        XCTAssertFalse(CaveMap.isSmall(cave: "HN"))
        XCTAssertFalse(CaveMap.isSmall(cave: "GA"))
        XCTAssertFalse(CaveMap.isSmall(cave: "Ga"))
    }

    func testDoubleSmallCaveMethod() {
        let day = DayTwelve2021()
        let map = CaveMap(paths: day.parse(sampleInput1))
        XCTAssertFalse(map.containsDoubleSmallVisit(path: ["start", "end", "HN", "HN", "HN"]))
        XCTAssertFalse(map.containsDoubleSmallVisit(path: ["start", "end", "dc", "HN", "HN"]))
        XCTAssertFalse(map.containsDoubleSmallVisit(path: ["start", "end", "dc", "sa", "HN"]))
        XCTAssertFalse(map.containsDoubleSmallVisit(path: ["start", "end", "dc", "sa", "kj"]))
        XCTAssertTrue(map.containsDoubleSmallVisit(path: ["start", "end", "dc", "dc", "HN"]))
        XCTAssertTrue(map.containsDoubleSmallVisit(path: ["start", "end", "dc", "dc", "sa"]))
    }

    func testCavePathingNoDupes() {
        let day = DayTwelve2021()
        var map = CaveMap(paths: day.parse(sampleInput0))
        var paths = map.findAllPaths(debugPrint: false)
        XCTAssertEqual(10, paths.count)

        map = CaveMap(paths: day.parse(sampleInput1))
        paths = map.findAllPaths(debugPrint: false)
        XCTAssertEqual(19, paths.count)

        map = CaveMap(paths: day.parse(sampleInput2))
        paths = map.findAllPaths(debugPrint: false)
//        paths.sorted(by: { $0.count < $1.count }).forEach { path in
//            print(path.joined(separator: ","))
//        }
        XCTAssertEqual(226, paths.count)
    }

    func testCavePathingAllowingDupes() {
        let day = DayTwelve2021()
        var map = CaveMap(paths: day.parse(sampleInput0))
        var paths = map.findAllPaths(allowDoubleSmall:true, debugPrint: false)
        XCTAssertEqual(36, paths.count)

        map = CaveMap(paths: day.parse(sampleInput1))
        paths = map.findAllPaths(allowDoubleSmall:true, debugPrint: false)
//        paths.sorted(by: { $0.count < $1.count }).forEach { path in
//            print(path.joined(separator: ","))
//        }
        XCTAssertEqual(103, paths.count)

        map = CaveMap(paths: day.parse(sampleInput2))
        paths = map.findAllPaths(allowDoubleSmall:true, debugPrint: false)
        XCTAssertEqual(3509, paths.count)
    }
}
