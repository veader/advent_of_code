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

    let asciiMap: [String: Int] = {
        var map = [String: Int]()
        let aValue = 65 // A

        for i in (0..<26) {
            let asciiValue = aValue + i
            let char = Character(UnicodeScalar(asciiValue)!)
            map["\(char)"] = i + 1
        }

        return map
    }()

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

        if part == 1 {
            let answer = partOne(instructions: instructions)
            print("Day \(dayNumber) Part \(part!): Final Answer \(answer)")
            return answer
        } else {
            let answer = partTwo(instructions: instructions)
            print("Day \(dayNumber) Part \(part!): Final Answer \(answer)")
            return answer
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

    func partTwo(instructions: Instructions) -> Int {
        return work(instructions: instructions, workers: 5, offset: 60)
    }

    /// Work the instructions with the given number of parallel workers and an offset of number of seconds
    func work(instructions: Instructions, workers workerCount: Int = 1, offset: Int = 0) -> Int {
        // count the number of seconds taken doing work
        var timeTaken = 0

        // list of steps that have been processed (so nothing is repeated)
        var takenSteps = [String]()

        // represent the workers with an array indicating how many seconds
        //      each worker has left until they are not busy
        var busyWorkers = Array(repeating: 0, count: workerCount)

        // represent the steps being worked by each worker
        var busyWorkSteps = Array(repeating: "", count: workerCount)

        let beginnings = findBeginnings(instructions: instructions)
        var choices = Set(beginnings)

        while !choices.isEmpty {
            // tick off a second for everyone's time
            busyWorkers = busyWorkers.map { max($0 - 1, 0) }

            // determine how many workers we have available, if all are busy
            //      tick off a second and loop (brute force up front)
            let availableWorkers = busyWorkers.filter { $0 == 0 }.count

            if availableWorkers == 0 {
                // all workers are busy...
            } else {
                // we have some available workers

                // remove steps that have been completed
                for (idx, workTimer) in busyWorkers.enumerated() {
                    if workTimer == 0 {
                        takenSteps.append(busyWorkSteps[idx])
                        busyWorkSteps[idx] = ""
                    }
                }

//                // tick off a second for everyone's time
//                busyWorkers = busyWorkers.map { max($0 - 1, 0) }

                // determine how many available instructions we have now that
                //      have their prereqs met. pick ones to work on (based
                //      on number of workers) and add their times to the worker
                //      queue. remove them from choices and add their next steps.
                let availableChoices = choices.sorted().filter { name -> Bool in
                    guard let inst = instructions[name] else { return false }
                    var preReqsMet = true
                    for preReq in inst.prereqs {
                        if !takenSteps.contains(preReq) {
                            preReqsMet = false
                            break
                        }
                    }
                    return preReqsMet
                }

                // only act on as many choices as we have workers
                for choice in availableChoices {
                    guard let freeWorkerIdx = busyWorkers.firstIndex(of: 0) else { break } // no more free workers

                    // remove this instruction step as an available choice to work
                    if let choiceIdx = choices.firstIndex(of: choice) {
                        choices.remove(at: choiceIdx)
                    }

                    if let instruction = instructions[choice] {
                        // set work as busy with amount of time to work
                        let workTime = (asciiMap[instruction.name] ?? 0) + offset
                        busyWorkers[freeWorkerIdx] = workTime
                        busyWorkSteps[freeWorkerIdx] = instruction.name

                        // add next steps to choices
                        choices = choices.union(instruction.nextSteps)
                    }
                }
            }

            // printState(time: timeTaken, workers: busyWorkers, work: busyWorkSteps, finished: takenSteps.joined())

            timeTaken += 1
        }

        // finished all the choices but there may still be work being done
        //      take the max value and add it to the timeTaken
        if let timeLeft = busyWorkers.max() {
            timeTaken += (timeLeft - 1) // one loop was done just not counted
        }

        return timeTaken
    }

    func printState(time: Int, workers: [Int], work: [String], finished: String) {
        let workersInfo = workers.enumerated().map {
            let step = work[$0]
            return "\(step)(\($1))"
        }.joined(separator: "\t")

        print("\(time)\t\(workersInfo)\t\(finished)")
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
