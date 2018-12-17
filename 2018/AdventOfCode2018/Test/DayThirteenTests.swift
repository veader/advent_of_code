//
//  DayThirteenTests.swift
//  Test
//
//  Created by Shawn Veader on 12/13/18.
//  Copyright © 2018 Shawn Veader. All rights reserved.
//

import XCTest

class DayThirteenTests: XCTestCase {

    func testCartInit() {
        let location = Coordinate(x: 2, y: 3)

        var cart = DayThirteen.Cart(text: "^", location: location)
        XCTAssertEqual(.north, cart?.orientation)
        XCTAssertEqual(.left, cart?.nextDirectionChange)
        XCTAssertEqual("|", cart?.currentSegment)

        cart = DayThirteen.Cart(text: "v", location: location)
        XCTAssertEqual(.south, cart?.orientation)
        XCTAssertEqual("|", cart?.currentSegment)

        cart = DayThirteen.Cart(text: "<", location: location)
        XCTAssertEqual(.west, cart?.orientation)
        XCTAssertEqual("-", cart?.currentSegment)

        cart = DayThirteen.Cart(text: ">", location: location)
        XCTAssertEqual(.east, cart?.orientation)
        XCTAssertEqual("-", cart?.currentSegment)
    }

    func testMoveNorth() {
        let location = Coordinate(x: 2, y: 3)
        let nextLocation = Coordinate(x: 2, y: 2)
        var cart = DayThirteen.Cart(text: "^", location: location)
        XCTAssertEqual(.north, cart?.orientation)

        cart?.move(with: "|") // straight
        XCTAssertEqual(.north, cart?.orientation)
        XCTAssertEqual(.left, cart?.nextDirectionChange)
        XCTAssertEqual(nextLocation, cart?.location)

        cart = DayThirteen.Cart(text: "^", location: location)
        cart?.move(with: "/") // right turn
        XCTAssertEqual(.east, cart?.orientation)
        XCTAssertEqual(.left, cart?.nextDirectionChange)
        XCTAssertEqual(nextLocation, cart?.location)

        cart = DayThirteen.Cart(text: "^", location: location)
        cart?.move(with: "\\") // left turn
        XCTAssertEqual(.west, cart?.orientation)
        XCTAssertEqual(.left, cart?.nextDirectionChange)
        XCTAssertEqual(nextLocation, cart?.location)

        cart = DayThirteen.Cart(text: "^", location: location)
        cart?.move(with: "+") // intersection
        XCTAssertEqual(.west, cart?.orientation)
        XCTAssertEqual(.straight, cart?.nextDirectionChange)
        XCTAssertEqual(nextLocation, cart?.location)
    }

    func testMoveSouth() {
        let location = Coordinate(x: 2, y: 3)
        let nextLocation = Coordinate(x: 2, y: 4)
        var cart = DayThirteen.Cart(text: "v", location: location)
        XCTAssertEqual(.south, cart?.orientation)

        cart?.move(with: "|") // straight
        XCTAssertEqual(.south, cart?.orientation)
        XCTAssertEqual(.left, cart?.nextDirectionChange)
        XCTAssertEqual(nextLocation, cart?.location)

        cart = DayThirteen.Cart(text: "v", location: location)
        cart?.move(with: "/") // right turn
        XCTAssertEqual(.west, cart?.orientation)
        XCTAssertEqual(.left, cart?.nextDirectionChange)
        XCTAssertEqual(nextLocation, cart?.location)

        cart = DayThirteen.Cart(text: "v", location: location)
        cart?.move(with: "\\") // left turn
        XCTAssertEqual(.east, cart?.orientation)
        XCTAssertEqual(.left, cart?.nextDirectionChange)
        XCTAssertEqual(nextLocation, cart?.location)

        cart = DayThirteen.Cart(text: "v", location: location)
        cart?.move(with: "+") // intersection
        XCTAssertEqual(.east, cart?.orientation)
        XCTAssertEqual(.straight, cart?.nextDirectionChange)
        XCTAssertEqual(nextLocation, cart?.location)
    }

    func testMoveEast() {
        let location = Coordinate(x: 2, y: 3)
        let nextLocation = Coordinate(x: 3, y: 3)
        var cart = DayThirteen.Cart(text: ">", location: location)
        XCTAssertEqual(.east, cart?.orientation)

        cart?.move(with: "-") // straight
        XCTAssertEqual(.east, cart?.orientation)
        XCTAssertEqual(.left, cart?.nextDirectionChange)
        XCTAssertEqual(nextLocation, cart?.location)

        cart = DayThirteen.Cart(text: ">", location: location)
        cart?.move(with: "/") // left turn
        XCTAssertEqual(.north, cart?.orientation)
        XCTAssertEqual(.left, cart?.nextDirectionChange)
        XCTAssertEqual(nextLocation, cart?.location)

        cart = DayThirteen.Cart(text: ">", location: location)
        cart?.move(with: "\\") // right turn
        XCTAssertEqual(.south, cart?.orientation)
        XCTAssertEqual(.left, cart?.nextDirectionChange)
        XCTAssertEqual(nextLocation, cart?.location)

        cart = DayThirteen.Cart(text: ">", location: location)
        cart?.move(with: "+") // intersection
        XCTAssertEqual(.north, cart?.orientation)
        XCTAssertEqual(.straight, cart?.nextDirectionChange)
        XCTAssertEqual(nextLocation, cart?.location)
    }

    func testMoveWest() {
        let location = Coordinate(x: 2, y: 3)
        let nextLocation = Coordinate(x: 1, y: 3)
        var cart = DayThirteen.Cart(text: "<", location: location)
        XCTAssertEqual(.west, cart?.orientation)

        cart?.move(with: "-") // straight
        XCTAssertEqual(.west, cart?.orientation)
        XCTAssertEqual(.left, cart?.nextDirectionChange)
        XCTAssertEqual(nextLocation, cart?.location)

        cart = DayThirteen.Cart(text: "<", location: location)
        cart?.move(with: "/") // left turn
        XCTAssertEqual(.south, cart?.orientation)
        XCTAssertEqual(.left, cart?.nextDirectionChange)
        XCTAssertEqual(nextLocation, cart?.location)

        cart = DayThirteen.Cart(text: "<", location: location)
        cart?.move(with: "\\") // right turn
        XCTAssertEqual(.north, cart?.orientation)
        XCTAssertEqual(.left, cart?.nextDirectionChange)
        XCTAssertEqual(nextLocation, cart?.location)

        cart = DayThirteen.Cart(text: "<", location: location)
        cart?.move(with: "+") // intersection
        XCTAssertEqual(.south, cart?.orientation)
        XCTAssertEqual(.straight, cart?.nextDirectionChange)
        XCTAssertEqual(nextLocation, cart?.location)
    }

    // stupid double slash makes these hard to read...
    let sampleMap = """
                    /->-\\
                    |   |  /----\\
                    | /-+--+-\\  |
                    | | |  | v  |
                    \\-+-/  \\-+--/
                      \\------/
                    """
    let cleanMap = """
                    /---\\
                    |   |  /----\\
                    | /-+--+-\\  |
                    | | |  | |  |
                    \\-+-/  \\-+--/
                      \\------/
                    """

    let sampleBusyMap = """
                        />-<\\
                        |   |
                        | /<+-\\
                        | | | v
                        \\>+</ |
                          |   ^
                          \\<->/
                        """

    func testMapInit() {
        let map = DayThirteen.Map(lines: lines(from: sampleMap))
        XCTAssertEqual(2, map.carts.count)
        let printableMap = map.printable(showCarts: false)
        // print(printableMap)
        XCTAssertEqual(cleanMap, printableMap)
        XCTAssertEqual(sampleMap, map.printable(showCarts: true))
    }

    func testMapRun() {
        var map = DayThirteen.Map(lines: lines(from: sampleMap))
        let collision = map.startYourEngines()
        XCTAssertEqual(Coordinate(x: 7, y: 3), collision)
    }

    func testMapRemovalRun() {
        var map = DayThirteen.Map(lines: lines(from: sampleBusyMap))
        let lastLocation = map.startYourEngines(removing: true)
        XCTAssertEqual(Coordinate(x: 6, y: 4), lastLocation)
    }

    func lines(from source: String) -> [String] {
        return source.split(separator: "\n")
                     .map(String.init)
                     .map { $0.trimmingCharacters(in: .newlines) }
    }
}
