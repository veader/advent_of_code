#!/usr/bin/env swift

import Foundation

extension String {
    func decompressed(writeToFile: Bool = true) -> String {
        var file: FileHandle?

        if writeToFile {
            guard let currentDir = ProcessInfo.processInfo.environment["PWD"] else { print("No current directory."); return "" }
            let outputPath = "\(currentDir)/output.txt"
            guard let fileHandle = FileHandle(forWritingAtPath: outputPath) else { print("Can't open file for output"); return "" }
            file = fileHandle
        }

        let chunks = splitCompressedChunks(String.init(self))
        let expandedChunks = chunks.flatMap { chunk -> String? in
            if let expanded = processCompressedChunk(chunk) {
                if writeToFile {
                    if let data = expanded.data(using: .utf8) {
                        file?.write(data)
                    }
                    return nil // don't collect and grow memory footprint
                }

                return expanded
            }

            return nil
        }

        file?.closeFile()
        return expandedChunks.joined()
    }

    struct RepeatChunk {
        let charCount: Int
        let repeatCount: Int
        let text: String

        var isValid: Bool {
            return text.characters.count == charCount
        }
    }

    private func splitCompressedChunks(_ input: String) -> [RepeatChunk] {
        // http://rubular.com/r/k6XJd3VR3R
        let repeatInstructionRegex = "^(.*?)\\((\\d+)x(\\d+)\\)"

        var chunks = [RepeatChunk]()
        var processingText = input

        while let matches = processingText.matches(regex: repeatInstructionRegex) {
            guard let match = matches.first else { print("MATCH?!?"); break }

            let matchedString = match.match

            // ABC(3x2)DEFGHIJK(2x1)
            //  ^  ^ ^ ^  ^
            //  |  | | |  +- endIndex
            //  |  | | +---- startIndex
            //  |  | +------ repeatCount
            //  |  +-------- charCount
            //  +----------- prefixString

            let prefixString: String! = match.captures[0]
            if !prefixString.isEmpty {
                chunks.append(RepeatChunk(charCount:prefixString.characters.count, repeatCount:1, text: prefixString))
            }

            let charCount: Int! = Int.init(match.captures[1])
            let repeatCount: Int! = Int.init(match.captures[2])

            let startIndex = processingText.index(processingText.startIndex, offsetBy: matchedString.characters.count)
            let endIndex = processingText.index(startIndex, offsetBy: charCount)
            let compressedString = processingText.substring(with: startIndex..<endIndex)

            let chunk = RepeatChunk(charCount: charCount, repeatCount: repeatCount, text: compressedString)
            chunks.append(chunk)

            processingText = processingText.substring(from: endIndex)
        }

        if !processingText.isEmpty {
            chunks.append(RepeatChunk(charCount:processingText.characters.count, repeatCount:1, text: processingText))
        }

        return chunks
    }

    private func processCompressedChunk(_ chunk: RepeatChunk) -> String? {
        guard chunk.isValid else { print("Invalid Chunk: \(chunk)"); return nil }

        if !chunk.text.contains("(") {
            // we've reached the bottom
            return chunk.text.repeated(times: chunk.repeatCount)
        }

        let subChunks = splitCompressedChunks(chunk.text)
        let uncompressedChunks = subChunks.flatMap {
            return processCompressedChunk($0)
        }

        return uncompressedChunks.joined().repeated(times: chunk.repeatCount)
    }

    func repeated(times: Int) -> String {
        let pieces = Array.init(repeating: self, count: times)
        return pieces.joined()
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

let output = line.decompressed()
print("Use: 'wc -c output.txt' for final answer")
