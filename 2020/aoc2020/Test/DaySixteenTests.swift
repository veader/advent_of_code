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
        XCTAssert(field!.contains(1...3))
        XCTAssert(field!.contains(5...7))

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
}
