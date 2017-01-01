#!/usr/bin/env swift

import Foundation

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

    func scrambled(with instructions: [String]) -> String {

        var copy = self
        instructions.forEach { instruction in
            if let inst = SwapPositionInstruction(instruction) {
                copy = inst.swap(with: copy)
            } else if let inst = SwapLetterInstruction(instruction) {
                copy = inst.swap(with: copy)
            } else if let inst = RotatePositionsInstruction(instruction) {
                copy = inst.rotate(with: copy)
            } else if let inst = RotateByLetterInstruction(instruction) {
                copy = inst.rotate(with: copy)
            } else if let inst = ReverseInstruction(instruction) {
                copy = inst.reverse(with: copy)
            } else if let inst = MoveInstruction(instruction) {
                copy = inst.move(with: copy)
            } else {
                print("HUH!?! \(instruction)")
            }
        }
        return copy
    }

    struct SwapPositionInstruction {
        let from: Int
        let to: Int

        init?(_ input: String) {
            // http://rubular.com/r/9Npp2UpH8G
            let swapPositionRegex = "swap position (\\d+) with position (\\d+)"
            guard let matches = input.matches(regex: swapPositionRegex) else { return nil }
            guard let match = matches.first else { return nil }

            from = Int.init(match.captures[0])!
            to = Int.init(match.captures[1])!
        }

        func swap(with input: String) -> String {
            var output = input

            let fromIndex = input.index(input.startIndex, offsetBy: from)
            let fromLetter = String(input[fromIndex])

            let toIndex = input.index(input.startIndex, offsetBy: to)
            let toLetter = String(input[toIndex])

            output.replaceSubrange(fromIndex...fromIndex, with: toLetter)
            output.replaceSubrange(toIndex...toIndex, with: fromLetter)

            print("Swap Position: \(from)->\(to) \(input) -> \(output)")
            return output
        }
    }

    struct SwapLetterInstruction {
        let fromLetter: String
        let toLetter: String

        init?(_ input: String) {
            // http://rubular.com/r/LhjQbPOydF
            let swapLetterRegex = "swap letter ([a-z]) with letter ([a-z])"
            guard let matches = input.matches(regex: swapLetterRegex) else { return nil }
            guard let match = matches.first else { return nil }

            fromLetter = match.captures[0]
            toLetter = match.captures[1]
        }

        func swap(with input: String) -> String {
            var output = input
            output = output.replacingOccurrences(of: fromLetter, with: "*")
            output = output.replacingOccurrences(of: toLetter, with: fromLetter)
            output = output.replacingOccurrences(of: "*", with: toLetter)

            print("Swap Letters: \(fromLetter)->\(toLetter) \(input) -> \(output)")
            return output
        }
    }

    struct RotatePositionsInstruction {
        enum RotateDirection: String {
            case left = "left"
            case right = "right"
        }

        let direction: RotateDirection
        let steps: Int

        init?(_ input: String) {
            // http://rubular.com/r/yrdhwHg57r
            let rotatePositionsRegex = "rotate (left|right) (\\d+) step"
            guard let matches = input.matches(regex: rotatePositionsRegex) else { return nil }
            guard let match = matches.first else { return nil }

            direction = RotateDirection(rawValue: match.captures[0])!
            steps = Int.init(match.captures[1])!
        }

        func rotate(with input: String) -> String {
            var output = ""

            switch direction {
            case .left:
                let splitIndex = input.index(input.startIndex, offsetBy: steps)
                output = input.substring(from: splitIndex) + input.substring(to: splitIndex)
            case .right:
                let splitIndex = input.index(input.startIndex, offsetBy: input.characters.count - steps)
                output = input.substring(from: splitIndex) + input.substring(to: splitIndex)
            }

            print("Rotate: \(direction.rawValue) by \(steps) \(input) -> \(output)")
            return output
        }
    }

    struct RotateByLetterInstruction {
        let letter: String

        init?(_ input: String) {
            // http://rubular.com/r/r8oQDzKpDs
            let rotateBasedOnLetterRegex = "rotate based on position of letter ([a-z])"
            guard let matches = input.matches(regex: rotateBasedOnLetterRegex) else { return nil }
            guard let match = matches.first else { return nil }

            letter = match.captures[0]
        }

        func rotate(with input: String) -> String {
            var output = ""

            if let letterIndex = input.characters.index(of: letter.characters.first!) {
                let letterDistance = input.distance(from:input.startIndex, to: letterIndex)
                var steps = 1 + letterDistance
                if letterDistance >= 4 {
                    steps += 1
                }
                steps = steps % input.characters.count

                let splitIndex = input.index(input.startIndex, offsetBy: input.characters.count - steps)
                output = input.substring(from: splitIndex) + input.substring(to: splitIndex)

                print("Rotate Letter: \(letter)->\(steps) \(input) -> \(output)")
            } else {
                print("BOOM: Couldn't find \(letter) in \(input)")
            }

            return output
        }
    }

    struct ReverseInstruction {
        let from: Int
        let to: Int

        init?(_ input: String) {
            // http://rubular.com/r/WVNLFMyg0Q
            let reverseRegex = "reverse positions (\\d+) through (\\d+)"
            guard let matches = input.matches(regex: reverseRegex) else { return nil }
            guard let match = matches.first else { return nil }

            from = Int.init(match.captures[0])!
            to = Int.init(match.captures[1])!
        }

        func reverse(with input: String) -> String {
            let fromIndex = input.index(input.startIndex, offsetBy: from)
            let toIndex   = input.index(input.startIndex, offsetBy: to + 1, limitedBy: input.endIndex)!

            let output = input.substring(to: fromIndex) +
                         String(input.substring(with: fromIndex..<toIndex).characters.reversed()) +
                         input.substring(from: toIndex)

            print("Reverse: \(from)->\(to) \(input) -> \(output)")
            return output
        }
    }

    struct MoveInstruction {
        let from: Int
        let to: Int

        init?(_ input: String) {
            // http://rubular.com/r/QUgJ1cQ5ab
            let moveRegex = "move position (\\d+) to position (\\d+)"
            guard let matches = input.matches(regex: moveRegex) else { return nil }
            guard let match = matches.first else { return nil }

            from = Int.init(match.captures[0])!
            to = Int.init(match.captures[1])!
        }

        func move(with input: String) -> String {
            var output = input

            let fromIndex = input.index(input.startIndex, offsetBy: from)
            let toIndex = input.index(input.startIndex, offsetBy: to)

            let letter = output.remove(at: fromIndex)
            output.insert(letter, at: toIndex)

            print("Move: \(from)->\(to) \(input) -> \(output)")
            return output
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
let instructions = readInputData()

let password  = "abcdefgh"
let scrambled = password.scrambled(with: instructions)
print(scrambled)
