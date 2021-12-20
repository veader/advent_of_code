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

    init(left: SnailfishNumberSide, right: SnailfishNumberSide) {
        self.leftSide = left
        self.rightSide = right
    }

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

    /// Create a "BFS" listing of nodes which contain
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

    func reduce() {
        print("Initial: \(self)")
        var changesMade = true
        var iterationCount = 0

        while changesMade {
            iterationCount += 1
            
            let bfsList = self.createBFSList()
            if explodeNew(currentDepth: 0, bfsList: bfsList) {
                print("\tExplosion detected... \(iterationCount)")
                break
            }

        }

        print("Final: \(self)")
    }

    func explodeNew(currentDepth: Int, bfsList: [SnailfishNumber]) -> Bool {
        // first check ourself...
        if self.shouldExplode(currentDepth: currentDepth) {
            print("BOOM! \(self) @ \(currentDepth)")

            guard case .literal(let leftNum) = leftSide, case .literal(let rightNum) = rightSide else {
                print("PROBLEM!! (LEFT)"); assert(false)
            }

            if let idx = bfsList.firstIndex(of: self) {
                let leftIndex = bfsList.index(before: idx)
                if bfsList.indices.contains(leftIndex) {
                    let leftishNode = bfsList[leftIndex]
                    if case .literal(let num) = leftishNode.rightSide {
                        leftishNode.rightSide = .literal(number: num + leftNum)
                    } else if case .literal(let num) = leftishNode.leftSide {
                        leftishNode.leftSide = .literal(number: num + leftNum)
                        if case .nested(let rs) = leftishNode.rightSide, rs == self {
                            print("FOUND ME! (leftish)")
                            leftishNode.rightSide = .literal(number: 0)
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
                            print("FOUND ME! (rightish)")
                            rightishNode.leftSide = .literal(number: 0)
                        }
                    } else {
                        print("Uh.... nothing in rightish node... \(rightishNode)")
                    }
                }

            }

            return true
        }

        // check left, then right
        if case .nested(let side) = leftSide, side.explodeNew(currentDepth: currentDepth + 1, bfsList: bfsList) {
            return true
        }
        if case .nested(let side) = rightSide, side.explodeNew(currentDepth: currentDepth + 1, bfsList: bfsList) {
            return true
        }

        return false
    }

    func explode(currentDepth: Int) -> (left: Int, right: Int, changed: Bool) {
        if case .nested(let nestedLeft) = leftSide {
            if nestedLeft.shouldExplode(currentDepth: currentDepth + 1) {
                guard case .literal(let leftNum) = nestedLeft.leftSide, case .literal(let rightNum) = nestedLeft.rightSide else {
                    print("BOOOOOOOMM!!! (LEFT)"); assert(false)
                }

                leftSide = .literal(number: 0) // replace left with 0
                return (leftNum, rightNum, true) // pass values up stream
            } else {
                let result = nestedLeft.explode(currentDepth: currentDepth + 1)
                var newRight = result.right

                if result.changed {
                    if case .literal(let rightNum) = rightSide {
                        rightSide = .literal(number: rightNum + result.right)
                        newRight = 0 // used the right number
                    } else if case .nested(let rightNested) = rightSide {
                        newRight = rightNested.increment(value: result.right, closeLeft: true)
                    }

                    return (result.left, newRight, result.changed)
                }
            }
        } else if case .nested(let nestedRight) = rightSide {
            if nestedRight.shouldExplode(currentDepth: currentDepth + 1) {
                guard case .literal(let leftNum) = nestedRight.leftSide, case .literal(let rightNum) = nestedRight.rightSide else {
                    print("BOOOOOOOMM!!! (RIGHT)"); assert(false)
                }

                rightSide = .literal(number: 0) // replace right with 0
                return (leftNum, rightNum, true) // pass values up stream
            } else {
                let result = nestedRight.explode(currentDepth: currentDepth + 1)
                var newLeft = result.left

                if result.changed {
                    if case .literal(let leftNum) = leftSide {
                        leftSide = .literal(number: leftNum + result.left)
                        newLeft = 0 // used the left number
                    } else if case .nested(let leftNested) = leftSide {
                        newLeft = leftNested.increment(value: result.left, closeLeft: false)
                    }

                    return (newLeft, result.right, result.changed)
                }
            }
        }

        return (0,0,false)
    }

    /// Increment the closest number (literal) left or right by the given amount.
    ///
    /// Crawl child nodes looking for one closest to left or right (depending on `closeLeft`)
    /// and find the literal that should be updated (if any).
    ///
    /// - parameters:
    ///     - value: `Int` - Numeric value to add to closest literal
    ///     - closeLeft: `Bool` - Should we find the number closest to the left (or right)?
    ///
    /// - returns: Unused value for this node (and children)
    private func increment(value: Int, closeLeft: Bool) -> Int {
        if closeLeft {
            // find literal number on the "left most" node
            if case .literal(let num) = leftSide {
                leftSide = .literal(number: num + value)
                return 0
            } else if case .nested(let nested) = leftSide {
                return nested.increment(value: value, closeLeft: closeLeft)
            } else {
                print("Uh... you shouldn't be here! (0)")
            }
        } else {
            // find literal number on the "right most" node
            if case .literal(let num) = rightSide {
                rightSide = .literal(number: num + value)
                return 0
            } else if case .nested(let nested) = rightSide {
                return nested.increment(value: value, closeLeft: closeLeft)
            } else {
                print("Uh... you shouldn't be here! (1)")
            }
        }

        print("Uh... you shouldn't be here! (2)")
        return 0
    }

    /// Should this number explode (a pair of literal values and depth >= 4)?
    private func shouldExplode(currentDepth: Int) -> Bool {
        guard currentDepth >= 4, case .literal = leftSide, case .literal = rightSide else { return false }
        return true
    }

    func split(currentDepth: Int) -> Bool {
        return false
    }
}

// MARK: - Equatable
extension SnailfishNumber: Equatable {
    static func == (lhs: SnailfishNumber, rhs: SnailfishNumber) -> Bool {
        lhs.leftSide == rhs.leftSide &&
        lhs.rightSide == rhs.rightSide
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
