//
//  DayTen.swift
//  aoc2020
//
//  Created by Shawn Veader on 12/10/20.
//

import Foundation

struct DayTen: AdventDay {
    var dayNumber: Int = 10

    func parse(_ input: String?) -> [Int] {
        (input ?? "").split(separator: "\n").map(String.init).compactMap(Int.init)
    }

    func partOne(input: String?) -> Any {
        let data = parse(input)
        let array = AdapterArray(adapters: data)
        let answer = array.adapterChain()
        return answer.deltaOne * answer.deltaThree
    }

    func partTwo(input: String?) -> Any {
        return 1
    }
}
