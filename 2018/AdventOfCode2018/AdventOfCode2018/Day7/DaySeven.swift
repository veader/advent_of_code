//
//  DaySeven.swift
//  AdventOfCode2018
//
//  Created by Shawn Veader on 12/7/18.
//  Copyright © 2018 Shawn Veader. All rights reserved.
//

import Foundation

struct DaySeven: AdventDay {
    var dayNumber: Int = 7

    typealias Instructions = [String: Instruction]

    struct Instruction {
        let name: String
        let prereqs: [String]
        let nextSteps: [String]

        func adding(prereq: String) -> Instruction {
            var updatedPrereqs = prereqs
            updatedPrereqs.append(prereq)
            updatedPrereqs.sort()

            return Instruction(name: self.name,
                               prereqs: updatedPrereqs,
                               nextSteps: nextSteps)
        }

        func adding(nextStep: String) -> Instruction {
            var updatedNextSteps = nextSteps
            updatedNextSteps.append(nextStep)
            updatedNextSteps.sort()

            return Instruction(name: self.name,
                               prereqs: self.prereqs,
                               nextSteps: updatedNextSteps)
        }
    }

    @discardableResult func run(_ input: String? = nil, _ part: Int? = 1) -> Any {
        guard let input = input ?? defaultInput else {
            print("Day \(dayNumber): NO INPUT")
            exit(10)
        }

        let instructions = parse(input: input)
//        instructions.values.forEach { print($0) }

        if part == 1 {
            let answer = partOne(instructions: instructions)
            print("Day \(dayNumber) Part \(part!): Final Answer \(answer)")
            return answer
        } else {
            return 0
//            let answer = partTwo(grid: grid)
//            print("Day \(dayNumber) Part \(part!): Final Answer \(answer)")
//            return answer
        }
    }

    func partOne(instructions: Instructions) -> String {
        var steps = ""

        let beginnings = findBeginnings(instructions: instructions)
        var choices = Set(beginnings)

        while !choices.isEmpty {
            // take first choice (alphabettically) which has it's prereqs met
            //      and look at it's next steps...
            guard let firstChoice = choices.sorted().first(where: { name -> Bool in
                guard let inst = instructions[name] else { return false }
                var preReqsMet = true
                for preReq in inst.prereqs {
                    if !steps.contains(preReq) {
                        preReqsMet = false
                        break
                    }
                }
                return preReqsMet
            }) else { break }

            if let idx = choices.firstIndex(of: firstChoice) {
                choices.remove(at: idx)
            }

            steps.append(firstChoice)
            if let instruction = instructions[firstChoice] {
                choices = choices.union(instruction.nextSteps)
            }
        }

        return steps
    }

    func findBeginnings(instructions: Instructions) -> [String] {
        return instructions.filter { $1.prereqs.isEmpty }.values.map { $0.name }
    }

    func findEnding(instructions: Instructions) -> String? {
        let endings = instructions.filter { $1.nextSteps.isEmpty }.values

        if endings.count == 1, let theEnd = endings.first {
            return theEnd.name
        } else if endings.count > 1 {
            print("WE HAVE MULTIPLE ENDINGS!!!")
        }

        return nil
    }

    func parse(input: String) -> Instructions {
        var instructions = Instructions()

        let lines = input.split(separator: "\n").map(String.init)
        for line in lines {
            if let steps = parse(line: line) {
                // add the prereq step
                if let nextStep = instructions[steps.nextStep] {
                    instructions[steps.nextStep] = nextStep.adding(prereq: steps.prereq)
                } else {
                    instructions[steps.nextStep] = Instruction(name: steps.nextStep, prereqs: [steps.prereq], nextSteps: [])
                }

                // add the next step
                if let prereq = instructions[steps.prereq] {
                    instructions[steps.prereq] = prereq.adding(nextStep: steps.nextStep)
                } else {
                    instructions[steps.prereq] = Instruction(name: steps.prereq, prereqs: [], nextSteps: [steps.nextStep])
                }
            }
        }

        return instructions
    }

    func parse(line: String) -> (prereq: String, nextStep: String)? {
        // format: Step C must be finished before step A can begin.
        let pattern = "([A-Z]) must be finished before step ([A-Z])"
        if let match = line.matching(regex: pattern),
            match.captures.count == 2,
            let first = match.captures.first,
            let second = match.captures.last {

            return (prereq: first, nextStep: second)
        }

        return nil
    }
}
