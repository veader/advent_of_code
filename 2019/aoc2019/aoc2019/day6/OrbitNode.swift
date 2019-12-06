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

    func depth(to node: String) -> Int? {
        return pathToRoot().firstIndex(where: { $0.value == node })
    }

    func commonAncestor(first: String, second: String) -> OrbitNode? {
        guard
            let firstNode = search(for: first),
            let secondNode = search(for: second)
            else { return nil }

        var firstPath = firstNode.pathToRoot()
        var secondPath = secondNode.pathToRoot()

        var ancestor: OrbitNode?

        // lots of array mutations, should probably do some index stuffs...
        var tmpFirst = firstPath.popLast()
        var tmpSecond = secondPath.popLast()
        while tmpFirst != nil, tmpSecond != nil {
            guard tmpFirst?.value == tmpSecond?.value else { break }
            ancestor = tmpFirst
            tmpFirst = firstPath.popLast()
            tmpSecond = secondPath.popLast()
        }

        return ancestor
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
