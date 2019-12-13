//
//  ThreeDimPosition.swift
//  aoc2019
//
//  Created by Shawn Veader on 12/12/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import Foundation

struct ThreeDimPosition: Equatable, Hashable {
    let x: Int
    let y: Int
    let z: Int

    func applying(change: ThreeDimPosition) -> ThreeDimPosition {
        ThreeDimPosition(x: x + change.x, y: y + change.y, z: z + change.z)
    }
}

extension ThreeDimPosition {
    init?(input: String) {
        // input must be in the form: <x=17, y=-12, z=13>
        let coordinates = input.trimmingCharacters(in: CharacterSet(charactersIn: "<>"))
                            .split(separator: ",")
                            .map(String.init)
                            .map { $0.trimmingCharacters(in: .whitespaces) }

        let dimensions = coordinates.compactMap { coordString -> (name: String, value: Int)? in
            let pieces = coordString.split(separator: "=")
            guard
                pieces.count == 2,
                let value = Int(String(pieces[1]).trimmingCharacters(in: .whitespaces))
                else { return nil }
            return (String(pieces[0]), value)
        }

        guard
            let xDim = dimensions.first(where: { $0.name == "x" }),
            let yDim = dimensions.first(where: { $0.name == "y" }),
            let zDim = dimensions.first(where: { $0.name == "z" })
            else { return nil }

        x = xDim.value
        y = yDim.value
        z = zDim.value
    }
}

extension ThreeDimPosition: CustomStringConvertible {
    var description: String {
        return "<x=\(x), y=\(y), z=\(z)>"
    }
}
