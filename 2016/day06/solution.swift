#!/usr/bin/env swift

import Foundation

extension String {
    func histogram() -> [(key: String, value: Int)] {
        var histogramData = [String: Int]()

        _ = characters.map { String($0) }
                      .filter { $0 != "-"}
                      .map { letter in
            let count = histogramData[letter] ?? 0
            histogramData[letter] = count + 1
        }

        let sortedHistogramData = histogramData.sorted {
            // value is our count
            if $0.value > $1.value {
                return true
            } else if $0.value < $1.value {
                return false
            } else { // ==
                return $0.key < $1.key
            }
        }

        return sortedHistogramData
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
guard let firstLine = lines.first else { print("WHAT?!?"); exit(1) }

let passwordLength = firstLine.characters.count

let columns = (0..<passwordLength).map { indexOffset in
    return lines.map { line in
        let index = line.index(line.startIndex, offsetBy: indexOffset)
        return String(line.characters[index])
    }.joined()
}

let password = columns.flatMap { column in
    guard let maxChar = column.histogram().first else { return nil }
    return maxChar.key
}.joined()

print("Password: \(password)")
