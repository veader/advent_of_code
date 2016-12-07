#!/usr/bin/env swift

import Foundation


struct Triangle {
    let sides: [Int]

    func valid() -> Bool {
        guard sides.count >= 3 else { return false }

        let sorted = sides.sorted()
        guard sorted[0] + sorted[1] > sorted[2] else { return false }

        return true
    }

    static func parse(_ input: [String]) -> [Triangle] {
        var triangles = [Triangle]()

        let sidesRows = input.map { parseSide($0) }
        guard sidesRows.count >= 3 else { return triangles }

        for x in 0..<3 {
            let sides = sidesRows.map { $0[x] }
            triangles.append(Triangle(sides: sides))
        }

        return triangles
    }

    static func parseSide(_ input: String) -> [Int] {
        let sideLengths = input.components(separatedBy: " ")
                               .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                               .flatMap { Int($0) }
        return sideLengths
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

let lines = data.components(separatedBy: "\n")

let chunkSize = 3 // create chunks of every 3 lines
let chunks: [[String]] = stride(from: 0, to: lines.count, by: chunkSize).map {
    Array(lines[$0..<min($0 + chunkSize, lines.count)])
}

let triangles: [Triangle] = chunks.flatMap { Triangle.parse($0) }
let validTriangles = triangles.filter { $0.valid() }

print("Valid Triangle Count: \(validTriangles.count)")
