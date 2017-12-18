//
//  String.swift
//  AdventOfCode2017
//
//  Created by Shawn Veader on 12/12/17.
//  Copyright © 2017 v8logic. All rights reserved.
//

import Foundation

extension String {
    func trimmed() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }

    func centered(width: Int, filler: String = " ") -> String {
        var centeredString = self
        var isLeft = true // are we inserting the space on the left or right?

        while centeredString.count < width {
            if isLeft {
                centeredString = filler + centeredString
            } else {
                centeredString.append(filler)
            }
            isLeft = !isLeft
        }

        return centeredString
    }

    /// Assumes contents of string are hex values. Return binary representation.
    func hexAsBinary() -> String? {
        return self.map(String.init).flatMap { hexChar -> String? in
            guard let hex = Int(hexChar, radix: 16) else { return nil }

            return String(hex, radix: 2).padded(with: "0", length: 4)
        }.joined()
    }

    func padded(with padding: String, length: Int) -> String {
        var copy = self

        while copy.count < length {
            copy = padding + copy
        }

        return copy
    }
}
