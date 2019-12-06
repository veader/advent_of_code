//
//  OrbitNode.swift
//  aoc2019
//
//  Created by Shawn Veader on 12/6/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import Foundation

class OrbitNode {
    let value: String
    var children: [OrbitNode] = [OrbitNode]()
    var parent: OrbitNode?

    var root: OrbitNode {
        guard let parent = parent else { return self } // i am the root
        return parent.root
    }

    var depth: Int {
        pathToRoot().count
    }

    init(value: String) {
        self.value = value
    }

    func add(node: OrbitNode) {
        children.append(node)
        node.parent = self
    }

    func search(for value: String) -> OrbitNode? {
        guard self.value != value else { return self }

        // return children.compactMap({ $0.search(for: value) }).first
        for child in children {
            if let match = child.search(for: value) {
                return match
            }
        }

        return nil
    }

    func pathToRoot() -> [OrbitNode] {
        var path = [OrbitNode]()

        var node = self.parent
        while node != nil {
            guard let theNode = node else { break }
            path.append(theNode)
            node = theNode.parent
        }

        return path
    }
}

extension OrbitNode: CustomDebugStringConvertible {
    var debugDescription: String {
        return "[\(value): {" +
                children.map { $0.debugDescription }.joined(separator: ", ") +
                "}]"
    }

    var nestedOutput: String {
        return nestedDescription()
    }

    func nestedDescription(level: Int = 0) -> String {
        let nestingLevel = (0...level).map { _ in "\t" }.joined()
        var output = "\n" + nestingLevel
        output += "[\(value): {" +
                    children.map { $0.nestedDescription(level: level + 1) }.joined(separator: ",\n") +
                    "\n\(nestingLevel)}]"
        return output
    }
}
