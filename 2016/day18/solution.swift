#!/usr/bin/env swift

import Foundation

extension String {
    func substring(from: Int, length: Int) -> String? {
        let subStartIndex = self.index(self.startIndex, offsetBy: from)
        guard let subEndIndex = self.index(subStartIndex, offsetBy: length, limitedBy: self.endIndex) else { return nil }
        return self[subStartIndex..<subEndIndex]
    }
}

enum TileState: String {
    case safe = "."
    case trap = "^"
}

struct TileFloor {
    var floorTiles: [String]

    init(startingRow: String) {
        floorTiles = [startingRow]
    }

    mutating func calculateRow(_ index: Int) {
        let previousRow = floorTiles[index - 1]
        var tiles = [TileState]()

        var firstTileInput: String! = String(TileState.safe.rawValue)
        firstTileInput.append(previousRow.substring(from: 0, length: 2)!)
        tiles.append(tile(firstTileInput))

        let chunkSize = 3 // create chunks of every 3 tiles
        _ = (0...(previousRow.characters.count - chunkSize)).map {
            guard let chunk = previousRow.substring(from: $0, length: chunkSize) else { return }
            tiles.append(tile(chunk))
        }

        var lastTileInput: String! = previousRow.substring(from: previousRow.characters.count - 2, length: 2)
        lastTileInput.append(TileState.safe.rawValue)
        tiles.append(tile(lastTileInput))

        let thisRow: String = tiles.map { $0.rawValue }.joined()
        floorTiles.append(thisRow)
    }

    func tile(_ input: String) -> TileState {
        if isTrap(input) {
            return .trap
        } else {
            return .safe
        }
    }

    func isTrap(_ input: String) -> Bool {
        let leftTile   = TileState(rawValue: input.substring(from: 0, length: 1)!)!
        let centerTile = TileState(rawValue: input.substring(from: 1, length: 1)!)!
        let rightTile  = TileState(rawValue: input.substring(from: 2, length: 1)!)!

        if leftTile == .trap && centerTile == .trap && rightTile == .safe {
            return true
        } else if centerTile == .trap && rightTile == .trap && leftTile == .safe {
            return true
        } else if leftTile == .trap && centerTile == .safe && rightTile == .safe {
            return true
        } else if leftTile == .safe && centerTile == .safe && rightTile == .trap {
            return true
        } else {
            return false
        }
    }

    func safeTiles() -> Int {
        return floorTiles.reduce(0) { safeSum, row in
            safeSum + safeTiles(in: row)
        }
    }

    func safeTiles(in row: String) -> Int {
        let safe = row.characters.flatMap { char in
            return String(char) == TileState.safe.rawValue ? "." : nil
        }
        return safe.count
    }
}

extension TileFloor: CustomDebugStringConvertible {
    var debugDescription: String {
        var desc = "TileFloor(\n"
        floorTiles.forEach { row in
            desc.append("\(row)\n")
        }
        desc.append(")")
        return desc
    }
}

// ----------------------------------------------------------------------------

let initialRow = ".^^^^^.^^.^^^.^...^..^^.^.^..^^^^^^^^^^..^...^^.^..^^^^..^^^^...^.^.^^^^^^^^....^..^^^^^^.^^^.^^^.^^"
let rowCount = 400000 // 40 for part 1
// "..^^." // 3 rows
// ".^^.^.^^^^" // 10 rows

var floor = TileFloor.init(startingRow: initialRow)
(1..<rowCount).forEach { floor.calculateRow($0) }

if rowCount < 50 {
    print(floor)
}


print("\(floor.safeTiles()) safe tiles")
