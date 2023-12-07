//
//  Day6_2023.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/6/23.
//

import Foundation
import RegexBuilder

struct Day6_2023: AdventDay {
    var year = 2023
    var dayNumber = 6
    var dayTitle = "Wait For It"
    var stars = 2

    enum Day6Error: Error {
        case bsearchError
    }

    func parse(_ input: String?) -> (times: [Int]?, distances: [Int]?) {
        var times: [Int]?
        var distances: [Int]?

        let lines = (input ?? "").split(separator: "\n").map(String.init)
        for line in lines {
            let values = line.split(separator: " ").map(String.init).compactMap(Int.init)
            
            if let _ = line.firstMatch(of: /^Time:\s/) {
                times = values
            } else if let _ = line.firstMatch(of: /^Distance:\s/) {
                distances = values
            }
        }

        return (times, distances)
    }

    // original "brute force" method to find winning values
    func calculateTimes(for time: Int, beating distance: Int) -> [Int] {
        (1..<time).map({ (time - $0) * $0 }).filter { $0 > distance }
    }

    // search from ends to find range of winning values
    func calculateTimes2(for time: Int, beating distance: Int) -> Int {
        let range = 1..<time
        guard 
            let start = range.first(where: { ((time - $0) * $0) > distance }),
            let end = range.last(where: { ((time - $0) * $0) > distance })
        else {
            return -1
        }

        return (start...end).count
    }

    // binary search of the space to find range of winning values
    func calculateAdvancedTimes(for time: Int, beating distance: Int) throws -> Int {
        // do a bit of a binary search of the space to get closer before doing all the numbers...
        let mid: Int = time / 2
        let start = try binarySearchForIndex(side: .left, range: 1...(mid-1), time: time, distance: distance)
        let end = try binarySearchForIndex(side: .right, range: mid...(time-1), time: time, distance: distance)
        return (start...end).count
    }

    enum BSearchSide: String {
        case left
        case right
    }

    private func binarySearchForIndex(side: BSearchSide, range: ClosedRange<Int>, time: Int, distance: Int) throws -> Int {
        guard range.count > 3 else {
            if case .left = side {
                return range.first(where: { ((time - $0) * $0) > distance }) ?? -1
            } else {
                return range.last(where: { ((time - $0) * $0) > distance }) ?? -1
            }
        }

        let mid = range.upperBound - ((range.upperBound - range.lowerBound) / 2)
        let midDistance = (time - mid) * mid

        var newRange: ClosedRange<Int>?
        if midDistance > distance {
            // middle of the range is good, move further towards the edges
            if case .left = side {
                newRange = range.lowerBound...mid
            } else {
                newRange = mid...range.upperBound
            }
        } else {
            // middle of the range was NOT good, move further towards the middle
            if case .left = side {
                newRange = mid...range.upperBound
            } else {
                newRange = range.lowerBound...mid
            }
        }
        
        guard let newRange else {
            print("💥 Couldn't complete binary search. No new range...")
            throw Day6Error.bsearchError
        }

        return try binarySearchForIndex(side: side, range: newRange, time: time, distance: distance)
    }


    // MARK: -

    func partOne(input: String?) -> Any {
        let (times, distances) = parse(input)
        guard let times, let distances, times.count == distances.count else { return 0 }

        var counts: [Int] = []
        for (idx, time) in times.enumerated() {
            let possible = calculateTimes(for: time, beating: distances[idx])
            counts.append(possible.count)
        }

        return counts.reduce(1, *)
    }

    func partTwo(input: String?) -> Any {
        let (times, distances) = parse(input)
        guard let times, let distances else { return 0 }

        let time = Int(times.map(String.init).joined())
        let distance = Int(distances.map(String.init).joined())
        guard let time, let distance else { return 0 }

//        let possible = calculateTimes(for: time, beating: distance).count // 138s (07:27:59 -> 07:30:17)
//        let possible = calculateTimes2(for: time, beating: distance) // 13s (07:32:30 -> 07:32:43)
        let possible = (try? calculateAdvancedTimes(for: time, beating: distance)) ?? -1 // <1s (07:36:24 -> 07:36:24)

        return possible
    }
}
