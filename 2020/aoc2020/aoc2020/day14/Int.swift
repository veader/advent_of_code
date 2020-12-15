//
//  Int.swift
//  aoc2020
//
//  Created by Shawn Veader on 12/14/20.
//

import Foundation

extension Int {
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

        print("Mask:\t\(mask)")
        print("Int:\t\(binary)")
        print("Final:\t\(finalBinary)")

        return Int(finalBinary, radix: 2) ?? 0
    }
}
