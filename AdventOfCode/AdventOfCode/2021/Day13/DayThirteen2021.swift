//
//  DayThirteen2021.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/13/21.
//

import Foundation

struct DayThirteen2021: AdventDay {
    var year = 2021
    var dayNumber = 13
    var dayTitle = "Transparent Origami"
    var stars = 1

    func parse(_ input: String?) -> TransparentPaper {
        TransparentPaper.parse(input: input ?? "")
    }

    func partOne(input: String?) -> Any {
        let paper = parse(input)
        guard let fold = paper.foldInsructions.first else { return 0 }
        paper.fold(direction: fold)
        print(paper.debugDescription)
        return paper.dots.count
    }

    func partTwo(input: String?) -> Any {
        return Int.min
    }

}
