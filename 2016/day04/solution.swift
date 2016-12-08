#!/usr/bin/env swift

import Foundation

// MARK: - Extensions
extension Sequence where Iterator.Element == String {
    func unique() -> [String] {
        return Array(Set(self))
    }
}

extension String {
    func matches(regex: String) -> (match: String, captures: [String])? {
        do {
            let regex = try NSRegularExpression(pattern: regex, options: .caseInsensitive)

            let wholeThing = NSMakeRange(0, characters.count)
            let regexMatches = regex.matches(in: self, options: .withoutAnchoringBounds, range: wholeThing)
            if let match = regexMatches.first {
                var captures = [String]()

                for index in 0..<match.numberOfRanges {
                    let range = match.rangeAt(index)
                    if let _ = range.toRange() {
                        captures.append((self as NSString).substring(with: range))
                    }
                }

                // the 0 index is the whole string that matches
                let matching = captures.removeFirst()

                return (matching, captures)
            }
        } catch {
            return nil
        }
        return nil
    }
}

// MARK: - Room
struct Room {
    // http://rubular.com/r/CQENeQAMtX
    let encryptedNamePattern = "([a-z0-9\\-]+)\\-([0-9]+)\\[([a-z]+)\\]"

    let encryptedName: String

    init(name: String) {
        encryptedName = name
    }

    func decrypt() -> String? {
        guard let name = name() else { return nil }
        guard let sector = sector() else { return nil }

        let decryptedText = name.utf16.map { char in
          if char == 45 {
              return " " // "-" turns into a space
          } else {
              // a == 97
              let decryptedValue = (((Int(char) - 97) + sector) % 26) + 97
              return String(Character(UnicodeScalar(decryptedValue)!))
          }
        }.joined()

        print("Encrypted: \(name) | Decrypted: \(decryptedText) | Sector: \(sector)")

        return decryptedText
    }

    func letters() -> [String] {
        guard let name = name() else { return [] }

        let letters = name.characters.map { String($0) }
                          .unique()
                          .sorted()
                          .filter { $0 != "-" }
        return letters
    }

    private func histogram(_ input: String? = nil) -> [String: Int] {
        var histogramData = [String: Int]()

        if let data = input ?? name() {
            _ = data.characters.map { String($0) }
                               .filter { $0 != "-"}
                               .map { letter in
                let count = histogramData[letter] ?? 0
                histogramData[letter] = count + 1
            }
        }

        return histogramData
    }

    func name() -> String? {
        guard let match = encryptedName.matches(regex: encryptedNamePattern) else { return nil }
        return match.captures.first
    }

    func sector() -> Int? {
        guard let match = encryptedName.matches(regex: encryptedNamePattern) else { return nil }
        return Int(match.captures[1])
    }

    func checksum() -> String? {
        guard let match = encryptedName.matches(regex: encryptedNamePattern) else { return nil }
        return match.captures.last
    }

    func calculatedChecksum(_ input: String? = nil) -> String? {
      let hist = histogram(input)
      let sortedLetters = hist.sorted {
          // value is our count
          if $0.value > $1.value {
              return true
          } else if $0.value < $1.value {
              return false
          } else { // ==
              return $0.key < $1.key
          }
      }

      let fullChecksum = sortedLetters.map { $0.key }.joined()
      let endingIndex = fullChecksum.index(fullChecksum.startIndex, offsetBy: 5)
      let checksum = fullChecksum.substring(to: endingIndex)
      return checksum
    }

    func valid() -> Bool {
        guard let checksum = checksum() else { return false }

        let calculated = calculatedChecksum()
        return calculated == checksum
    }
}

extension Room: CustomDebugStringConvertible {
    var debugDescription: String {
        return "Room( encrypted: '\(encryptedName)', valid: \(valid())) )"
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
let rooms = lines.map { Room(name: $0) }

let validRooms = rooms.filter { $0.valid() }
print("Valid Rooms: \(validRooms.count)")

let roomSectors = validRooms.flatMap { $0.sector() }
let sectorSum = roomSectors.reduce(0, { $0 + $1 })
print("Sector Sum: \(sectorSum)")

_ = validRooms.map { $0.decrypt() }
