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

    mutating func setPixel(_ state: PixelState, at coord: Coordinate) {
        pixels[coord.x][coord.y] = state
    }

    func pixel(at coord: Coordinate) -> PixelState {
        return pixels[coord.x][coord.y]
    }
}

extension LCDScreen: CustomDebugStringConvertible {
    var debugDescription: String {
        var pixelDisplay = ""

        _ = (0..<height).map { y in
            _ = (0..<width).map { x in
                let coord = Coordinate(x: x, y: y)
                let state = pixel(at: coord)
                switch state {
                case .on:
                    pixelDisplay.append("#")
                case .off:
                    pixelDisplay.append(".")
                }
            }
            pixelDisplay.append("\n")
        }

        return pixelDisplay
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

// let lines = readInputData()
var display = LCDScreen.init(width: 10, height: 5)

display.setPixel(.on, at: Coordinate(x: 0, y: 0))
display.setPixel(.on, at: Coordinate(x: 1, y: 1))
display.setPixel(.on, at: Coordinate(x: 1, y: 2))
display.setPixel(.on, at: Coordinate(x: 1, y: 3))

print(display)
