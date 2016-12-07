#!/usr/bin/env swift

import Foundation

// MARK: - Location
struct Location {
    var x: Int
    var y: Int

    mutating func incrementX(by amount: Int = 1) {
        x = x + amount
    }

    mutating func incrementY(by amount: Int = 1) {
        y = y + amount
    }
}

extension Location: Equatable {}
func ==(lhs: Location, rhs: Location) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
}


// MARK: - Direction
enum Direction: String {
    case up = "U"
    case down = "D"
    case left = "L"
    case right = "R"
}


// MARK: - KeyPad
struct KeyPad {
    let pad = [[1, 4, 7], [2, 5, 8], [3, 6, 9]]
    var position: Location

    let minIndex = 0
    let maxIndex = 2

    init() {
        position = Location(x: 1, y: 1)
    }

    func key(for location: Location) -> Int {
        return pad[location.y][location.x]
    }

    func currentKey() -> Int {
        return key(for: position)
    }

    mutating func move(_ direction: Direction) {
        // print("Moving: \(direction)")
        switch direction {
        case .up:
            position.incrementX(by: -1)
        case .down:
            position.incrementX(by: 1)
        case .left:
            position.incrementY(by: -1)
        case .right:
            position.incrementY(by: 1)
        }

        validatePosition()
    }

    private mutating func validatePosition() {
        if position.x < minIndex {
            position.x = minIndex
        } else if position.x > maxIndex {
            position.x = maxIndex
        }

        if position.y < minIndex {
            position.y = minIndex
        } else if position.y > maxIndex {
            position.y = maxIndex
        }
    }
}

extension KeyPad: CustomDebugStringConvertible {
    var debugDescription: String {
        var keypadString = ""
        for x in minIndex...maxIndex {
            for y in minIndex...maxIndex {
                let keyLocation = Location(x: x, y: y)
                let value = key(for: keyLocation)

                if position == keyLocation {
                  keypadString = "\(keypadString) [\(value)]"
                } else if position.y == keyLocation.y {
                  keypadString = "\(keypadString)  \(value) "
                } else {
                  keypadString = "\(keypadString) \(value)"
                }
            }
            keypadString = keypadString + "\n"
        }
        return keypadString
    }
}


// ------------------------------------------------------------------
// MARK: - "MAIN()"
guard let currentDir = ProcessInfo.processInfo.environment["PWD"] else {
    print("No current directory.")
    exit(1)
}

let inputPath: String = "\(currentDir)/input.txt"
let data = try String(contentsOfFile: inputPath, encoding: .utf8)

var keypad = KeyPad()
// print("Start: ")
// print(keypad)
var passcode: [Int] = [Int]()

let lines = data.components(separatedBy: "\n")
for line in lines {
    guard line.characters.count > 0 else { continue }
    // print("-----------------------------")
    for char in line.characters {
        guard let direction = Direction(rawValue: "\(char)") else {
            print("Unknown direction: '\(char)'")
            continue
        }
        keypad.move(direction)
        // print(keypad)
    }
    print("Line Finished:")
    print(keypad)
    passcode.append(keypad.currentKey())
    print("-----------------------------")
}

print("Bathroom Code: " + passcode.map { String($0) }.joined())
