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
                DayThree2021(),
            ]
        case .year2020:
            return [
                DayOne2020(),
                DayTwo2020(),
                DayThree2020(),
                DayFour2020(),
                DayFive2020(),
                DaySix2020(),
                DaySeven2020(),
                DayEight2020(),
                DayNine2020(),
                DayTen2020(),
                DayEleven2020(),
                DayTwelve2020(),
                DayThirteen2020(),
                DayFourteen2020(),
                DayFifteen2020(),
                DaySixteen2020(),
                DaySeventeen2020(),
                DayEighteen2020(),
                DayNineteen2020(),
                DayTwenty2020(),
                DayTwentyOne2020(),
                DayTwentyTwo2020(),
            ]
//        default:
//            return []
        }
    }
}
