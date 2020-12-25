//
//  Food.swift
//  aoc2020
//
//  Created by Shawn Veader on 12/22/20.
//

import Foundation

struct Food {
    let identifier: Int
    let ingredients: [String]
    let knownAllergens: [String]

    init?(_ input: String, id idNum: Int = 0) {
        // Example mxmxvkd kfcds sqjhc nhms (contains dairy, fish)
        let regex = "([a-z ]*?) \\(contains ([a-z, ]*?)\\)"

        guard
            let match = input.matching(regex: regex),
            let ingredientsStr = match.captures.first,
            let allergensStr = match.captures.last
            else { return nil }

        identifier = idNum
        ingredients = ingredientsStr.split(separator: " ").map(String.init)
        knownAllergens = allergensStr.split(separator: ",").map(String.init).map { $0.trimmingCharacters(in: .whitespaces) }
    }
}
