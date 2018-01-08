//
//  DayTwentyFour.swift
//  AdventOfCode2017
//
//  Created by Shawn Veader on 1/7/18.
//  Copyright © 2018 v8logic. All rights reserved.
//

import Foundation

struct DayTwentyFour: AdventDay {

    struct BridgeBuilder {
        struct Component: Equatable, CustomDebugStringConvertible {
            let ports: [Int]

            var debugDescription: String {
                return ports.map { String($0) }.joined(separator: "/")
            }

            var strength: Int {
                return ports.reduce(0, +)
            }

            init?(_ input: String) {
                ports = input.trimmed().split(separator: "/").map { String($0) }.flatMap { Int($0) }
                guard ports.count == 2 else { return nil }
            }

            /// Does this component have a port matching the one given?
            func has(port: Int) -> Bool {
                return ports.contains(port)
            }

            /// The port on the other side of the component.
            func otherSide(port: Int) -> Int {
                guard ports.first != ports.last else { return ports.first! }
                guard let other = ports.first(where: { $0 != port }) else { return -1 }
                return other
            }

            static func ==(lhs: DayTwentyFour.BridgeBuilder.Component, rhs: DayTwentyFour.BridgeBuilder.Component) -> Bool {
//                let sortedLHS = lhs.ports.sorted()
//                let sortedRHS = rhs.ports.sorted()
                return String(describing: lhs) == String(describing: rhs)
            }
        }

        struct Bridge: CustomDebugStringConvertible {
            let components: [Component]
            var endPort: Int = 0

            var debugDescription: String {
                // TODO: put them in order...
                return components.map { String(describing: $0) }.joined(separator: "--") + " End: \(endPort) | Strength: \(strength)"
            }

            var strength: Int {
                return components.reduce(0, { (result, component) -> Int in
                    return result + component.strength
                })
            }
        }

        let components: [Component]

        init(_ input: String) {
            components = input.split(separator: "\n")
                              .map { String.init($0).trimmed() }
                              .flatMap { Component($0) }
        }

        func strongestBridge() -> Bridge? {
            let bridges = possibleBridges(available: components)
            return bridges.max { (bridgeA, bridgeB) -> Bool in
                return bridgeA.strength < bridgeB.strength
            }
        }

        func possibleBridges(starting: Bridge? = nil, available: [Component]) -> [Bridge] {
            guard available.count > 0 else { return [Bridge]() }

            var bridges = [Bridge]()

            // if we have no starting bridge, we need a 0 port
            let startingPort = starting?.endPort ?? 0

            // look for available components with ports matching starting port
            let nextComponents = available.filter { $0.has(port: startingPort) }

            for component in nextComponents {
                // build a new bridge by adding this new component
                let endPort = component.otherSide(port: startingPort)
                var newComponents = starting?.components ?? [Component]()
                newComponents.append(component)

                let bridge = Bridge(components: newComponents, endPort: endPort)
                bridges.append(bridge) // single segment is a valid bridge
                print(bridge)

                guard available.count > 1 else { continue }

                var newAvailable = available

                // remove this used component from the list of available components for nested calls
                if let componentIndex = available.index(of: component) {
                    newAvailable.remove(at: componentIndex)
                }

//                let newAvailable = Array(available.drop(while: { $0 == component }))
                assert(newAvailable.count < available.count)

                // build possible bridges based on this new starting bridge
                let bridgesBuilt = possibleBridges(starting: bridge, available: newAvailable)
                bridges.append(contentsOf: bridgesBuilt)
            }

            return bridges
        }
    }


    // MARK: -

    func defaultInput() -> String? {
        let path = "\(dataPath())/day24input.txt"
        return try? String(contentsOfFile: path, encoding: .utf8)
    }

    func run(_ input: String? = nil) {
        guard let runInput = input ?? defaultInput() else {
            print("Day 24: 💥 NO INPUT")
            exit(10)
        }

        let thing = partOne(input: runInput)
        guard let answer = thing else {
            print("Day 24: (Part 1) 💥 Unable to calculate answer.")
            exit(1)
        }
        print("Day 24: (Part 1) Answer ", answer)

        // ...
    }

    // MARK: -

    func partOne(input: String) -> Int? {
        let builder = BridgeBuilder(input)
        let bridge = builder.strongestBridge()
        return bridge?.strength
    }

    func partTwo(input: String) -> Int? {
        return nil
    }
}
