//
//  DayThirteen.swift
//  AdventOfCode2017
//
//  Created by Shawn Veader on 12/13/17.
//  Copyright © 2017 v8logic. All rights reserved.
//

import Foundation

struct DayThirteen: AdventDay {

    class Firewall {
        class Layer {
            // direction of current travel in layer
            enum LayerDirection {
                case forward
                case backward
            }

            let index: Int
            let range: Int
            var currentLocation: Int = 0
            var direction: LayerDirection = .forward

            init?(_ input: String) {
                // format: "0: 2"
                let pieces = input.split(separator: ":").map { String($0).trimmed() }

                guard
                    pieces.count > 1,
                    let theIndex = Int(pieces[0]),
                    let theRange = Int(pieces[1])
                    else { return nil }

                self.index = theIndex
                self.range = theRange
            }

            func reset(delay: Int? = nil) {
                currentLocation = 0
                direction = .forward

                if let delay = delay {
                    // a whole trip down/back for sentry (will be at 0 index)
                    let wholeTrip = (range - 1) * 2

                    // figure out how many ticks to do after the last full trip
                    let tickCount = delay % wholeTrip

                    for _ in (0..<tickCount) {
                        tick()
                    }
                }
            }

            // for each "tick", move currnet location within range
            func tick() {
                switch direction {
                case .forward:
                    if currentLocation == (range - 1) {
                        direction = .backward
                        currentLocation -= 1
                    } else {
                        currentLocation += 1
                    }
                case .backward:
                    if currentLocation == 0 {
                        direction = .forward
                        currentLocation += 1
                    } else {
                        currentLocation -= 1
                    }
                }
            }
        }

        let layers: [Int: Layer]
        var location: Int = -1 // start outside firewall
        let maxLayerIndex: Int
        let maxDepth: Int
        var shouldPrint: Bool = false
        var avoidCaptures: Bool = false

        init(_ input: String) {
            let lines = input.split(separator: "\n").map { String($0).trimmed() }
            let theLayers = lines.flatMap(Layer.init)

            layers = Dictionary(uniqueKeysWithValues: theLayers.map { layer -> (Int, Layer) in
                return (layer.index, layer)
            })

            maxLayerIndex = layers.keys.max() ?? 0
            maxDepth = layers.values.map { $0.range }.max() ?? 0
        }

        /// Run the firewall for a given amount of picoseconds. Returns whole trip penalty
        func run(delay: Int = 0, time: Int? = nil) -> Int {
            if delay > 0 {
                for _ in (0..<delay) {
                    tick()
                }

                if shouldPrint {
                    print("State after delaying \(delay):")
                    printState()
                }
            } else {
                if shouldPrint {
                    print("Initial state:")
                    printState()
                }
            }

            var tripSeverity = 0
            var picosecond = delay

            while location < maxLayerIndex {
                if let time = time {
                    guard picosecond < time else { print("Out of time!"); break }
                }

                if shouldPrint { print("Picosecond \(picosecond):") }

                let penalty = move()
                tripSeverity += penalty

                if avoidCaptures && penalty > 0 {
                    // if we are captured and should be avoiding break out to save time
                    print(".", separator: "", terminator: "")
                    if delay % 500 == 0 {
                        print("\n\(delay)")
                    }
                    // print("Caught after \(delay) picosecond delay after \(picosecond - delay) more.")
                    break
                }

                tick()
                printState()
                picosecond += 1
            }

            return tripSeverity
        }

        /// Tick a picosecond by and move sentries in layers of the firewall
        func tick() {
            for layer in layers.values {
                layer.tick()
            }
        }

        /// Move within the layers of the firewall, returns penalty value for getting caught
        func move() -> Int {
            location += 1
            printState()

            guard let layer = layers[location] else { return 0 }
            if layer.currentLocation == 0 {
                if shouldPrint { print("Caught! \(layer.index) * \(layer.range)") }

                // add some extra to the penalty if we are avoiding getting caught so
                //  that getting caught in the 0 layer still reports a penalty
                let extraPenalty = avoidCaptures ? 100 : 0
                return (layer.index * layer.range) + extraPenalty
            }

            return 0
        }

        /// Reset the state of the firewall to the beginning
        func reset(delay: Int? = nil) {
            location = -1

            for layer in layers.values {
                layer.reset(delay: delay)
            }
        }

        func printState() {
            // print all indexes
            var output: [String]

            let layersRange = 0...maxLayerIndex
            let depthRange = 0...maxDepth

            output = layersRange.map{ (idx) -> String in
                return String(idx).centered(width: 3)
            }
            if shouldPrint { print(output.joined(separator: " ")) }

            let empty = "   "
            for depth in depthRange {
                output = layersRange.map{ (idx) -> String in
                    guard let layer = layers[idx] else {
                        // no layer, show dots at top depth
                        if depth == 0 {
                            return idx == location ? "(.)" : "..."
                        } else {
                            return empty
                        }
                    }

                    if layer.range > depth {
                        if layer.currentLocation == depth {
                            return idx == location && depth == 0 ? "(S)" : "[S]"
                        } else {
                            return idx == location && depth == 0 ? "( )" : "[ ]"
                        }
                    } else {
                        return empty
                    }
                }
                if shouldPrint { print(output.joined(separator: " ")) }
            }
        }

        func depth(at index: Int) -> Int {
            guard let layer = layers[index] else { return 0 }
            return layer.range
        }
    }

    // MARK: -

    func defaultInput() -> String? {
        let path = "\(dataPath())/day13input.txt"
        return try? String(contentsOfFile: path, encoding: .utf8)
    }

    func run(_ input: String? = nil) {
        guard let runInput = input ?? defaultInput() else {
            print("Day 13: 💥 NO INPUT")
            exit(10)
        }

        let thing = partOne(input: runInput)
        guard let answer = thing else {
            print("Day 13: (Part 1) 💥 Unable to calculate answer.")
            exit(1)
        }
        print("Day 13: (Part 1) Answer ", answer)

        let thing2 = partTwo(input: runInput)
        guard let answer2 = thing2 else {
            print("Day 13: (Part 2) 💥 Unable to calculate answer.")
            exit(1)
        }
        print("Day 13: (Part 2) Answer ", answer2)
    }

    // MARK: -

    func partOne(input: String) -> Int? {
        let firewall = Firewall(input)
        // firewall.shouldPrint = true
        return firewall.run()
    }

    func partTwo(input: String) -> Int? {
        let firewall = Firewall(input)
        firewall.avoidCaptures = true

        var penalty = 1_000_000 // go through loop at least once
        var delay = 82_500 // 0

        repeat {
            delay += 1
            firewall.reset()
            penalty = firewall.run(delay: delay)
        } while penalty > 0

        return delay
    }
}

