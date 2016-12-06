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

class Elevator {
    var current_floor = 0
    var transition_to_basement: Int?

    func move(dir: Direction) {
        switch dir {
        case .Up:
            self.current_floor = self.current_floor + 1
        case .Down:
            self.current_floor = self.current_floor - 1
        }
    }

    func check_for_basement_transition(index: Int) {
        if (self.transition_to_basement == nil && self.current_floor < 0) {
            self.transition_to_basement = index + 1
        }
    }

    func operate(instructions: String) {
        for (index, instruction) in instructions.characters.enumerate() {
            guard let dir = Direction(rawValue: instruction) else { continue }
            move(dir)
            check_for_basement_transition(index)
        }
        // _ = instructions.characters.map { move(Direction(rawValue: $0)!) }
    }

    func reset() {
        self.current_floor = 0
    }
}

func advent_day1(input: String) {
    let elevator = Elevator()
    elevator.operate(input)
    print("Elevator ended up on \(elevator.current_floor)")
    print("Elevator went into basement on \(elevator.transition_to_basement)")
}
