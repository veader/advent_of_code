//
//  day1.swift
//  CodeAdvent2015
//
//  Created by Shawn Veader on 12/17/15.
//  Copyright © 2015 V8 Logic. All rights reserved.
//

import Foundation

enum Direction: Character {
    case Up = "("
    case Down = ")"
}

struct Elevator {
    var current_floor = 0
    var transition_to_basement: Int?

    mutating func move(dir: Direction) {
        switch dir {
        case .Up:
            self.current_floor = self.current_floor + 1
        case .Down:
            self.current_floor = self.current_floor - 1
        }
    }

    mutating func check_for_basement_transition(index: Int) {
        if (self.transition_to_basement == nil && self.current_floor < 0) {
            self.transition_to_basement = index + 1
        }
    }

    mutating func operate(instructions: String) {
        for (index, instruction) in instructions.characters.enumerate() {
            move(Direction(rawValue: instruction)!)
            check_for_basement_transition(index)
        }
        // _ = instructions.characters.map { move(Direction(rawValue: $0)!) }
    }

    mutating func reset() {
        self.current_floor = 0
    }
}
