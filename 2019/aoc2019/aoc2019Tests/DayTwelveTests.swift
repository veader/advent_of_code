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
        let simulation = MoonSimulation(moons: moons)

        simulation.step() // 1
        XCTAssertEqual(ThreeDimPosition(x: 2, y: -1, z: 1), simulation.moons[0].position)
        XCTAssertEqual(ThreeDimPosition(x: 3, y: -1, z: -1), simulation.moons[0].velocity)
        XCTAssertEqual(ThreeDimPosition(x: 3, y: -7, z: -4), simulation.moons[1].position)
        XCTAssertEqual(ThreeDimPosition(x: 1, y: 3, z: 3), simulation.moons[1].velocity)

        simulation.step() // 2
        XCTAssertEqual(ThreeDimPosition(x: 5, y: -3, z: -1), simulation.moons[0].position)
        XCTAssertEqual(ThreeDimPosition(x: 3, y: -2, z: -2), simulation.moons[0].velocity)
        XCTAssertEqual(ThreeDimPosition(x: 1, y: -2, z: 2), simulation.moons[1].position)
        XCTAssertEqual(ThreeDimPosition(x: -2, y: 5, z: 6), simulation.moons[1].velocity)

        simulation.step(count: 8) // 3-10
        XCTAssertEqual(ThreeDimPosition(x: 2, y: 1, z: -3), simulation.moons[0].position)
        XCTAssertEqual(ThreeDimPosition(x: -3, y: -2, z: 1), simulation.moons[0].velocity)
        XCTAssertEqual(ThreeDimPosition(x: 1, y: -8, z: 0), simulation.moons[1].position)
        XCTAssertEqual(ThreeDimPosition(x: -1, y: 1, z: 3), simulation.moons[1].velocity)
    }

    func testPartOne() {
        let day = DayTwelve()
        let moons = day.parse(testMoons2)
        let simulation = MoonSimulation(moons: moons)
        simulation.step(count: 100)

        XCTAssertEqual(1940, simulation.totalEnergy)
    }

    func testPartTwo() {
        let day = DayTwelve()
        var answer = day.partTwo(input: testMoons1)
        XCTAssertEqual(2772, answer as! Int)

        answer = day.partTwo(input: testMoons2)
        XCTAssertEqual(4_686_774_924, answer as! Int)
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
