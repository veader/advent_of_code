#!/usr/bin/env swift

import Foundation

extension String {
    func decompressed() -> String {
        var output = ""

        let pieces = components(separatedBy: "(")

        // http://rubular.com/r/zSyjth5Vpo - "1x2)ABCD"
        let fullRegex = "(\\d+)x(\\d+)\\)(.+)"
        // http://rubular.com/r/NsnfXRBEoo - "3x4)"
        let partRegex = "(\\d+)x(\\d+)\\)$"

        var lastRepeat: RegexMatch?
        var repeatableText = ""
        _ = pieces.map { piece in
            if let matches = piece.matches(regex: fullRegex) {
                guard let match = matches.first else { return }

                if lastRepeat == nil {
                    let repeatInst = parseRepeat(match)
                    let text = match.captures[2]
                    let expandedText = expandString(text, count: repeatInst.charCount, times: repeatInst.times)
                    // print("Appending: \(expandedText)")
                    output.append(expandedText)
                } else {
                    let repeatInst = parseRepeat(lastRepeat!)
                    repeatableText.append("(\(match.match)") // have to add the open paren back on

                    if repeatableText.characters.count >= repeatInst.charCount {
                        let expandedText = expandString(repeatableText, count: repeatInst.charCount, times: repeatInst.times)
                        // print("Appending: \(expandedText)")
                        output.append(expandedText)

                        lastRepeat = nil
                        repeatableText = ""
                    } else {
                        // print("Collecting(1): (\(match.match)")
                    }
                }
            } else if let matches = piece.matches(regex: partRegex) {
                guard let match = matches.first else { return }
                if lastRepeat == nil {
                    lastRepeat = match
                } else {
                    repeatableText.append("(\(match.match)") // have to add the open paren back on
                }
            } else {
                if lastRepeat == nil {
                    // print("Appending: \(piece)")
                    output.append(piece)
                } else {
                    // print("Collecting: \(piece)")
                    repeatableText.append(piece)
                }
            }
        }

        return output
    }

    func repeated(times: Int) -> String {
        let pieces = Array.init(repeating: self, count: times)
        return pieces.joined()
    }

    // should handle full or partial repeat - eg: "1x2)" or "3x4)ABC"
    private func parseRepeat(_ match: RegexMatch) -> (charCount: Int, times: Int) {
        let chars = Int(match.captures[0])!
        let times = Int(match.captures[1])!
        return (chars, times)
    }

    private func expandString(_ str: String, count: Int, times: Int) -> String {
        guard count >= str.characters.count  else { print("\(str) \(count) \(times)"); return "" }
        let index = str.index(str.startIndex, offsetBy: count)
        let repeatable = str.substring(to: index)
        let suffix = str.substring(from: index)

        var expanded = repeatable.repeated(times: times)
        expanded.append(suffix)
        return expanded
    }
}

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

// MARK: - Helpers
// returns the lines out of the input file
func readInputData() -> [String] {
    guard let currentDir = ProcessInfo.processInfo.environment["PWD"] else {
        print("No current directory.")
        return []
    }

    let inputPath: String = "\(currentDir)/input.txt"
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

// ------------------------------------------------------------------
// MARK: - "MAIN()"

let lines = readInputData()
// let lines = [
//     "ADVENT",
//     "A(1x5)BC",
//     "(3x3)XYZ",
//     "A(2x2)BCD(2x2)EFG",
//     "(6x1)(1x3)A",
//     "X(8x2)(3x3)ABCY",
// ]

_ = lines.map { line in
    let de = line.decompressed()
    print(line)
    print("** BECOMES **")
    print(de)
    print("Lengths: \(de.characters.count)")
}
