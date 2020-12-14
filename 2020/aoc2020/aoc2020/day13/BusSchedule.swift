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
    let offsetIndex: [Int]

    typealias DepartureInfo = (time: Int, bus: Int)

    func findEarliestBus() -> DepartureInfo {
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

        let busDetails = parseBusDetails(busesStr)

        return BusSchedule(buses: busDetails.buses, earliestDepartureTime: earliestTime, offsetIndex: busDetails.offsets)
    }

    /// Parse the input to give create a BusSchedule
    ///
    /// Format:
    /// - First line: List of buses (some are `x` if out of order)
    static func parseBuses(_ input: String?) -> BusSchedule? {
        guard let input = input else { return nil }

        let busDetails = parseBusDetails(input)
        return BusSchedule(buses: busDetails.buses, earliestDepartureTime: 0, offsetIndex: busDetails.offsets)
    }

    private static func parseBusDetails(_ input: String) -> (buses: [Int], offsets: [Int]) {
        var buses = [Int]()
        var busIndexes = [Int]()
        input.split(separator: ",").map(String.init).enumerated().forEach { (idx, busIDStr) in
            if let busID = Int(busIDStr) {
                buses.append(busID)
                busIndexes.append(idx)
            }
        }

        return (buses, busIndexes)
    }
}
