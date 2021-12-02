//
//  DayTen.swift
//  aoc2020
//
//  Created by Shawn Veader on 12/10/20.
//

import Foundation

struct DayTen2020: AdventDay {
    var year = 2020
    var dayNumber = 10
    var dayTitle = "Adapter Array"
    var stars = 1

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
        print(Date())
        let data = parse(input)
        let array = AdapterArray(adapters: data)
        let result = array.possibleAdapterConfigurations()
        print(Date())
        return result
    }
}
