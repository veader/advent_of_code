//
//  DaySixteen2021.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/16/21.
//

import Foundation

struct DaySixteen2021: AdventDay {
    var year = 2021
    var dayNumber = 16
    var dayTitle = "Packet Decoder"
    var stars = 2

    func partOne(input: String?) -> Any {
        let tx = BITSTransmission(hex: input ?? "")
        tx.parse()
        return tx.packetVersionSum()
    }

    func partTwo(input: String?) -> Any {
        let tx = BITSTransmission(hex: input ?? "")
        tx.parse()
        return tx.packetComputedValue()
    }
}
