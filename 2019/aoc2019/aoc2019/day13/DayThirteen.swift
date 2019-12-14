//
//  DayThirteen.swift
//  aoc2019
//
//  Created by Shawn Veader on 12/13/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import Foundation

struct DayThirteen: AdventDay {
    var dayNumber: Int = 13

    // func parse(_ input: String?) -> FOO { return FOO... }

    func partOne(input: String?) -> Any {
        let arcadeMachine = IntCodeMachine(instructions: input ?? "")
        arcadeMachine.silent = true
        arcadeMachine.run()

        let screen = ArcadeScreen()
        screen.draw(input: arcadeMachine.outputs)
        screen.printScreen()

        return screen.grid.filter { $0.value == ArcadeScreen.Tile.block }.count
    }

    func partTwo(input: String?) -> Any {
        let cabinet = ArcadeCabinet(input: input ?? "")
        cabinet.play()

        return 0
    }
}
