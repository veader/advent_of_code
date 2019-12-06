//
//  DaySix.swift
//  aoc2019
//
//  Created by Shawn Veader on 12/6/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import Foundation

struct OrbitDescription {
    let parent: String
    let child: String

    init?(_ description: String?) {
        guard let description = description, !description.isEmpty else { return nil }

        let pieces = description.split(separator: ")").compactMap(String.init)
        guard
            pieces.count == 2,
            let parentName = pieces.first,
            let childName = pieces.last
            else { return nil }

        parent = parentName
        child = childName
    }
}

extension OrbitNode {
    var checksum: Int {
        children.reduce(self.depth) { result, child -> Int in
            result + child.checksum
        }
    }
}

struct DaySix: AdventDay {
    var dayNumber: Int = 6

    func parse(_ input: String?) -> [OrbitDescription] {
        return (input ?? "")
                .split(separator: "\n")
                .map(String.init)
                .compactMap { OrbitDescription($0) }
    }

    func partOne(input: String?) -> Any {
        let descriptions = parse(input)
        guard let orbitGraph = buildOrbitGraph(with: descriptions) else { return 0 }
        return orbitGraph.checksum
    }

    func partTwo(input: String?) -> Any {
        let descriptions = parse(input)
        guard
            let orbitGraph = buildOrbitGraph(with: descriptions),
            let commonAncestor = orbitGraph.commonAncestor(first: "YOU", second: "SAN"),
            let youNode = orbitGraph.search(for: "YOU"),
            let santaNode = orbitGraph.search(for: "SAN")
            else { return 0 }

        return (santaNode.depth(to: commonAncestor.value) ?? 0) +
                (youNode.depth(to: commonAncestor.value) ?? 0)
    }

    /// Return the parent node of the graph build by processing descriptions
    func buildOrbitGraph(with descriptions: [OrbitDescription]) -> OrbitNode? {
        var danglingNodes = [OrbitNode]()

        for orbit in descriptions {
            var parent: OrbitNode?
            if let existingParent = danglingNodes.compactMap({ $0.search(for: orbit.parent) }).first {
                parent = existingParent
            } else {
                // parent doesn't exist, create and add to dangling
                parent = OrbitNode(value: orbit.parent)
                danglingNodes.append(parent!) // safe!
            }

            guard let parentNode = parent else {
                print("Unable to find/create parent: \"\(orbit.parent)\"")
                break
            }

            var child: OrbitNode?
            if let existingChild = danglingNodes.compactMap({ $0.search(for: orbit.child) }).first {
                child = existingChild

                // remove root of this existing child node from the dangling nodes collection
                let childRoot = existingChild.root
                danglingNodes.removeAll { $0.value == childRoot.value }
            } else {
                child = OrbitNode(value: orbit.child)
            }

            guard let childNode = child else {
                print("Unable to find/create child: \"\(orbit.child)\"")
                break
            }

            parentNode.add(node: childNode)
        }

        return danglingNodes.first
    }
}
