#!/usr/bin/env swift

import Foundation

// ----------------------------------------------------------------------------
struct GridNode {
    let x: Int
    let y: Int
    let size: Int
    let used: Int
    let available: Int
    let usedPercentage: Int

    init?(_ input: String) {
        // http://rubular.com/r/zJQc1T7ckJ
        let nodeRegex = "^\\/dev\\/grid\\/node-x(\\d+)-y(\\d+)\\s+(\\d+)T\\s+(\\d+)T\\s+(\\d+)T\\s+(\\d+)%"

        guard let matches = input.matches(regex: nodeRegex) else { return nil }
        guard let match = matches.first else { return nil }

        //                         0  1     2     3      4     5
        // format: /dev/grid/node-x0-y0     90T   69T    21T   76%
        x = Int.init(match.captures[0])!
        y = Int.init(match.captures[1])!
        size = Int.init(match.captures[2])!
        used = Int.init(match.captures[3])!
        available = Int.init(match.captures[4])!
        usedPercentage = Int.init(match.captures[5])!
    }

    func willFit(within node: GridNode) -> Bool {
        // we are A, node is B...
        // Node A is **not** empty (its `Used` is not zero).
        guard used > 0 else { return false }
        // Nodes A and B are **not the same** node.
        guard !(x == node.x && y == node.y) else { return false }
        // The data on node A (its `Used`) **would fit** on node B (its `Avail`).
        return used <= node.available
    }
}

extension GridNode: CustomDebugStringConvertible {
    var debugDescription: String {
        return "GridNode(\(x),\(y) S:\(size)T U:\(used)T A:\(available)T)"
    }
}

// ----------------------------------------------------------------------------
struct Grid {
    let maxX: Int
    let maxY: Int
    var nodes: [GridNode]

    init(_ input: [String]) {
        nodes = input.flatMap { GridNode($0) }

        let maxXNode: GridNode! = nodes.max { a, b in a.x < b.x }
        maxX = maxXNode.x
        let maxYNode: GridNode! = nodes.max { a, b in a.y < b.y }
        maxY = maxYNode.y
    }

    func node(x: Int, y: Int) -> GridNode? {
        return nodes.first(where: { $0.x == x && $0.y == y})
    }

    func viablePairs() -> [[GridNode]] {
        var pairs = [[GridNode]]()
        nodes.forEach { nodeA in
            nodes.forEach { nodeB in
                if nodeA.willFit(within: nodeB) {
                    // print("Node \(nodeA) will fit into Node \(nodeB)")
                    pairs.append([nodeA, nodeB])
                }
            }
        }

        return pairs
    }
}

extension Grid: CustomDebugStringConvertible {
    var debugDescription: String {
        var desc = "Grid(maxX:\(maxX), maxY:\(maxY) nodes:\(nodes.count))\n"
        let rows = (0...maxY).map { y in
            return (0...maxX).flatMap { x in
                guard let node = self.node(x: x, y: y) else { return nil }
                return "\(node.usedPercentage)".padding(toLength: 3, withPad: " ", startingAt:0)
            }.joined(separator: "| ")
        }.joined(separator: "\n")

        // pad to 3
        desc += "\(rows)"
        return desc
    }
}

// ----------------------------------------------------------------------------
extension String {
    struct RegexMatch : CustomDebugStringConvertible {
        let match: String
        let captures: [String]
        let range: NSRange

        var debugDescription: String {
            return "RegexMatch( match: '\(match)', captures: [\(captures)], range: \(range) )"
        }

        init(string: String, regexMatch: NSTextCheckingResult) {
            var theCaptures: [String] = (0..<regexMatch.numberOfRanges).flatMap { index in
                let range = regexMatch.rangeAt(index)
                if let _ = range.toRange() {
                    return (string as NSString).substring(with: range)
                } else {
                    return nil
                }
            }

            match = theCaptures.removeFirst() // the 0 index is the whole string that matches
            captures = theCaptures
            range = regexMatch.range
        }
    }

    func matches(regex: String) -> [RegexMatch]? {
        do {
            let regex = try NSRegularExpression(pattern: regex, options: .caseInsensitive)
            let wholeThing = NSMakeRange(0, characters.count)
            let regexMatches = regex.matches(in: self, options: .withoutAnchoringBounds, range: wholeThing)

            guard let _ = regexMatches.first else { return nil }

            return regexMatches.flatMap { m in
                return RegexMatch.init(string: self, regexMatch: m)
            }
        } catch {
            return nil
        }
    }
}

// ----------------------------------------------------------------------------
// returns the lines out of the input file
func readInputData() -> [String] {
    guard let currentDir = ProcessInfo.processInfo.environment["PWD"] else {
        print("No current directory.")
        return []
    }

    let inputPath = "\(currentDir)/input.txt"
    do {
        let data = try String(contentsOfFile: inputPath, encoding: .utf8)
        let lines = data.components(separatedBy: "\n")
                        .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                        .filter { !$0.isEmpty }
        return lines
    } catch {
        return []
    }
}

// ----------------------------------------------------------------------------
// MARK: - "MAIN()"
let lines = readInputData()
var grid = Grid(lines)
print(grid)
print("Found \(grid.nodes.count) nodes")

// var pairs = grid.viablePairs()
// print("Found \(pairs.count) valid pairs")
