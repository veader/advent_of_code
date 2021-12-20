//
//  SnailfishNumber.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/19/21.
//

import Foundation

class SnailfishNumber {
    indirect enum SnailfishNumberSide: Equatable, CustomStringConvertible {
        case literal(number: Int)
        case nested(number: SnailfishNumber)

        static func == (lhs: SnailfishNumber.SnailfishNumberSide, rhs: SnailfishNumber.SnailfishNumberSide) -> Bool {
            switch (lhs, rhs) {
            case (.literal(let numLHS), .literal(let numRHS)):
                return numLHS == numRHS
            case (.nested(let numLHS), .nested(let numRHS)):
                return numLHS == numRHS
            default:
                return false
            }
        }

        var description: String {
            switch self {
            case .literal(number: let num):
                return "\(num)"
            case .nested(number: let nested):
                return nested.description
            }
        }
    }

    var leftSide: SnailfishNumberSide
    var rightSide: SnailfishNumberSide
    let uuid: UUID

    init(left: SnailfishNumberSide, right: SnailfishNumberSide) {
        self.leftSide = left
        self.rightSide = right
        self.uuid = UUID()
    }

    /// Create a new `SnailfishNumber` by adding two existing numbers.
    static func add(_ left: SnailfishNumber, _ right: SnailfishNumber) -> SnailfishNumber {
        SnailfishNumber(left: .nested(number: left), right: .nested(number: right))
    }

    /// Is either side of this number a literal value?
    var hasLiteral: Bool {
        if case .literal = leftSide {
            return true
        } else if case .literal = rightSide {
            return true
        }

        return false
    }

    /// Calculate the "magnitude" of the SnailfishNumber.
    func magnitude() -> Int {
        var mag = 0
        switch leftSide {
        case .literal(let number):
            mag += number * 3
        case .nested(let number):
            mag += number.magnitude() * 3
        }

        switch rightSide {
        case .literal(let number):
            mag += number * 2
        case .nested(let number):
            mag += number.magnitude() * 2
        }

        return mag
    }

    /// Reduce the given number down by exploding and splitting as necessary.
    func reduce(passes: Int = Int.max) {
//        print("Initial: \(self)")
        var changesMade = true
        var iterationCount = 0

        while changesMade {
            iterationCount += 1
//            print("[\(iterationCount)]: \(self)")

            let bfsList = self.createBFSList()
            let explodeResult = explode(currentDepth: 0, bfsList: bfsList)
            if explodeResult.explode {
                if let node = explodeResult.node {
                    // node wasn't removed yet, do that now
                    if !zeroOut(node: node) {
                        print("\t\tNode not found to replace!")
                    }
                }

//                print("\tExplosion detected... \(iterationCount)")
            } else if split() {
//                print("\tSplit detected... \(iterationCount)")
            } else {
//                print("\tNo changes needed.")
                changesMade = false
            }

            guard iterationCount < passes else { break }
        }

//        print("Final: \(self)")
    }


    // MARK: - Explode

    /// Check if the current node should explode. If so, propogate it's values left/right.
    ///
    /// - returns: Tuple containing if node was exploded and the node (if it wasn't already removed)
    func explode(currentDepth: Int, bfsList: [SnailfishNumber]) -> (explode: Bool, node: SnailfishNumber?) {
        if self.shouldExplode(currentDepth: currentDepth) {
//            print("BOOM! \(self) @ \(currentDepth)")

            guard case .literal(let leftNum) = leftSide, case .literal(let rightNum) = rightSide else {
                print("PROBLEM!!"); assert(false)
            }

            var replacedNode = false

            if let idx = bfsList.firstIndex(of: self) {
                let leftIndex = bfsList.index(before: idx)
                if bfsList.indices.contains(leftIndex) {
                    let leftishNode = bfsList[leftIndex]
                    if case .literal(let num) = leftishNode.rightSide {
                        leftishNode.rightSide = .literal(number: num + leftNum)
                    } else if case .literal(let num) = leftishNode.leftSide {
                        leftishNode.leftSide = .literal(number: num + leftNum)
                        if case .nested(let rs) = leftishNode.rightSide, rs == self {
                            leftishNode.rightSide = .literal(number: 0)
                            replacedNode = true
                        }
                    } else {
                        print("Uh... nothing in leftish node...")
                    }
                }

                let rightIndex = bfsList.index(after: idx)
                if bfsList.indices.contains(rightIndex) {
                    let rightishNode = bfsList[rightIndex]
                    if case .literal(let num) = rightishNode.leftSide {
                        rightishNode.leftSide = .literal(number: num + rightNum)
                    } else if case .literal(let num) = rightishNode.rightSide {
                        rightishNode.rightSide = .literal(number: num + rightNum)
                        if case .nested(let ls) = rightishNode.leftSide, ls == self {
                            rightishNode.leftSide = .literal(number: 0)
                            replacedNode = true
                        }
                    } else {
                        print("Uh.... nothing in rightish node... \(rightishNode)")
                    }
                }
            }

            if replacedNode {
                return (true, nil)
            } else {
                return (true, self)
            }
        }

        // check left, then right
        if case .nested(let side) = leftSide {
            let result = side.explode(currentDepth: currentDepth + 1, bfsList: bfsList)
            if result.explode {
                return result
            }
        }
        if case .nested(let side) = rightSide {
            let result = side.explode(currentDepth: currentDepth + 1, bfsList: bfsList)
            if result.explode {
                return result
            }
        }

        return (false, nil)
    }

    /// Create a "BFS" listing of nodes which contain literals.
    func createBFSList() -> [SnailfishNumber] {
        var mapping = [[SnailfishNumber]]()

        if case .nested(let leftNum) = leftSide {
            mapping.append(leftNum.createBFSList())
        }
        if hasLiteral {
            mapping.append([self])
        }
        if case .nested(let rightNum) = rightSide {
            mapping.append(rightNum.createBFSList())
        }

        return mapping.flatMap { $0 }
    }

    /// Walk the BST and replace this node with a literal(0) node.
    private func zeroOut(node: SnailfishNumber) -> Bool {
        if case .nested(number: let side) = leftSide {
            if side == node {
                leftSide = .literal(number: 0)
                return true
            } else if side.zeroOut(node: node) {
                return true
            }
        }

        if case .nested(number: let side) = rightSide {
            if side == node {
                rightSide = .literal(number: 0)
                return true
            } else if side.zeroOut(node: node) {
                return true
            }
        }

        return false
    }

    /// Should this number explode (a pair of literal values and depth >= 4)?
    private func shouldExplode(currentDepth: Int) -> Bool {
        guard currentDepth >= 4, case .literal = leftSide, case .literal = rightSide else { return false }
        return true
    }


    // MARK: - Split

    /// Split any literal value >= 10.
    func split() -> Bool {
        // start with left side
        if case .literal(let num) = leftSide, num >= 10 {
            leftSide = .nested(number: generateSplit(num))
            return true
        } else if case .nested(let side) = leftSide, side.split() {
            return true
        }

        // if left side didn't split, look right
        if case .literal(let num) = rightSide, num >= 10 {
            rightSide = .nested(number: generateSplit(num))
            return true
        } else if case .nested(let side) = rightSide, side.split() {
            return true
        }

        return false
    }

    /// Generate split for value if too large. Results in a nested `SnailfishNumber`.
    private func generateSplit(_ value: Int) -> SnailfishNumber {
        let left = value / 2
        let right = Int( (Float(value) / 2.0).rounded() )
        return SnailfishNumber(left: .literal(number: left), right: .literal(number: right))
    }
}

// MARK: - Equatable
extension SnailfishNumber: Equatable {
    static func == (lhs: SnailfishNumber, rhs: SnailfishNumber) -> Bool {
        lhs.leftSide == rhs.leftSide &&
        lhs.rightSide == rhs.rightSide &&
        lhs.uuid == rhs.uuid
    }
}

// MARK: - CustomStringConvertible
extension SnailfishNumber: CustomStringConvertible {
    var description: String {
        var output = "["
        output += leftSide.description
        output += ","
        output += rightSide.description
        output += "]"
        return output
    }
}

// MARK: - Parsing
extension SnailfishNumber {
    /// Parse the given input for a `SnailfishNumber`
    static func parse(_ input: String) -> SnailfishNumber? {
        var idx = input.startIndex
        return parseNumber(input, depth: 0, index: &idx)
    }

    /// Parse the input from the given index as a `SnailfishNumber` tracking nesting depth as we go.
    private static func parseNumber(_ input: String, depth: Int = 0, index: inout String.Index) -> SnailfishNumber? {
        guard matching(char: "[", in: input, at: &index) else { return nil }

        let left: SnailfishNumberSide? = parseSide(input, depth: depth, index: &index)

        guard matching(char: ",", in: input, at: &index) else { return nil }

        let right: SnailfishNumberSide? = parseSide(input, depth: depth, index: &index)

        guard matching(char: "]", in: input, at: &index) else { return nil }

        guard let left = left, let right = right else { return nil }
        return SnailfishNumber(left: left, right: right)
    }

    private static func parseSide(_ input: String, depth: Int, index: inout String.Index) -> SnailfishNumberSide? {
        guard index <= input.endIndex else { return nil }

        if input[index] == "[" { // nested
            guard let num = parseNumber(input, depth: depth+1, index: &index) else { return nil }
            return .nested(number: num)
        } else if input[index].isNumber { // literal
            var numChars = [Character]()
            while input[index].isNumber {
                numChars.append(input[index])
                index = input.index(after: index)
                guard input.indices.contains(index) else { break }
            }
            guard let literal = Int(String(numChars)) else { return nil }
            return .literal(number: literal)
        } else {
            print("Unknown character encountered processing side: \(input[index])")
            index = input.index(after: index)
            return nil
        }
    }

    /// Check if the character at the given index matches the value. If so, move the index beyond it.
    ///
    /// - returns: `Bool` - if the character matched and the index was moved
    private static func matching(char: Character, in input: String, at index: inout String.Index) -> Bool {
        guard input.indices.contains(index) else { return false }
        if input[index] == char {
            index = input.index(after: index)
            return true
        } else {
            return false
        }
    }
}

// MARK: - Hashable
extension SnailfishNumber: Hashable {
    /// Hash based on UUID
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
