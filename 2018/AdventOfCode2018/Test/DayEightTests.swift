//
//  DayEightTests.swift
//  Test
//
//  Created by Shawn Veader on 12/8/18.
//  Copyright © 2018 Shawn Veader. All rights reserved.
//

import XCTest

class DayEightTests: XCTestCase {

    let input = "2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2"

    func testTimeStreamHeader() {
        let day = DayEight()
        var stream = DayEight.TreeStream(stream: day.parse(input: input))
        let header = stream.pullHeader()
        XCTAssertEqual(2, header?.children)
        XCTAssertEqual(3, header?.metadata)
        XCTAssertEqual(14, stream.stream.count)
    }

    func testTimeStreamTrailingMeta() {
        let day = DayEight()
        var stream = DayEight.TreeStream(stream: day.parse(input: input))
        let metadata = stream.pullTrailingMetadata(length: 3)
        XCTAssertEqual(3, metadata?.count)
        XCTAssertEqual([1, 1, 2], metadata)
        XCTAssertEqual(13, stream.stream.count)
    }

    func testTimeStreamMeta() {
        let day = DayEight()
        var stream = DayEight.TreeStream(stream: day.parse(input: input))
        _ = stream.pullHeader()
        let metadata = stream.pullMetadata(length: 4)
        XCTAssertEqual(4, metadata?.count)
        XCTAssertEqual([0, 3, 10, 11], metadata)
        XCTAssertEqual(10, stream.stream.count)
    }

    func testTreeConstruction() {
        let day = DayEight()
        let stream = DayEight.TreeStream(stream: day.parse(input: input))
        let tree = day.constructTree(stream: stream)
        XCTAssertNotNil(tree)

        let root = tree!.rootNode!
        XCTAssertEqual(2, root.nodes.count)
        XCTAssertEqual([1, 1, 2], root.metadata)

        let firstChild = root.nodes.first!
        XCTAssertEqual(0, firstChild.nodes.count)

        let secondChild = root.nodes.last!
        XCTAssertEqual(1, secondChild.nodes.count)
    }

    func testMetadataSum() {
        let day = DayEight()
        let stream = DayEight.TreeStream(stream: day.parse(input: input))
        let tree = day.constructTree(stream: stream)
        let root = tree!.rootNode!
        XCTAssertEqual(138, day.metadataSum(for: root))
    }

    func testNodeValueSum() {
        let day = DayEight()
        let stream = DayEight.TreeStream(stream: day.parse(input: input))
        let tree = day.constructTree(stream: stream)
        let root = tree!.rootNode!
        XCTAssertEqual(66, day.sumNodeValue(for: root))
    }

    func testNodeConsructionNoChildren() {
        let day = DayEight()
        let stream = DayEight.TreeStream(stream: [0, 3, 10, 11, 12])
        let response = day.constructNodes(stream: stream)
        XCTAssertNotNil(response)
        XCTAssertEqual(true, response?.remainder.isEmpty)

        guard let node = response?.node else {
            XCTFail("Failed to get child node")
            return
        }
        XCTAssertEqual(0, node.header.children)
        XCTAssertEqual(3, node.header.metadata)
        XCTAssertEqual([10, 11, 12], node.metadata)
        XCTAssertEqual(0, node.nodes.count)
    }

    func testNodeConstructionWithChildren() {
        let day = DayEight()
        let stream = DayEight.TreeStream(stream: [1, 1, 0, 1, 99, 2])
        let response = day.constructNodes(stream: stream)
        XCTAssertNotNil(response)
        XCTAssertEqual(true, response?.remainder.isEmpty)

        guard let node = response?.node else {
            XCTFail("Failed to get child node")
            return
        }
        XCTAssertEqual(1, node.header.children)
        XCTAssertEqual(1, node.header.metadata)
        XCTAssertEqual([2], node.metadata)
        XCTAssertEqual(1, node.nodes.count)

        guard let childNode = node.nodes.first else {
            XCTFail("Failed to get child's child node")
            return
        }
        XCTAssertEqual(0, childNode.header.children)
        XCTAssertEqual(1, childNode.header.metadata)
        XCTAssertEqual([99], childNode.metadata)
    }
}
