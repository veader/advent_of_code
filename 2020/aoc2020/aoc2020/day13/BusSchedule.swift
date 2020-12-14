//
//  BusSchedule.swift
//  aoc2020
//
//  Created by Shawn Veader on 12/14/20.
//

import Foundation

struct BusSchedule {
    let buses: [Int]
    let earliestDepartureTime: Int

    typealias DepartureInfo = (time: Int, bus: Int)

    func findEarliestBus(brute: Bool = false) -> DepartureInfo {
        if brute {
            return bruteForceMethod()
        } else {
            return (0,0)
        }
    }

    private func bruteForceMethod() -> DepartureInfo {
        var done = false // are we done yet?
        var time = earliestDepartureTime - 10
        var bus: Int = 0

        printBusHeader()

        while !done {
            // check each bus at the current time
            time += 1 // check next minute
            let departures = buses.map { (time % $0) == 0 }

            printDepatures(departures, at: time)

            if time > earliestDepartureTime && departures.contains(true) {
                if let idx = departures.firstIndex(of: true) {
                    bus = buses[idx]
                }

                done = true
            }
        }

        return (time, bus)
    }

    private func printBusHeader() {
        let busNames = buses.map({ "\($0)"}).joined(separator: "\t")
        print("     \t\(busNames)")
    }

    private func printDepatures(_ depatures: [Bool], at time: Int) {
        let busDepartures = depatures.map({ $0 ? "D" : "." }).joined(separator: "\t")
        print("\(time) \t\(busDepartures)")
    }
}

extension BusSchedule {
    /// Parse the input to give create a BusSchedule
    ///
    /// Format:
    /// - First line: Earliest time you can leave
    /// - Second line: List of buses (some are `x` if out of order)
    static func parse(_ input: String?) -> BusSchedule? {
        let inputLines = input?.split(separator: "\n").map(String.init)

        guard
            let lines = inputLines,
            lines.count == 2,
            let timeStr = lines.first,
            let earliestTime = Int(timeStr),
            let busesStr = lines.last
            else { return nil }

        let buses = busesStr.split(separator: ",").map(String.init).compactMap(Int.init)

        return BusSchedule(buses: buses, earliestDepartureTime: earliestTime)
    }
}
