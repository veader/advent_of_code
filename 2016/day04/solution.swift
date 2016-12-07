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
    var decryptedName: String?

    init(name: String) {
        encryptedName = name
    }

    func decrypt(name: String) -> String {
        return ""
    }

    func letters() -> [String] {
        guard let name = name() else { return [] }

        let letters = name.characters.map { String($0) }
                          .unique()
                          .sorted()
                          .filter { $0 != "-" }
        return letters
    }

    func histogram() -> [String: Int] {
        var histogram = [String: Int]()

        if let name = name() {
            _ = name.characters.map { String($0) }
                               .filter { $0 != "-"}
                               .map { letter in
                let count = histogram[letter] ?? 0
                histogram[letter] = count + 1
            }
        }

        return histogram
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

    func valid() -> Bool {
        guard let checksum = checksum() else { return false }

        let hist = histogram()
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
        let calculatedChecksum = fullChecksum.substring(to: fullChecksum.index(fullChecksum.startIndex, offsetBy: 5))

        return calculatedChecksum == checksum
    }
}

extension Room: CustomDebugStringConvertible {
    var debugDescription: String {
        return "Room( encrypted: '\(encryptedName)', decrypted: '\(decryptedName ?? "")', valid: \(valid())) )"
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
