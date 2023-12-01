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
    case year2022 = "2022"
    case year2023 = "2023"

    var id: AdventYear { self }

    var days: [any AdventDay] {
        switch self {
        case .year2022:
            return [
                DayOne2022(),
                DayTwo2022(),
                DayThree2022(),
                DayFour2022(),
                DayFive2022(),
                DaySix2022(),
                DaySeven2022(),
                DayEight2022(),
                DayNine2022(),
                DayTen2022(),
                DayEleven2022(),
                DayTwelve2022(),
                DayThirteen2022(),
                DayFourteen2022(),
                DayFifteen2022(),
                DaySixteen2022(),
            ]
        case .year2021:
            return [
                DayOne2021(),
                DayTwo2021(),
                DayThree2021(),
                DayFour2021(),
                DayFive2021(),
                DaySix2021(),
                DaySeven2021(),
                DayEight2021(),
                DayNine2021(),
                DayTen2021(),
                DayEleven2021(),
                DayTwelve2021(),
                DayThirteen2021(),
                DayFourteen2021(),
                DayFifteen2021(),
                DaySixteen2021(),
                DavSeventeen2021(),
                DayEighteen2021(),
                DayNineteen2021(),
                DayTwenty2021(),
                DayTwentyOne2021(),
                DayTwentyTwo2021(),
                DayTwentyThree2021(),
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
        case .year2023:
            return [
                Day1_2023(),
            ]
//        default:
//            return []
        }
    }
}
