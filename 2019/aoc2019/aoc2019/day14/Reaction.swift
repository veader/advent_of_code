//
//  Reaction.swift
//  aoc2019
//
//  Created by Shawn Veader on 12/14/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import Foundation

struct Reaction {
    let inputs: [String: Int]
    let output: String
    let quantity: Int

    typealias ParserResponse = (quantity: Int, name: String)
    private static let parser: (String) -> ParserResponse? = { input -> ParserResponse? in
        let pieces = input.trimmingCharacters(in: .symbols)
            .split(separator: " ")
            .compactMap(String.init)
        guard
            pieces.count == 2,
            let quantity = Int(pieces[0])
            else { print("Parser Pieces: \(pieces)"); return nil }

        return (quantity, pieces[1])
    }

    init?(input: String) {
        // format: 12 HKGWZ, 1 GPVTF, 8 PSHF => 9 QDVJ
        let pieces = input.split(separator: "=").compactMap(String.init)

        guard
            pieces.count == 2,
            let outputResponse = Reaction.parser(pieces[1])
            else { print("Pieces: \(pieces)"); return nil }

        output = outputResponse.name
        quantity = outputResponse.quantity

        let rawInputs = pieces[0]
                            .split(separator: ",")
                            .compactMap(String.init)
                            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }

        var tmpInputs = [String: Int]()
        rawInputs.forEach { input in
            if let response = Reaction.parser(input) {
                tmpInputs[response.name] = response.quantity
            }
        }
        inputs = tmpInputs
    }
}
