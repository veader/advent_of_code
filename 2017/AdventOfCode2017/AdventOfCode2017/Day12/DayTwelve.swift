//
//  DayTwelve.swift
//  AdventOfCode2017
//
//  Created by Shawn Veader on 12/12/17.
//  Copyright © 2017 v8logic. All rights reserved.
//

import Foundation

struct DayTwelve: AdventDay {

    struct Village {
        struct Pipe {
            let origin: Int
            let destinations: [Int]

            init?(_ input: String) {
                // input should be of the format:
                // 1 <-> 5, 4, 6
                guard let pipeRange = input.range(of: "<->") else { return nil }

                let originString = String(input[input.startIndex..<pipeRange.lowerBound])
                guard let theOrigin = Int(originString.trimmed()) else { return nil}
                origin = theOrigin

                let destinationString = String(input[pipeRange.upperBound...])
                destinations = destinationString.split(separator: ",")
                                                .map { String($0).trimmed() }
                                                .flatMap(Int.init).sorted()
            }
        }

        let programs: [Int: Pipe]

        init(_ input: String) {
            let lines = input.split(separator: "\n").map(String.init)
            let pipes = lines.flatMap(Pipe.init)

            programs = Dictionary(uniqueKeysWithValues: pipes.map { pipe -> (Int, Pipe) in
                return (pipe.origin, pipe)
            })
        }

        func connected(to root: Int, visited: [Int] = [Int]()) -> [Int] {
            var connectedTo = visited

            if !connectedTo.contains(root) {
                connectedTo.append(root)
            }

            if let pipe = programs[root] {
                for destination in pipe.destinations {
                    if !connectedTo.contains(destination) {
                        // follow the white rabbit
                        let destConnections = connected(to: destination, visited: connectedTo)
                        connectedTo.append(contentsOf: destConnections)
                    }
                }
            }

            return Array(Set(connectedTo)) // unique them
        }
    }

    // MARK: -

    func defaultInput() -> String? {
        let path = "\(dataPath())/day12input.txt"
        return try? String(contentsOfFile: path, encoding: .utf8)
    }

    func run(_ input: String? = nil) {
        guard let runInput = input ?? defaultInput() else {
            print("Day 12: 💥 NO INPUT")
            exit(10)
        }

        let thing = partOne(input: runInput)
        guard let answer = thing else {
            print("Day 12: (Part 1) 💥 Unable to calculate answer.")
            exit(1)
        }
        print("Day 12: (Part 1) Answer ", answer)

        // ...
    }

    // MARK: -

    func partOne(input: String) -> Int? {
        let village = Village(input)
        let connections = village.connected(to: 0)
        return connections.count
    }

    func partTwo(input: String) -> Int? {
        return nil
    }
}
