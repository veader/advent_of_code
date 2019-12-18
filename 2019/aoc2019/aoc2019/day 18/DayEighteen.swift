//
//  DayEighteen.swift
//  aoc2019
//
//  Created by Shawn Veader on 12/18/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import Foundation

struct DayEighteen: AdventDay {
    var dayNumber: Int = 18

    // func parse(_ input: String?) -> FOO { return FOO... }

    func partOne(input: String?) -> Any {
        let vault = Vault(input: input ?? "")
        vault.searchForAllKeys()
        return 0
    }

    func partTwo(input: String?) -> Any {
        return 0
    }
}
