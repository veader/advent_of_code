#!/usr/bin/env swift

import Foundation

struct Coordinate {
    let x: Int
    let y: Int
}

struct LCDScreen {
    enum PixelState: Int {
        case off = 0
        case on = 1
    }

    var pixels: [[PixelState]]
    let width: Int
    let height: Int

    init(width w: Int, height h: Int) {
        width = w
        height = h
        pixels = Array.init(repeating: Array.init(repeating: .off, count: height), count: width)
    }

    func row(_ y: Int) -> [PixelState] {
        return (0..<width).map { pixel(at: Coordinate(x: $0, y: y)) }
    }

    func column(_ x: Int) -> [PixelState] {
        return (0..<height).map { pixel(at: Coordinate(x: x, y: $0)) }
    }

    func pixel(at coord: Coordinate) -> PixelState {
        return pixels[coord.x][coord.y]
    }

    func pixelsOn() -> Int {
        return (0..<height).reduce(0) { colSum, y in
            colSum + row(y).reduce(0) { rowSum, pixel in
                rowSum + (pixel == .on ? 1 : 0 )
            }
        }
    }

    mutating func setPixel(_ state: PixelState, at coord: Coordinate) {
        pixels[coord.x][coord.y] = state
    }

    mutating func turnOnRect(width: Int, height: Int) {
        _ = (0..<width).map { x in
            _ = (0..<height).map { y in
                setPixel(.on, at: Coordinate(x: x, y: y))
            }
        }
    }

    mutating func rotateRow(_ y: Int, by offset: Int) {
        let rowPixels = row(y)
        let shiftedRowPixels = rowPixels.shifted(by: offset)
        _ = shiftedRowPixels.enumerated().map { idx, state in
            setPixel(state, at: Coordinate(x: idx, y: y))
        }
    }

    mutating func rotateColumn(_ x: Int, by offset: Int) {
        let colPixels = column(x)
        let shiftedColPixels = colPixels.shifted(by: offset)
        _ = shiftedColPixels.enumerated().map { idx, state in
            setPixel(state, at: Coordinate(x: x, y: idx))
        }
    }

    mutating func parse(_ instruction: String) {
        // http://rubular.com/r/A3gzZ2ASfp
        let rectRegEx = "rect (\\d+)x(\\d+)"
        // http://rubular.com/r/wVrlexHRBb
        let rotateRegEx = "rotate (row|column) (x|y)=(\\d+) by (\\d+)"

        if let matches = instruction.matches(regex: rectRegEx) {
            guard let match = matches.first else { return }

            let rectWidth  = Int(match.captures[0])!
            let rectHeight = Int(match.captures[1])!

            turnOnRect(width: rectWidth, height: rectHeight)
        } else if let matches = instruction.matches(regex: rotateRegEx) {
            guard let match = matches.first else { return }

            let coordinate = Int(match.captures[2])!
            let offset = Int(match.captures[3])!
            let rotationAxis = match.captures.first! // row or column

            switch rotationAxis {
            case "row":
                rotateRow(coordinate, by: offset)
            case "column":
                rotateColumn(coordinate, by: offset)
            default:
                print("Unknown rotation axis")
            }
        } else {
            print("Unknown instruction: '\(instruction)'")
        }
    }
}

extension LCDScreen: CustomDebugStringConvertible {
    var debugDescription: String {
        var pixelDisplay = ""

        _ = (0..<height).map { y in
            let rowChars = row(y).map { $0.debugDescription }
            pixelDisplay.append(rowChars.joined())
            pixelDisplay.append("\n")
        }

        return pixelDisplay
    }
}

extension LCDScreen.PixelState: CustomDebugStringConvertible {
    var debugDescription: String {
        switch self {
        case .on:
            return "#"
        case .off:
            return "."
        }
    }
}

extension Array {
    func shifted(by: Int) -> Array<Element> {
        var shiftedOutput = self
        _ = self.enumerated().map { idx, value in
            let newIndex = (idx + by) % self.count
            shiftedOutput[newIndex] = value
        }
        return shiftedOutput
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
let instructions = lines

var display = LCDScreen.init(width: 50, height: 6)

print(display)
print("\n")

_ = instructions.map { instruction in
    print(instruction)
    display.parse(instruction)
    print(display)
}

print("\(display.pixelsOn()) Pixels On")
