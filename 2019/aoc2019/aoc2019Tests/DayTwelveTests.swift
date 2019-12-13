//
//  DayTwelveTests.swift
//  aoc2019Tests
//
//  Created by Shawn Veader on 12/12/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import XCTest

class DayTwelveTests: XCTestCase {

    func testTreeDimPositionParsing() {
        var dim: ThreeDimPosition?

        dim = ThreeDimPosition(input: "")
        XCTAssertNil(dim)

        dim = ThreeDimPosition(input: "x=1, y=2")
        XCTAssertNil(dim)

        dim = ThreeDimPosition(input: "x=1, y=2, z")
        XCTAssertNil(dim)

        dim = ThreeDimPosition(input: "<x=17, y=-12, z=13>")
        XCTAssertNotNil(dim)
        XCTAssertEqual(17, dim?.x)
        XCTAssertEqual(-12, dim?.y)
        XCTAssertEqual(13, dim?.z)

        dim = ThreeDimPosition(input: "<y=-12, x=17, z=13>")
        XCTAssertNotNil(dim)
        XCTAssertEqual(17, dim?.x)
        XCTAssertEqual(-12, dim?.y)
        XCTAssertEqual(13, dim?.z)

        dim = ThreeDimPosition(input: "<x=2, y=1, z=1>")
        XCTAssertNotNil(dim)
        XCTAssertEqual(2, dim?.x)
        XCTAssertEqual(1, dim?.y)
        XCTAssertEqual(1, dim?.z)
    }

    func testMoonGravityApplication() {
        let ganymede = Moon(position: ThreeDimPosition(x: 3, y: 0, z: 0))
        let callisto = Moon(position: ThreeDimPosition(x: 5, y: 0, z: 0))

        callisto.applyGravity(toward: ganymede)
        XCTAssertEqual(-1, callisto.velocity.x)
        XCTAssertEqual(1, ganymede.velocity.x)
        XCTAssertEqual(0, ganymede.velocity.y)
        XCTAssertEqual(0, ganymede.velocity.z)
    }

    func testMoonVelocityApplication() {
        let moon = Moon(position: ThreeDimPosition(x: 5, y: 3, z: -1))
        let velocity = ThreeDimPosition(x: -5, y: -3, z: 1)
        moon.velocity = velocity

        moon.applyVelocity()
        XCTAssertEqual(0, moon.position.x)
        XCTAssertEqual(0, moon.position.y)
        XCTAssertEqual(0, moon.position.z)
    }

    func testMoonEnergy() {
        let moon = Moon(input: "<x= 2, y= 0, z= 4>")
        let velocity = ThreeDimPosition(x: 1, y: -1, z: -1)
        moon?.velocity = velocity

        XCTAssertEqual(6, moon?.potentialEnergy)
        XCTAssertEqual(3, moon?.kineticEnergy)
        XCTAssertEqual(18, moon?.totalEnergy)
    }

    func testPartOneStepping() {
        let day = DayTwelve()
        let moons = day.parse(testMoons1)
        let pairs = day.createPairs(moons: moons)

        day.step(moons: moons, pairs: pairs) // 1
        XCTAssertEqual(ThreeDimPosition(x: 2, y: -1, z: 1), moons[0].position)
        XCTAssertEqual(ThreeDimPosition(x: 3, y: -1, z: -1), moons[0].velocity)
        XCTAssertEqual(ThreeDimPosition(x: 3, y: -7, z: -4), moons[1].position)
        XCTAssertEqual(ThreeDimPosition(x: 1, y: 3, z: 3), moons[1].velocity)

        day.step(moons: moons, pairs: pairs) // 2
        XCTAssertEqual(ThreeDimPosition(x: 5, y: -3, z: -1), moons[0].position)
        XCTAssertEqual(ThreeDimPosition(x: 3, y: -2, z: -2), moons[0].velocity)
        XCTAssertEqual(ThreeDimPosition(x: 1, y: -2, z: 2), moons[1].position)
        XCTAssertEqual(ThreeDimPosition(x: -2, y: 5, z: 6), moons[1].velocity)

        day.step(moons: moons, pairs: pairs) // 3
        day.step(moons: moons, pairs: pairs) // 4
        day.step(moons: moons, pairs: pairs) // 5
        day.step(moons: moons, pairs: pairs) // 6
        day.step(moons: moons, pairs: pairs) // 7
        day.step(moons: moons, pairs: pairs) // 8
        day.step(moons: moons, pairs: pairs) // 9

        day.step(moons: moons, pairs: pairs) // 10
        XCTAssertEqual(ThreeDimPosition(x: 2, y: 1, z: -3), moons[0].position)
        XCTAssertEqual(ThreeDimPosition(x: -3, y: -2, z: 1), moons[0].velocity)
        XCTAssertEqual(ThreeDimPosition(x: 1, y: -8, z: 0), moons[1].position)
        XCTAssertEqual(ThreeDimPosition(x: -1, y: 1, z: 3), moons[1].velocity)
    }

    func testPartOne() {
        let day = DayTwelve()
        let moons = day.parse(testMoons2)
        let pairs = day.createPairs(moons: moons)

        day.runSteps(count: 100, moons: moons, pairs: pairs)

        let totalEnergy = moons.reduce(0) { $0 + $1.totalEnergy }
        XCTAssertEqual(1940, totalEnergy)
    }

    func testPartTwo() {
//        let day = DayTwelve()

//        let moons = day.parse(testMoons1)
//        let pairs = day.createPairs(moons: moons)
//        let repeated = day.runTillRepeat(moons: moons, pairs: pairs)
//        XCTAssertEqual(2772, repeated)

//        let moons = day.parse(testMoons2)
//        let pairs = day.createPairs(moons: moons)
//        let repeated = day.runTillRepeat(moons: moons, pairs: pairs)
//        XCTAssertEqual(4686774924, repeated)
    }

    func testPartOneAnswer() {
        let day = DayTwelve()
        let answer = day.run(part: 1) as! Int
        XCTAssertEqual(8960, answer)
    }

    func testPartTwoAnswer() {
        XCTAssert(true)
//        let day = DayTwelve()
//        let answer = day.run(part: 2) as! Int
//        XCTAssertEqual(416, answer)
    }


    let testMoons1 = """
                     <x=-1, y=0, z=2>
                     <x=2, y=-10, z=-7>
                     <x=4, y=-8, z=8>
                     <x=3, y=5, z=-1>
                     """

    let testMoons2 = """
                     <x=-8, y=-10, z=0>
                     <x=5, y=5, z=10>
                     <x=2, y=-7, z=3>
                     <x=9, y=-8, z=-3>
                     """
}
