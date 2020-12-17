//
//  DaySixteenTests.swift
//  Test
//
//  Created by Shawn Veader on 12/16/20.
//

import XCTest

class DaySixteenTests: XCTestCase {

    func testTicketScannerParsing() {
        let scanner = TicketScanner(testInput)
        XCTAssertEqual(3, scanner.fields.count)
        XCTAssertEqual(3, scanner.yourTicket.count)
        XCTAssertEqual(4, scanner.nearbyTickets.count)

        let field = scanner.fields["class"]
        XCTAssertNotNil(field)
        XCTAssert(field!.contains(1))
        XCTAssert(field!.contains(2))
        XCTAssert(field!.contains(3))
        XCTAssertFalse(field!.contains(4))
        XCTAssert(field!.contains(5))
        XCTAssert(field!.contains(6))
        XCTAssert(field!.contains(7))

        var ticket: TicketScanner.Ticket?
        ticket = scanner.yourTicket
        XCTAssertEqual([7,1,14], ticket)

        ticket = scanner.nearbyTickets.first
        XCTAssertNotNil(ticket)
        XCTAssertEqual([7,3,47], ticket)
    }

    func testTicketValidation() {
        let scanner = TicketScanner(testInput)
        var ticket: TicketScanner.Ticket
        var answer: [Int]

        ticket = [7,3,47]
        answer = scanner.findValidEntries(ticket: ticket)
        XCTAssertEqual(3, answer.count)
        answer = scanner.findErrors(ticket: ticket)
        XCTAssertEqual(0, answer.count)

        ticket = [40,4,50]
        answer = scanner.findValidEntries(ticket: ticket)
        XCTAssertEqual(2, answer.count)
        answer = scanner.findErrors(ticket: ticket)
        XCTAssertEqual(1, answer.count)

        ticket = [55,2,20]
        answer = scanner.findValidEntries(ticket: ticket)
        XCTAssertEqual(2, answer.count)
        answer = scanner.findErrors(ticket: ticket)
        XCTAssertEqual(1, answer.count)

        ticket = [38,6,12]
        answer = scanner.findValidEntries(ticket: ticket)
        XCTAssertEqual(2, answer.count)
        answer = scanner.findErrors(ticket: ticket)
        XCTAssertEqual(1, answer.count)
    }

    func testScannerNearbyTicketErrors() {
        let scanner = TicketScanner(testInput)
        let answer = scanner.findNearbyTicketErrors()
        XCTAssertEqual([4,55,12], answer)
        XCTAssertEqual(71, answer.reduce(0, +))
    }

    func testScannerValidTickets() {
        var scanner: TicketScanner
        var tickets: [TicketScanner.Ticket]

        scanner = TicketScanner(testInput)
        tickets = scanner.validTickets()
        XCTAssertEqual(1, tickets.count)

        scanner = TicketScanner(testInput2)
        tickets = scanner.validTickets()
        XCTAssertEqual(3, tickets.count)
    }

    func testScannerFieldMap() {
        let scanner = TicketScanner(testInput2)
        let map = scanner.buildFieldPositionMap()
        XCTAssertEqual(0, map["row"])
        XCTAssertEqual(1, map["class"])
        XCTAssertEqual(2, map["seat"])
    }

    let testInput = """
        class: 1-3 or 5-7
        row: 6-11 or 33-44
        seat: 13-40 or 45-50

        your ticket:
        7,1,14

        nearby tickets:
        7,3,47
        40,4,50
        55,2,20
        38,6,12
        """

    let testInput2 = """
        class: 0-1 or 4-19
        row: 0-5 or 8-19
        seat: 0-13 or 16-19

        your ticket:
        11,12,13

        nearby tickets:
        3,9,18
        15,1,5
        5,14,9
        """
}
