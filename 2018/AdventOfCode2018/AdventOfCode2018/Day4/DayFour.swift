//
//  DayFour.swift
//  AdventOfCode2018
//
//  Created by Shawn Veader on 12/3/18.
//  Copyright © 2018 Shawn Veader. All rights reserved.
//

import Foundation

struct DayFour: AdventDay {

    enum ShiftEvent {
        case start(guardID: Int)
        case fellAsleep
        case wokeUp

        static func parse(event: String) -> ShiftEvent? {
            // event text formats:
            //
            // wakes up
            // Guard #1049 begins shift
            // falls asleep

            let shiftRegex = "Guard #([0-9]+) begins shift"

            if event.contains("falls asleep") {
                return .fellAsleep
            } else if event.contains("wakes up") {
                return .wokeUp
            } else if let guardMatch = event.matching(regex: shiftRegex),
                      let guardIDString = guardMatch.captures.first,
                      let guardID = Int(guardIDString) {
                return .start(guardID: guardID)
            }

            return nil
        }
    }

    struct ShiftLine {
        let original: String
        let date: Date
        let event: ShiftEvent

        static var timeFormat: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            // formatter.timeZone = TimeZone(secondsFromGMT: 0)
            return formatter
        }

        init?(_ input: String) {
            self.original = input

            // event input formats:
            // [1518-04-03 00:36] wakes up
            // [1518-10-24 00:03] Guard #1049 begins shift
            // [1518-03-15 00:11] falls asleep

            let eventRegex = "\\[([0-9\\-\\: ]+)\\] ([A-Za-z0-9 #]+)"

            guard
                let matching = input.matching(regex: eventRegex),
                let eventText = matching.captures.last,
                let dateString = matching.captures.first,
                let date = ShiftLine.timeFormat.date(from: dateString),
                let theEvent = ShiftEvent.parse(event: eventText)
                else { return nil }

            self.date = date
            self.event = theEvent
        }
    }

    struct Shift: CustomDebugStringConvertible {
        let lines: [ShiftLine]
        let guardID: Int

        let month: Int
        let day: Int

        var ranges = [Range<Int>]()
        var minutesAsleep: Int = 0

        var debugDescription: String {
            let monthText = "\(month < 10 ? "0" : "")\(month)"
            let dayText = "\(day < 10 ? "0" : "")\(day)"

            var output = "\(monthText)-\(dayText)  #\(guardID)  "
            for min in 0..<60 {
                if let _ = ranges.first(where: { $0.contains(min) }) {
                    output += "#"
                } else {
                    output += "."
                }
            }

            return output
        }

        init(lines: [ShiftLine], guardID: Int) {
            self.lines = lines
            self.guardID = guardID

            // take date from final wake event (ideally)
            if let line = lines.last {
                let calendar = Calendar.current
                self.month = calendar.component(.month, from: line.date)
                self.day = calendar.component(.day, from: line.date)
            } else {
                self.month = 99
                self.day = 99
            }
        }

        mutating func calculateSleep() {
            let calendar = Calendar.current

            var startMin: Int?
            for line in lines {
                // let hour = calendar.component(.hour, from: line.date)
                let minute = calendar.component(.minute, from: line.date)

                switch line.event {
                case .fellAsleep:
                    startMin = minute
                case .wokeUp:
                    if let startMinute = startMin {
                        ranges.append(startMinute..<minute)
                    } else {
                        print("Found wake up without fell asleep")
                    }
                case .start(guardID: _):
                    break
                }
            }

            minutesAsleep = ranges.reduce(0, { result, range in
                result + range.count
            })
        }
    }

    struct Guard: CustomDebugStringConvertible {
        let guardID: Int
        var shifts: [Shift]

        var totalMinutesAsleep: Int {
            return shifts.reduce(0) { result, shift in
                result + shift.minutesAsleep
            }
        }

        var sleepMap: [Int: Int] {
            var mapping = [Int: Int]()
            for shift in shifts {
                for range in shift.ranges {
                    for min in range {
                        let minMap = mapping[min] ?? 0
                        mapping[min] = minMap + 1
                    }
                }
            }
            return mapping
        }

        var sleepiestMinute: Int? {
            return sleepMap.max(by: { $0.value < $1.value })?.key
        }

        var largestSleepCount: Int {
            return sleepMap.max(by: { $0.value < $1.value })?.value ?? 0
        }

        var debugDescription: String {
            return "Guard #\(guardID): Shifts \(shifts.count) Total Min: \(totalMinutesAsleep) Sleepiest: \(String(describing: sleepiestMinute))"
        }
    }


    var dayNumber: Int = 4

    @discardableResult func run(_ input: String? = nil, _ part: Int? = 1) -> Any {
        guard let input = input ?? defaultInput else {
            print("Day \(dayNumber): NO INPUT")
            exit(10)
        }

        let shifts = process(input: input)
        let guards = process(shifts: shifts)

        if part == 1 {
            let answer = partOne(guards: guards)
            print("Day \(dayNumber) Part \(part!): Final Answer \(answer)")
            return answer
        } else {
            let answer = partTwo(guards: guards)
            print("Day \(dayNumber) Part \(part!): Final Answer \(answer)")
            return answer
        }
    }

    func partOne(guards: [Guard]) -> Int {
        if let sleepiestGuard = guards.max(by: { $0.totalMinutesAsleep < $1.totalMinutesAsleep }),
            let sleepiestMinute = sleepiestGuard.sleepiestMinute {

            return sleepiestGuard.guardID * sleepiestMinute
        }

        return Int.min
    }

    func partTwo(guards: [Guard]) -> Int {
        if let sleepiestGuard = guards.max(by: { $0.largestSleepCount < $1.largestSleepCount }),
            let sleepiestMinute = sleepiestGuard.sleepiestMinute {

            return sleepiestGuard.guardID * sleepiestMinute
        }

        return Int.min
    }

    func process(input: String) -> [Shift] {
        var events = input.split(separator: "\n")
            .map(String.init)
            .compactMap { ShiftLine($0) }

        events.sort(by: { $0.date < $1.date })

        var shifts = [Shift]()

        // temp variables for looping
        var guardID: Int?
        var shiftLines: [ShiftLine]?

        var currentIdx = events.startIndex
        while currentIdx < events.endIndex {
            let line = events[currentIdx]

            switch line.event {
            case .start(guardID: let theGuardID):
                if let lines = shiftLines, let guardID = guardID {
                    var shift = Shift(lines: lines, guardID: guardID)
                    shift.calculateSleep()
                    shifts.append(shift)
                }
                guardID = theGuardID
                shiftLines = [line]
            case .fellAsleep, .wokeUp:
                shiftLines?.append(line)
            }

            currentIdx = events.index(after: currentIdx)
        }

        // catch the last one
        if let lines = shiftLines, let guardID = guardID {
            var shift = Shift(lines: lines, guardID: guardID)
            shift.calculateSleep()
            shifts.append(shift)
        }

//        print(events.map { $0.original }.joined(separator: "\n"))
//        print("----------------------------------")
//        print(shifts.map { $0.debugDescription }.joined(separator: "\n"))

        return shifts
    }

    func process(shifts: [Shift]) -> [Guard] {
        var guardMap = [Int:[Shift]]()
        for shift in shifts {
            if var guardShifts = guardMap[shift.guardID] {
                guardShifts.append(shift)
                guardMap[shift.guardID] = guardShifts
            } else {
                guardMap[shift.guardID] = [shift]
            }
        }

//        print("Found \(guards.count) guards ")
//        guards.sorted(by: { $0.guardID < $1.guardID }).forEach { print($0.debugDescription) }
//        print("----------------------")

        return guardMap.map { Guard(guardID: $0, shifts: $1) }
    }
}
