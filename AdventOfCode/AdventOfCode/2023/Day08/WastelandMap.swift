//
//  WastelandMap.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/8/23.
//

import Foundation
import RegexBuilder

class WastelandMap {
    enum Direction: String {
        case left = "L"
        case right = "R"
    }

    enum WastelandError: Error {
        case nodeNotFound
        case pathFollowingError
    }

    class WastelandNode: CustomDebugStringConvertible {
        let name: String
        var routes: Set<String>
        let pathLeft: String
        let pathRight: String

        var deadend: Bool {
            pathLeft == name && pathRight == name
        }

        init?(_ input: String) {
            // AAA = (BBB, CCC)
            guard let match = input.firstMatch(of: /^(\w{3})\s+=\s+\((\w{3}),\s+(\w{3})\)/) else { return nil}
            name = String(match.output.1)
            routes = []
            pathLeft = String(match.output.2)
            pathRight = String(match.output.3)
        }

        func node(to direction: Direction) -> String {
            switch direction {
            case .left:
                pathLeft
            case .right:
                pathRight
            }
        }

        var debugDescription: String {
            "WastelandNode(\(name) L:\(pathLeft) R:\(pathRight) routes:[\(routes.joined(separator: ","))])"
        }
    }


    // MARK: -

    static let start = "AAA"
    static let end = "ZZZ"

    /// Directions to follow through the wasteland...
    let directions: [Direction]

    /// Oasis nodes you migth find along the way...
    let nodes: [String: WastelandNode]

    init(_ input: String) {
        var lines = input.split(separator: "\n").map(String.init)

        directions = lines.removeFirst().split(separator: "").map(String.init).compactMap { Direction(rawValue: $0) }
        
        var tmpNodes = [String: WastelandNode]()

        // create out basic nodes and add them to the dictionary
        for node in lines.compactMap({ WastelandNode($0) }) {
            tmpNodes[node.name] = node
        }

        // next make a pass to determine routes (links) between items
        for node in tmpNodes.values {
            guard !node.deadend else { continue }
            
            if let leftNode = tmpNodes[node.pathLeft] {
                leftNode.routes.insert(node.name)
            }

            if let rightNode = tmpNodes[node.pathRight] {
                rightNode.routes.insert(node.name)
            }
        }

        nodes = tmpNodes
    }

    func followDirections() throws -> Int {
        var directionIdx = 0
        var directionsTaken = 0
        var current = WastelandMap.start

        while current != WastelandMap.end {
            let direction = directions[directionIdx]
            guard let node = nodes[current] else {
                print("💥 Unable to find \(current)")
                throw WastelandError.nodeNotFound
            }

            let nextNode = node.node(to: direction)

            current = nextNode
            directionIdx = (directionIdx + 1) % directions.count
            directionsTaken += 1
        }

        return directionsTaken
    }

    func followGhosts() throws -> Int {
        let startNodes = startNodes()
        // print("Start nodes: \(startNodes.joined(separator: ","))")

        var directionIdx = 0
        var directionsTaken = 0
        var currentNodes = startNodes

        while !endInZed(nodes: currentNodes) {
            let direction = directions[directionIdx]
            // print("\(directionsTaken): [\(currentNodes.joined(separator: ", "))] going \(direction.rawValue)")

            let nextNodes = currentNodes.compactMap {
                nodes[$0]?.node(to: direction)
            }

            if nextNodes.count != currentNodes.count {
                throw WastelandError.pathFollowingError
            }

            currentNodes = nextNodes
            directionIdx = (directionIdx + 1) % directions.count
            directionsTaken += 1
        }

        return directionsTaken
    }

    /// Find all nodes that end in A
    func startNodes() -> [String] {
        nodes.keys.filter { $0.hasSuffix("A") }
    }

    /// Do all of the given nodes end in Z?
    func endInZed(nodes: [String]) -> Bool {
        nodes.filter({ $0.hasSuffix("Z") }).count == nodes.count
    }
}

extension WastelandMap: CustomDebugStringConvertible {
    var debugDescription: String {
        var output = "WastelandMap("
        output += "direction: [\(directions.map(\.rawValue).joined())] "
        output += "nodes: [\(nodes.values.map(\.name).joined(separator: ","))]"
        output += ")"
        return output
    }
}
