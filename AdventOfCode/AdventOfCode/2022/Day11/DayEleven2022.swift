//
//  DayEleven2022.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/10/22.
//

import Foundation

struct DayEleven2022: AdventDay {
    var year = 2022
    var dayNumber = 11
    var dayTitle = "Monkey in the Middle"
    var stars = 1

    func partOne(input: String?) -> Any {
        let sim = MonkeySim(monkeys: MonkeySim.parse(input ?? ""))
        sim.run(rounds: 20)

        let sortedMonkeys = sim.monkeys.sorted(by: { $0.inspectionCount > $1.inspectionCount })

        return sortedMonkeys[0].inspectionCount * sortedMonkeys[1].inspectionCount
    }

    func partTwo(input: String?) -> Any {
        return 0
    }
}
