//
//  DaySixTests.swift
//  aoc2019Tests
//
//  Created by Shawn Veader on 12/6/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import XCTest

class DaySixTests: XCTestCase {

    let testInput = """
                    COM)B
                    B)C
                    C)D
                    D)E
                    E)F
                    B)G
                    G)H
                    D)I
                    E)J
                    J)K
                    K)L
                    """

    func testOrbitNodeBuilding() {
        let tree = OrbitNode(value: "COM")

        let nodeA = OrbitNode(value: "A")
        tree.add(node: nodeA)

        let nodeB = OrbitNode(value: "B")
        tree.add(node: nodeB)

        let nodeC = OrbitNode(value: "C")
        nodeA.add(node: nodeC)

        XCTAssertEqual(2, tree.children.count)
        XCTAssertEqual(1, nodeA.children.count)
        XCTAssertEqual(0, nodeB.children.count)
    }

    func testOrbitNodeSearch() {
        let tree = OrbitNode(value: "COM")

        let nodeA = OrbitNode(value: "A")
        tree.add(node: nodeA)

        let nodeB = OrbitNode(value: "B")
        tree.add(node: nodeB)

        let nodeC = OrbitNode(value: "C")
        nodeA.add(node: nodeC)

        XCTAssertEqual("C", tree.search(for: "C")?.value)
        XCTAssertEqual("B", tree.search(for: "B")?.value)
        XCTAssertEqual("COM", tree.search(for: "COM")?.value)
        XCTAssertNil(tree.search(for: "Z"))
    }

    func testOrbitNodeRoot() {
        let root = "COM"
        var tree: OrbitNode

        tree = OrbitNode(value: root)
        XCTAssertEqual(root, tree.root.value)

        let nodeA = OrbitNode(value: "A")
        tree.add(node: nodeA)
        XCTAssertEqual(root, nodeA.root.value)

        let nodeB = OrbitNode(value: "B")
        tree.add(node: nodeB)
        XCTAssertEqual(root, nodeB.root.value)

        let nodeC = OrbitNode(value: "C")
        nodeA.add(node: nodeC)
        XCTAssertEqual(root, nodeC.root.value)
    }

    func testOrbitNodeDepth() {
        let tree = OrbitNode(value: "COM")

        let nodeA = OrbitNode(value: "A")
        tree.add(node: nodeA)

        let nodeB = OrbitNode(value: "B")
        tree.add(node: nodeB)

        let nodeC = OrbitNode(value: "C")
        nodeA.add(node: nodeC)

        XCTAssertEqual(0, tree.depth)
        XCTAssertEqual(1, nodeA.depth)
        XCTAssertEqual(1, nodeB.depth)
        XCTAssertEqual(2, nodeC.depth)
    }

    func testOrbitGraphBuilding() {
        let day = DaySix()
        let descriptions = day.parse(testInput)
        let graph = day.buildOrbitGraph(with: descriptions)

        XCTAssertNotNil(graph)
        XCTAssertEqual("COM", graph?.root.value)
        XCTAssertEqual(1, graph?.search(for: "C")?.children.count)
        XCTAssertEqual(2, graph?.search(for: "D")?.children.count)
        XCTAssertEqual(2, graph?.search(for: "E")?.children.count)

        print(graph!)
        print(graph!.nestedOutput)
    }

    func testOrbitChecksum() {
        let day = DaySix()
        let descriptions = day.parse(testInput)
        let graph = day.buildOrbitGraph(with: descriptions)

        XCTAssertEqual(42, graph!.checksum)
    }

    func testPartOneAnswer() {
        let day = DaySix()
        let answer = day.run(part: 1) as! Int
        XCTAssertEqual(147223, answer)
    }

    func testPartTwoAnswer() {
        XCTAssert(true)
//        let day = DayFive()
//        let answer = day.run(part: 2) as! Int
//        XCTAssertEqual(3188550, answer)
    }
}
