#!/usr/bin/env swift

import Foundation

extension String {
    func decompressed() -> String {
        // http://rubular.com/r/k6XJd3VR3R
        let repeatInstructionRegex = "^(.*?)\\((\\d+)x(\\d+)\\)"

        guard let currentDir = ProcessInfo.processInfo.environment["PWD"] else { print("No current directory."); return "" }
        let outputPath = "\(currentDir)/output.txt"
        guard let file = FileHandle(forWritingAtPath: outputPath) else { print("Can't open file for output"); return "" }

        var processingText: String! = String.init(self)
        var data: Data!

        while let matches = processingText.matches(regex: repeatInstructionRegex) {
            guard let match = matches.first else { print("MATCH?!?"); break }

            let matchedString = match.match
            let prefixString: String! = match.captures[0]

            // ABC(3x2)DEFGHIJK(2x1)
            //  ^  ^ ^ ^  ^
            //  |  | | |  +- endIndex
            //  |  | | +---- startIndex
            //  |  | +------ repeatCount
            //  |  +-------- charCount
            //  +----------- prefixString
            data = prefixString.data(using: .utf8)
            file.write(data)

            let charCount: Int! = Int.init(match.captures[1])
            let repeatCount: Int! = Int.init(match.captures[2])

            let startIndex = processingText.index(processingText.startIndex, offsetBy: matchedString.characters.count)
            let endIndex = processingText.index(startIndex, offsetBy: charCount)
            let compressedString = processingText.substring(with: startIndex..<endIndex)
            let restOfString = processingText.substring(from: endIndex)

            processingText = compressedString.repeated(times: repeatCount)
            processingText.append(restOfString)
        }

        data = processingText.data(using: .utf8)
        file.write(data)

        file.closeFile()

        return ""
    }

    func repeated(times: Int) -> String {
        let pieces = Array.init(repeating: self, count: times)
        return pieces.joined()
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

// ------------------------------------------------------------------
// MARK: - "MAIN()"

let lines = readInputData()
guard let line = lines.first else { print("NO INPUT"); exit(3) }

// let line = "X(8x2)(3x3)ABCY"
// XABCABCABCABCABCABCY <- from solution
// XABCABCABCABCABCABCY <- from example

_ = line.decompressed()
// wc -c output.txt for final answer
