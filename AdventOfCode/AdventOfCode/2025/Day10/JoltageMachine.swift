//
//  JoltageMachine.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/10/25.
//

import Foundation
import RegexBuilder

class JoltageMachine {

    struct Light {
        var state: Bool
        let startState: Bool

        var joltageLevel: Int
        let joltageReq: Int

        /// A light is "correct" if it is in the correct state to start the machine
        var correct: Bool {
            state == startState
        }

        /// A light is "correct" for joltage, if it matches the required level
        var joltageCorrect: Bool {
            joltageLevel == joltageReq
        }

        /// A light is overcharged if its current level is more than the requirement
        var overCharged: Bool {
            joltageLevel > joltageReq
        }

        /// Toggles the state of the light and increments the joltage level
        mutating func toggle() {
            state = !state
            joltageLevel += 1
        }
    }

    // necessary vs a [[Int]] ?
    struct LightButton {
        let lightIndices: [Int]
    }

    var lights: [Light]
    let buttons: [LightButton]

    /// Which buttons have been pressed to be in our current state?
    var presses: [Int] = []

    let joltageAnswer: [Int]

    /// Create simple visual of the current state of the lights
    ///
    /// This should mirror the original input. ie: `.##.`
    var lightState: String {
        lights.map { $0.state ? "#" : "." }.joined()
    }

    /// The machine is startable if all lights are in the correct state.
    var startable: Bool {
        lights.map(\.correct).unique() == [true]
    }

    var joltageCorrect: Bool {
        lights.map(\.joltageCorrect).unique() == [true]
    }

    var joltageExceeded: Bool {
        lights.map(\.overCharged).contains(true)
    }

    init(lights: [Light], buttons: [LightButton], presses: [Int]) {
        self.lights = lights
        self.buttons = buttons
        self.presses = presses
        self.joltageAnswer = lights.map(\.joltageReq)
    }

    /// Parses a given line of input for a joltage machine.
    ///
    /// Example:
    /// `[.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}`
    /// - [] describes how many lights and what config they need to be in to start
    /// - () describes a set of buttons - buttons have indices into the lights
    /// - {} describes the joltage requirements for each light
    init?(_ input: String) {
        guard let match = input.firstMatch(of: Self.regex) else { print("Format incorrect"); return nil }

        let startState: [Bool] = String(match.1).map { $0 == "#" ? true : false }

        let buttons: [[Int]] = String(match.2).split(separator: /\s+/).map(String.init).map {
            var buttonStr = $0
            // remove parens
            buttonStr.removeFirst(1)
            buttonStr.removeLast(1)
            return buttonStr.split(separator: ",").map(String.init).compactMap(Int.init)
        }

        let joltageReqs: [Int] = String(match.3).split(separator: ",").map(String.init).compactMap(Int.init)

        guard startState.count == joltageReqs.count else { print("Light start state and requirements mismatch"); return nil }

        let lightCount = startState.count // "width" of the machine

        self.lights = (0..<lightCount).map { Light(state: false, startState: startState[$0], joltageLevel: 0, joltageReq: joltageReqs[$0]) }
        self.buttons = buttons.map { LightButton(lightIndices: $0) }

        self.joltageAnswer = lights.map(\.joltageReq)
    }

    /// Press the button, toggling all connected lights
    func pressButton(_ index: Int) {
        guard index < buttons.count else { return }
        let button = buttons[index]

        for idx in button.lightIndices {
            lights[idx].toggle()
        }

        presses.append(index)
    }

    /// Get a copy of this machine in its current state
    func copy() -> JoltageMachine {
        JoltageMachine(lights: lights, buttons: buttons, presses: presses)
    }

    /// Determine what is (one of) the shortest paths to reach the target state measured by button presses
    func findShortestPath() -> (count: Int, pressed: [Int]) {
        guard let winner = search(machines: [self]) else { return (-1, []) }

        let presses = winner.presses
        return (presses.count, presses)
    }

    // Breadth-first search?
    private func search(machines: [JoltageMachine]) -> JoltageMachine? {
        // See if any of the machines matches the target state
        //    If any ARE winners, see which has the shortest path
        //        If other search is shorter, continue but note this? -- HOW?
        //    If no winners
        //        Find which buttons will adjust any light "towards" the target state
        //        Should we sort these by "biggest impact"?

        let winners = machines.filter { $0.startable }
        if winners.isEmpty {
            // no winner keep digging

            // for each machine, create a copy that presses one of each button (except the last one pressed)
            let newMachines: [JoltageMachine] = machines.flatMap { machine in
                let lastPressedButton = machine.presses.last // don't try and press the same button twice (infinite loop)

                return machine.buttons.indices.compactMap { idx -> JoltageMachine? in
                    guard idx != lastPressedButton else { return nil }

                    // let copy = machine // not a struct
                    let copy = machine.copy()
                    copy.pressButton(idx)
                    return copy
                }
            }

            return search(machines: newMachines)
        } else {
            // we have a winner
            return winners.sorted { $0.presses.count < $1.presses.count }.first
        }
    }

    typealias JoltageSearch = ([Int], Int)

    func findJoltageShortestPath() -> Int {
        let currentLights = lights.map(\.joltageLevel) // or Array(repeating: 0, count: lights.count)
        guard let winner = joltageSearch([JoltageSearch(currentLights, 0)]) else { return -1 }
        return winner.1
    }

    private func joltageSearch(_ instances: [JoltageSearch]) -> JoltageSearch? {
        let winners = instances.filter { $0.0 == joltageAnswer }
        if winners.isEmpty {
            // no winners, keep digging

            let invalidInstance = instances.filter { exceededLimits($0.0) }
            assert(invalidInstance.isEmpty) // we should never see this, right?

            // for each machine, create a copy that presses one of each button
            let newInstances: [JoltageSearch] = instances.flatMap { instance in
                buttons.indices.compactMap { idx in
                    let updated = press(button: idx, on: instance)
                    guard !exceededLimits(updated.0) else { return nil }
                    return updated
                }
            }

            return joltageSearch(newInstances) // TODO: should we .unique() them?
        } else {
            // we have a winner
            return winners.first // should all be at the same number of presses
        }
    }

    /// Simulate pressing the button given on the instance, updating joltage levels
    private func press(button: Int, on instance: JoltageSearch) -> JoltageSearch {
        var copy = instance.0
        for idx in buttons[button].lightIndices {
            copy[idx] += 1
        }
        return JoltageSearch(copy, instance.1 + 1)
    }

    /// Have any of the lights exceeded their requirements
    private func exceededLimits(_ instance: [Int]) -> Bool {
        let over = instance.enumerated().filter { (idx, i) in
            i > joltageAnswer[idx]
        }
        // if we have anything in this collection, we've got something over the limit
        return !over.isEmpty
    }

    // MARK: - Static

    /// Regex used for parsing the input to form the machine. Honestly likely easier to use a traditional regex
    static let regex = Regex {
        // Light start configuration
        // format: [..##.]
        "["
        Capture {
            OneOrMore {
                ChoiceOf {
                    "."
                    "#"
                }
            }
        }
        "]"
        OneOrMore(.whitespace)

        // Buttons
        // format: (1) (2,3) (4,5,6)
        Capture {
            OneOrMore {
                "("
                OneOrMore(/\d,?/)
                ")"
                OneOrMore(.whitespace)
            }
        }

        // Joltage requirements
        // format: {1,2,3,4}
        "{"
        OneOrMore {
            Capture {
                OneOrMore(/\d,?/)
            }
        }
        "}"
    }

}
