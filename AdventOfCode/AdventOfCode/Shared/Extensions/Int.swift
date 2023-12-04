//
//  Int.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/11/22.
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

    /// A quick hack to find some of the first few prime factors of this integer.
    ///
    /// - Note: This only covers 2 -> 23 by default for speed and simplicity purposes.
    ///
    /// - Parameters:
    ///     - factorSet: `[Int]` - A list of the first few factors to consider. Intentionally limiting.
    ///
    /// - Returns: Common prime factors found for this number.
    func partialPrimeFactors(factorSet: [Int] = [2,3,5,7,11,13,17,19,23]) -> [Int] {
        factorSet.filter { self % $0 == 0 }
    }

    /// Get the result of this number by the power given.
    /// ie: 2^2 = 4 -> 2.power(of: 2) = 4
    ///
    /// - Parameters:
    ///     - power: `Int` - Power component of the equation
    ///
    /// - Returns: `Double` of the current number raised to the given power. Only double to account for negative values.
    func power(of power: Int) -> Double {
        pow(Double(self), Double(power))
    }
}
