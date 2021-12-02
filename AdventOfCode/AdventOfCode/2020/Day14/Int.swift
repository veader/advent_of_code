//
//  Int.swift
//  aoc2020
//
//  Created by Shawn Veader on 12/14/20.
//

import Foundation

extension Int {
    /// Apply the given "bit mask" to our value and return the resulting value.
    ///
    /// - Note: `mask` is in form of `01X` where:
    ///     - `0` replaces bit value with `0`
    ///     - `1` replaces bit value with `1`
    ///     - `X` keeps existing bit value
    ///
    /// - Returns: New `Int` value after mask is applied.
    func applying(mask: String) -> Int {
        let maskSize = mask.count
        let maskArray = mask.map(String.init)

        let binary = String(self, radix: 2).padded(with: "0", length: maskSize)

        let finalBinary = binary.enumerated().map({ idx, bit -> String in
            let maskBit = maskArray[idx]
            switch maskBit {
            case "1":
                return "1"
            case "0":
                return "0"
            case "X":
                return String(bit)
            default:
                print("Huh: \(maskBit) @ \(idx) -> \(bit)")
                return String(bit)
            }
        }).joined()

//        print("Mask:\t\(mask)")
//        print("Int:\t\(binary)")
//        print("Final:\t\(finalBinary)")

        return Int(finalBinary, radix: 2) ?? 0
    }

    /// Create a string representation applying the given mask.
    ///
    /// - Note: `mask` in in format of `01X` where:
    ///     - `0` preserves existing bit value
    ///     - `1` replaces bit value with `1`
    ///     - `X` replaces bit value with `X` (for floating value)
    ///
    /// - Returns: Masked `String` value. **Not** a pure binary representation as the `X` bits of the mask persist.
    func masked(with mask: String) -> String {
        let maskSize = mask.count
        let maskArray = mask.map(String.init)

        let binary = String(self, radix: 2).padded(with: "0", length: maskSize)

        let finalBinary = binary.enumerated().map({ idx, bit -> String in
            let maskBit = maskArray[idx]
            switch maskBit {
            case "1":
                return "1"
            case "0":
                return String(bit)
            case "X":
                return "X"
            default:
                print("Huh: \(maskBit) @ \(idx) -> \(bit)")
                return String(bit)
            }
        }).joined()

//        print("Mask:\t\(mask)")
//        print("Int:\t\(binary)")
//        print("Final:\t\(finalBinary)")

        return finalBinary
    }
}
