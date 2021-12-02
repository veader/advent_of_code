//
//  TicketScanner.swift
//  aoc2020
//
//  Created by Shawn Veader on 12/16/20.
//

import Foundation

struct TicketScanner {
    typealias Ticket = [Int]
    let fields: [String: ClosedRangeWithGap]
    let yourTicket: Ticket
    let nearbyTickets: [Ticket]

    private enum InputArea {
        case fields
        case personal
        case nearby
    }

    init(_ input: String) {
        var area: InputArea = .fields
        var tmpFields = [String: ClosedRangeWithGap]()
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
                if let fieldData = TicketScanner.parseField(line),
                   let range = ClosedRangeWithGap(fieldData.ranges) {

                    tmpFields[fieldData.field] = range
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
            // confirm at least one of the ranges contains
            fields.values.first(where: { $0.contains(int) }) != nil
        }
    }

    /// Find any errors in the given tickent
    func findErrors(ticket: Ticket) -> [Int] {
        Array(Set(ticket).subtracting(Set(findValidEntries(ticket: ticket))))
    }


    // MARK: - Part Two

    func findDepartureFieldsInMyTicket() -> [Int] {
        let map = buildFieldPositionMap()
        let departureFields = fields.filter( { $0.key.contains("departure")} ).keys
        return departureFields.compactMap { field in
            guard let idx = map[field] else { return nil }
            return yourTicket[idx]
        }
    }

    /// Build mapping of field name to index within Ticket
    func buildFieldPositionMap() -> [String: Int] {
        let tickets = validTickets() + [yourTicket]
        let width = tickets.first?.count ?? 0

        // Final resulting map of field to index (column within ticket)
        var map = [String: Int]()

        // Mapping from indicies to possible field names
        var possibilitiesMap = [Int: [String]]()

        for idx in 0..<width {
            let slice = tickets.map { $0[idx] }
            let possible = findPossibleFieldsFor(entries: slice)
            possibilitiesMap[idx] = possible
        }

        // chew threw through the possible mappings looking for ones that can only be assigned to a single field
        while !possibilitiesMap.isEmpty {
            // remove any empty possibilities
            possibilitiesMap = possibilitiesMap.filter { $1.count != 0 }

            // find any entries with a single mapping
            let singles = possibilitiesMap.filter { $1.count == 1 }

            for (idx, flds) in singles {
                let theField = flds.first!

                // store the mapping
                map[theField] = idx

                // remove this as a choice in all other columns
                possibilitiesMap.forEach { (idx, pFields) in
                    possibilitiesMap[idx] = pFields.filter { $0 != theField }
                }
            }
        }

        return map
    }

    func printMap(_ map: [String: Int]) {
        map.sorted(by: { $0.value < $1.value }).forEach { (field, idx) in
            print("\(idx): \(field)")
        }
    }

    func printFields() {
        let maxFieldName = fields.keys.map({ $0.count }).max() ?? 10
        for (field, range) in fields {
            print("\(field.padded(with: " ", length: maxFieldName)):  \(range)")
        }
    }

    func findPossibleFieldsFor(entries: [Int]) -> [String] {
        let matches = fields.filter { (_, range) in
            range.containsAll(entries)
        }

        return Array(matches.keys)
    }

    /// Find field (if any) that matches all the values
    func findFieldFor(entries: [Int], excluding: [String]) -> String? {
//        print("\n**** Finding field for \(entries.sorted())")
        return fields.first(where: { (field, range) in
            guard !excluding.contains(field) else { return false }
//            print("\tChecking \(field): \(range)")

            let answer = range.containsAll(entries)

//            let answer = entries.allSatisfy { entry in
//                range.contains(entry)
//                // determine if at least one of the ranges for the field includes this entry
//                // ranges.first(where: { range in range.contains(entry) }) != nil
//            }

//            if !answer {
//                let excluded = range.excludedValues(entries)
//                print("\t\(field) doesn't include \(excluded)")
//            }
            // print("\t\(answer ? "Yup" : "Nope")")
            return answer
        })?.key
    }

    /// Is the ticket valid?
    func isValid(ticket: Ticket) -> Bool {
        findErrors(ticket: ticket).count == 0
    }

    /// All tickets with no errors
    func validTickets() -> [Ticket] {
        nearbyTickets.filter{ isValid(ticket: $0) }
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
