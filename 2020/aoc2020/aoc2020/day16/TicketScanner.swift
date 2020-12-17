//
//  TicketScanner.swift
//  aoc2020
//
//  Created by Shawn Veader on 12/16/20.
//

import Foundation

struct TicketScanner {
    typealias Ticket = [Int]
    let fields: [String: [ClosedRange<Int>]]
    let yourTicket: Ticket
    let nearbyTickets: [Ticket]

    private enum InputArea {
        case fields
        case personal
        case nearby
    }

    init(_ input: String) {
        var area: InputArea = .fields
        var tmpFields = [String: [ClosedRange<Int>]]()
        var tmpMyTicket = Ticket()
        var tmpNearbyTickets = [Ticket]()

        let lines = input.split(separator: "\n").map(String.init)
        for line in lines {
            guard line.count > 0 else { continue } // skip blank lines

            // check to see if we are switching areas
            if line == "your ticket:" {
                area = .personal
                continue
            } else if line == "nearby tickets:" {
                area = .nearby
                continue
            }

            switch area {
            case .fields:
                if let fieldData = TicketScanner.parseField(line) {
                    tmpFields[fieldData.field] = fieldData.ranges
                }
            case .personal:
                tmpMyTicket = TicketScanner.parseTicket(line)
            case .nearby:
                let ticket = TicketScanner.parseTicket(line)
                tmpNearbyTickets.append(ticket)
            }
        }

        // save off parsed data
        fields = tmpFields
        yourTicket = tmpMyTicket
        nearbyTickets = tmpNearbyTickets
    }


    // MARK: - Part One

    /// Find errors in the nearby tickets
    func findNearbyTicketErrors() -> [Int] {
        nearbyTickets.flatMap { findErrors(ticket: $0) }
    }

    /// Find any valid entry in the given ticket.
    func findValidEntries(ticket: Ticket) -> [Int] {
        ticket.filter { (int: Int) -> Bool in
            var foundField = false

            for (fieldName, ranges) in fields {
                if ranges.contains(where: { $0.contains(int) }) {
                    // print("Field \(fieldName): matches \(int)")
                    foundField = true
                    break
                } else {
                    // print("Field \(fieldName): does NOT matches \(int)")
                }
            }

            return foundField
        }
    }

    /// Find any errors in the given tickent
    func findErrors(ticket: Ticket) -> [Int] {
        Array(Set(ticket).subtracting(Set(findValidEntries(ticket: ticket))))
    }


    // MARK: - Static Parsing Methods

    static func parseField(_ input: String) -> (field: String, ranges: [ClosedRange<Int>])? {
        let pieces = input.split(separator: ":").map { String($0.trimmingCharacters(in: .whitespaces)) }
        guard pieces.count == 2, let fieldName = pieces.first, let rangeData = pieces.last else { return nil }

        let ranges = rangeData
            .replacingOccurrences(of: " or ", with: "|")
            .split(separator: "|")
            .map { String($0.trimmingCharacters(in: .whitespaces)) }
            .compactMap { (rangeStr: String) -> ClosedRange<Int>? in
                let nums = rangeStr.split(separator: "-").map(String.init).compactMap(Int.init)
                guard nums.count == 2 else { return nil }
                return nums[0]...nums[1]
            }

        return (fieldName, ranges)
    }

    static func parseTicket(_ input: String) -> Ticket {
        input.split(separator: ",").map(String.init).compactMap(Int.init)
    }
}
