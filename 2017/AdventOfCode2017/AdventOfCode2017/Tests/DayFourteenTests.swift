//
//  DayFourteenTests.swift
//  AdventOfCode2017
//
//  Created by Shawn Veader on 12/15/17.
//  Copyright © 2017 v8logic. All rights reserved.
//

import Foundation

extension DayFourteen: Testable {
    func runTests() {
        let key = "flqrgnkx"

        guard
            testValue(8108, equals: partOne(input: key))
            else {
                print("Part 1 Tests Failed!")
                return
        }

//        let disk = Disk(key)
//        print(disk[Disk.BlockCoordinate(0,0)])
//        print(disk[Disk.BlockCoordinate(1,0)])
//        print(disk[Disk.BlockCoordinate(0,1)])
//        print(disk[Disk.BlockCoordinate(1,1)])
//        disk.printState()

        guard
            //testValue(0, equals: partTwo(input: "")),
            testValue(1242, equals: partTwo(input: key)),
            true
            else {
                print("Part 2 Tests Failed!")
                return
        }

//        var disk = Disk(key)
//        disk.findRegions()
//        disk.printState(withRegions: true)

        print("Done with tests... all pass")
    }
}
