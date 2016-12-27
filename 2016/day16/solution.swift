#!/usr/bin/env swift

import Foundation

// ----------------------------------------------------------------------------
extension String {
    func expand() -> String {
        let backwardCharacters = self.characters.reversed().map { c in
            switch c {
            case "0":
                return "1"
            case "1":
                return "0"
            default:
                return "?"
            }
        }.joined()

        guard let tail = String(backwardCharacters) else { return "BOOM" }
        return "\(self)0\(tail)"
    }

    func checksum() -> String {
        let chunkSize = 2 // create chunks of every pair of characters
        let chars = self.characters.map { String($0) }
        let chunks: [String] = stride(from: 0, to: chars.count, by: chunkSize).map {
            String(chars[$0..<min($0 + chunkSize, chars.count)].joined())
        }

        let checksums = chunks.map { $0.characters.first == $0.characters.last ? "1" : "0" }
        return checksums.joined()
    }
}

// ----------------------------------------------------------------------------
let startingVector = "11101000110010100"
let diskSize = 35651584 // part 1: 272

// ----------------------------------------------------------------------------
print("Input: \(startingVector)")
print("Disk Size: \(diskSize)\n")

var diskFiller = startingVector
while diskFiller.characters.count < diskSize {
    diskFiller = diskFiller.expand()
}

if diskFiller.characters.count > diskSize {
    let endIndex = diskFiller.index(diskFiller.startIndex, offsetBy: diskSize)
    diskFiller = diskFiller.substring(to: endIndex)
}

if (diskSize < 1024) {
    print("We have \(diskFiller.characters.count) characters in: \(diskFiller)\n")
}

var fillerChecksum = diskFiller.checksum()
while fillerChecksum.characters.count % 2 == 0 {
    fillerChecksum = fillerChecksum.checksum()
}
print("Checksum has \(fillerChecksum.characters.count) characters in: \(fillerChecksum)")
