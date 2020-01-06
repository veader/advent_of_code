//
//  SearchDroid.swift
//  aoc2019
//
//  Created by Shawn Veader on 1/6/20.
//  Copyright © 2020 Shawn Veader. All rights reserved.
//

import Foundation

struct SearchDroid {
    enum SearchInstruction {
        case move(direction: MoveDirection)
        case take(item: String)
        case drop(item: String)
        case inventory

        func ascii() -> [Int] {
            switch self {
            case .move(direction: let direction):
                return direction.stringValue.ascii()
            case .take(item: let item):
                return "take \(item)".ascii()
            case .drop(item: let item):
                return "drop \(item)".ascii()
            case .inventory:
                return "inv".ascii()
            }
        }
    }

    /// Known items we've found
    let knownItems = [
        "hypercube",
        "coin",
        "klein bottle",
        "shell",
        "easter egg",
        "astrolabe",
        "tambourine",
        "dark matter",
    ]

    var determineWeight: Bool = false

    private let machine: IntCodeMachine

    init(instructions: String) {
        machine = IntCodeMachine(instructions: instructions)
        machine.silent = true
    }

    func setGatheringInstructions() {
        let instructions: [SearchInstruction] = [
            .move(direction: .south),
            .move(direction: .south),
            .take(item: "hypercube"),
            .move(direction: .north),
            .move(direction: .north),
            .move(direction: .north),
            .take(item: "tambourine"),
            .move(direction: .east),
            .take(item: "astrolabe"),
            .move(direction: .south),
            .take(item: "shell"),
            .move(direction: .north),
            .move(direction: .east),
            .move(direction: .north),
            .take(item: "klein bottle"),
            .move(direction: .north),
            .take(item: "easter egg"),
            .move(direction: .south),
            .move(direction: .south),
            .move(direction: .west),
            .move(direction: .west),
            .move(direction: .south),
            .move(direction: .west),
            .take(item: "dark matter"),
            .move(direction: .west),
            .move(direction: .north),
            .move(direction: .west),
            .take(item: "coin"),
            .move(direction: .south),
            .inventory,
        ]

        let inputs = instructions.flatMap { $0.ascii() + "\n".ascii() }
        machine.set(inputs: inputs)
    }

    func setGatherProperItemsInstructions() {
        dropAllItems()

        let instructions: [SearchInstruction] = [
            .take(item: "hypercube"),
            .take(item: "coin"),
            .take(item: "tambourine"),
            .take(item: "dark matter"),
        ]
        let inputs = instructions.flatMap { $0.ascii() + "\n".ascii() }
        machine.set(inputs: inputs)
    }

    func run() {
        machine.run()

        while true {
            if case .finished(output: _) = machine.state {
                processOutput()
            } else if case .awaitingInput = machine.state {
                if determineWeight {
                    print("--------------------------------------------------------------")
                    var lightCombinations = [String]()
                    var heavyCombinations = [String]()
                    var triedCombinations = [String]()
                    determineWeightCombinations(items: knownItems, light: &lightCombinations, heavy: &heavyCombinations, tried: &triedCombinations)
                } else {
                    gatherInput()
                }
            }
        }
    }

    private func gatherOutput() -> String {
        let output = machine.outputs // copy
        machine.outputs.removeAll()

        // split up the output into lines (10 -> newline)
        let rawLines = output.split(separator: 10).map(Array.init)

        // convert raw ASCII values back into strings
        let lines = rawLines.map { array -> String in
            array.compactMap { char -> String? in
                guard let scalar = UnicodeScalar(char) else { return nil }
                return String(Character(scalar))
            }.joined()
        }

        return lines.joined(separator: "\n")
    }

    private func processOutput() {
        print("")
        print(gatherOutput())
    }

    private func gatherInput() {
        // gather input from user after outputing text...
        // confirm valid input (should we print choices?)
        //      -> convert to SearchInstruction

        processOutput()

        guard let response = readLine() else {
            print("Couldn't hear you.... try again.")
            processOutput()
            return
        }

        let responseParts = response.split(separator: " ")
        let command = responseParts.first
        var instruction: SearchInstruction

        switch command {
        case "north":
            instruction = .move(direction: .north)
        case "east":
            instruction = .move(direction: .east)
        case "south":
            instruction = .move(direction: .south)
        case "west":
            instruction = .move(direction: .west)
        case "inv", "inventory":
            instruction = .inventory
        case "take":
            let item = String(response.dropFirst(5))
            instruction = .take(item: item)
        case "drop":
            let item = String(response.dropFirst(5))
            instruction = .drop(item: item)
        default:
            print("Huh?")
            gatherInput()
            return
        }

        machine.set(inputs: instruction.ascii() + "\n".ascii())
    }

    private func determineWeightCombinations(items: [String], current: [String] = [], light: inout [String], heavy: inout [String], tried: inout [String]) {
        var remainingItems = items
        while !remainingItems.isEmpty {
            let item = remainingItems.removeFirst()

            let testItems = current + [item]
            let testItemsString = testItems.sorted().joined(separator: ",")

            if !tried.contains(testItemsString) {
                tried.append(testItemsString)

                tryWeighing(items: testItems)

                let output = gatherOutput()
                // print(output)
                if NSString(string: output).contains("are lighter than the detected") {
                    print("** Trying: \(testItems.joined(separator: ","))... TOO HEAVY")
                    heavy.append(testItemsString)
                } else if NSString(string: output).contains("are heavier than the detected") {
                    print("** Trying: \(testItems.joined(separator: ","))... TOO LIGHT")
                    light.append(testItemsString)
                } else {
                    print("** Trying: \(testItems.joined(separator: ","))... Huh?")
                    print(output)
                }
            }

            determineWeightCombinations(items: remainingItems, current: testItems, light: &light, heavy: &heavy, tried: &tried)
        }
    }

    private func dropAllItems() {
        let instructions: [SearchInstruction] = knownItems.map { .drop(item: $0) }
        let inputs = instructions.flatMap { $0.ascii() + "\n".ascii() }
        machine.set(inputs: inputs)
    }

    private func tryWeighing(items: [String]) {
        dropAllItems()
        // _ = gatherInput()

        var instructions: [SearchInstruction] = items.map { .take(item: $0) }
        instructions += [.move(direction: .south)]
        let inputs: [Int] = instructions.flatMap { $0.ascii() + "\n".ascii() }
        machine.set(inputs: inputs)
    }
}
