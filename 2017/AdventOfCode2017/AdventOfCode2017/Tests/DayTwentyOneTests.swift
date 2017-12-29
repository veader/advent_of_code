//
//  DayTwentyOneTests.swift
//  AdventOfCode2017
//
//  Created by Shawn Veader on 12/25/17.
//  Copyright © 2017 v8logic. All rights reserved.
//

import Foundation

extension DayTwentyOne: Testable {
    func runTests() {
        let input = ".#./..#/###"
        let grid = Grid(input)
        let rotatedGrid = grid.rotate()
        let rotatedTwice = rotatedGrid.rotate()
        let rotatedThrice = rotatedTwice.rotate()

        /* Rotations
         .#.    #..    ###    .##
         ..# -> #.# -> #.. -> #.#
         ###    ##.    .#.    ..#
        */
        guard
            testValue("#../#.#/##.", equals: rotatedGrid.stringForm),
            testValue("#../#.#/##.", equals: grid.rotate(turns: 5).stringForm),
            testValue("###/#../.#.", equals: rotatedTwice.stringForm),
            testValue("###/#../.#.", equals: grid.rotate(turns: 2).stringForm),
            testValue("###/#../.#.", equals: grid.rotate(turns: 6).stringForm),
            testValue(".##/#.#/..#", equals: rotatedThrice.stringForm),
            testValue(".##/#.#/..#", equals: grid.rotate(turns: 3).stringForm),
            testValue(".##/#.#/..#", equals: grid.rotate(turns: 7).stringForm),
            testValue(input, equals: rotatedThrice.rotate().stringForm),
            testValue(input, equals: grid.rotate(turns: 4).stringForm),
            testValue(".#./#../###", equals: grid.mirror().stringForm),
            true
            else {
                print("Grid Tests Failed!")
                return
            }

        /*
        print("\nSplit Tests: 2")
        let split2Input = "#..#/.##./.##./.##."
        let split2Grid = Grid(split2Input)
        print(split2Grid)
        for (idx, rowGrids) in split2Grid.subGrids().enumerated() {
            print("[2] Row \(idx)")
            for g in rowGrids {
                print(g.stringForm)
            }
        }

        print("\nSplit Tests: 3")
        let split3Input = "#....#.../.#..#..../..##...../.#......./.#.###.../.#......./........./........./........."
        let split3Grid = Grid(split3Input)
        print(split3Grid)
        for (idx, rowGrids) in split3Grid.subGrids().enumerated() {
            print("[3] Row \(idx)")
            for g in rowGrids {
                print(g.stringForm)
            }
        }
 */

        let part1Rules = """
            ../.# => ##./#../...
            .#./..#/### => #..#/..../..../#..#
            """

        guard
            testValue(12, equals: partOne(input: part1Rules  ))
            else {
                print("Part 1 Tests Failed!")
                return
        }

//        guard
//            testValue(0, equals: partTwo(input: input))
//            else {
//                print("Part 2 Tests Failed!")
//                return
//        }

        print("Done with tests... all pass")
    }
}
