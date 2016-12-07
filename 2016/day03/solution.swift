#!/usr/bin/env swift

import Foundation


struct Triangle {
    let sides: [Int]

    init(description: String) {
        let sideLengths = description.components(separatedBy: " ")
                                     .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                                     .flatMap { Int($0) }
                                     .sorted()
        sides = sideLengths
    }

    func valid() -> Bool {
        guard sides.count >= 3 else { return false }
        guard sides[0] + sides[1] > sides[2] else { return false }
        return true
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

var validTriangles = [Triangle]()

let lines = data.components(separatedBy: "\n")
for line in lines {
    let tri = Triangle.init(description: line)
    if tri.valid() {
        validTriangles.append(tri)
    }
}

print("Valid Triangle Count: \(validTriangles.count)")
