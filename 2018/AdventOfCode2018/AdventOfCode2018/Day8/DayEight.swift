//
//  DayEight.swift
//  AdventOfCode2018
//
//  Created by Shawn Veader on 12/8/18.
//  Copyright © 2018 Shawn Veader. All rights reserved.
//

import Foundation

struct DayEight: AdventDay {
    var dayNumber: Int = 8

    struct LicenseTree {
        struct Header {
            let children: Int
            let metadata: Int

            init?(data: [Int]) {
                guard data.count == 2 else { return nil }
                children = data[0]
                metadata = data[1]
            }
        }

        struct Node {
            let header: Header
            let metadata: [Int]
            var nodes: [Node]
        }

        var rootNode: Node?
    }

    struct TreeStream {
        var stream: [Int]

        var isEmpty: Bool { return stream.isEmpty }

        /// Remove the header (first 2 elements) from the stream
        ///     and return them.
        /// - note: Stream is mutated as a result.
        mutating func pullHeader() -> LicenseTree.Header? {
            guard stream.count >= 2 else { return nil }
            let headerData = Array(stream.prefix(2))
            stream = Array(stream.dropFirst(2))
            return LicenseTree.Header(data: headerData)
        }

        /// Remove a metadata section (first X elements) from the
        ///     stream and return them.
        /// - note: Stream is mutated as a result.
        mutating func pullMetadata(length: Int) -> [Int]? {
            guard stream.count >= length else { return nil }
            let metadata = Array(stream.prefix(length))
            stream = Array(stream.dropFirst(length))
            return metadata
        }

        /// Remove a trailing metadata section (last X elements)
        ///     from the stream and return them.
        /// - note: Stream is mutated as a result.
        mutating func pullTrailingMetadata(length: Int) -> [Int]? {
            guard stream.count >= length else { return nil }
            let metadata = Array(stream.suffix(length))
            stream = Array(stream.dropLast(length))
            return metadata
        }
    }

    @discardableResult func run(_ input: String? = nil, _ part: Int? = 1) -> Any {
        guard let input = input ?? defaultInput else {
            print("Day \(dayNumber): NO INPUT")
            exit(10)
        }

        let rawStream = parse(input: input)
        let stream = TreeStream(stream: rawStream)
        guard let tree = constructTree(stream: stream) else {
            print("Problem constructing tring")
            exit(11)
        }

        if part == 1 {
            let answer = partOne(tree: tree)
            print("Day \(dayNumber) Part \(part!): Final Answer \(answer)")
            return answer
        } else {
            let answer = partTwo(tree: tree)
            print("Day \(dayNumber) Part \(part!): Final Answer \(answer)")
            return answer
        }
    }

    func partOne(tree: LicenseTree) -> Int {
        guard let rootNode = tree.rootNode else { return Int.min }
        return metadataSum(for: rootNode)
    }

    func partTwo(tree: LicenseTree) -> Int {
        guard let rootNode = tree.rootNode else { return Int.min }
        return sumNodeValue(for: rootNode)
    }


    func metadataSum(for node: LicenseTree.Node) -> Int {
        return node.metadata.reduce(0, +) +
                node.nodes.reduce(0, { result, childNode in
                    return result + metadataSum(for: childNode)
                })
    }

    func sumNodeValue(for node: LicenseTree.Node) -> Int {
        if node.header.children == 0 {
            return node.metadata.reduce(0, +)
        } else {
            return node.metadata.reduce(0) { result, metadata in
                guard metadata > 0 else { return result }

                let idx = metadata - 1
                if node.nodes.indices.contains(idx) {
                    let childNode = node.nodes[idx]
                    return result + sumNodeValue(for: childNode)
                } else {
                    return result
                }
            }
        }
    }

    func parse(input: String) -> [Int] {
        return input.split(separator: " ")
                    .map(String.init)
                    .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                    .compactMap { Int($0) }
    }

    func constructTree(stream: TreeStream) -> LicenseTree? {
        guard !stream.isEmpty else { return nil }

        guard
            let response = constructNodes(stream: stream),
            let rootNode = response.node
            else {
                print("PROBLEM WITH ROOT NODE?!?")
                return nil
            }

        return LicenseTree(rootNode: rootNode)
    }

    struct ConstructNodesResponse {
        let node: LicenseTree.Node?
        let remainder: TreeStream
    }

    func constructNodes(stream theStream: TreeStream) -> ConstructNodesResponse? {
        guard !theStream.isEmpty else { return nil }

        var stream = theStream
        guard let header = stream.pullHeader() else {
            print("PROBLEM PULLING HEADER: \(stream)")
            return nil
        }
        assert(header.metadata > 0)

        if header.children == 0 {
            let metadata = stream.pullMetadata(length: header.metadata) ?? []
            assert(metadata.count == header.metadata)

            let node = LicenseTree.Node(header: header, metadata: metadata, nodes: [])
            return ConstructNodesResponse(node: node, remainder: stream)
        } else {
            var childNodes = [LicenseTree.Node]()
            var childStream = stream
            while childNodes.count < header.children {
                if let recursiveChildNodes = constructNodes(stream: childStream) {
                    if let childNode = recursiveChildNodes.node {
                        childNodes.append(childNode)
                    }
                    childStream = recursiveChildNodes.remainder
                }
            }
            assert(header.children == childNodes.count)
            stream = childStream

            let metadata = stream.pullMetadata(length: header.metadata) ?? []
            assert(metadata.count == header.metadata)

            let node = LicenseTree.Node(header: header, metadata: metadata, nodes: childNodes)
            return ConstructNodesResponse(node: node, remainder: stream)
        }
    }
}
