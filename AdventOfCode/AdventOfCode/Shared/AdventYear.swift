//
//  AdventYear.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/1/21.
//

import Foundation

enum AdventYear: String, CaseIterable, Identifiable {

    case year2020 = "2020"
    case year2021 = "2021"

    var id: AdventYear { self }

    var days: [AdventDay] {
        switch self {
        case .year2021:
            return [
                DayOne2021(),
                DayTwo2021(),
            ]
        default:
            return []
        }
    }
}
