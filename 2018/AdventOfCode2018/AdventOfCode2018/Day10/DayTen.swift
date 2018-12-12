//
//  DayTen.swift
//  AdventOfCode2018
//
//  Created by Shawn Veader on 12/11/18.
//  Copyright © 2018 Shawn Veader. All rights reserved.
//

import Foundation

struct DayTen: AdventDay {
    var dayNumber: Int = 10

    struct Sky: CustomDebugStringConvertible {
        var lights: [Light]

        let minCoord: Coordinate
        let maxCoord: Coordinate

        init(lights: [Light]) {
            self.lights = lights

            let minX = (lights.map { $0.position.x }.min()) ?? 0
            let minY = (lights.map { $0.position.y }.min()) ?? 0
            let maxX = (lights.map { $0.position.x }.max()) ?? 0
            let maxY = (lights.map { $0.position.y }.max()) ?? 0

            maxCoord = Coordinate(x: maxX, y: maxY)
            minCoord = Coordinate(x: minX, y: minY)
        }

        mutating func tick() {
            let theLights = lights
            lights = theLights.map { $0.move() }
        }

        mutating func untick() {
            let theLights = lights
            lights = theLights.map { $0.move(time: -1) }
        }

        func minCoordinate() -> Coordinate {
            let minX = (lights.map { $0.position.x }.min()) ?? 0
            let minY = (lights.map { $0.position.y }.min()) ?? 0

            return Coordinate(x: minX, y: minY)
        }

        func maxCoordinate() -> Coordinate {
            let maxX = (lights.map { $0.position.x }.max()) ?? 0
            let maxY = (lights.map { $0.position.y }.max()) ?? 0

            return Coordinate(x: maxX, y: maxY)
        }

        func maxWidth() -> Int {
            let min = minCoordinate()
            let max = maxCoordinate()

            return abs(max.x - min.x)
        }

        func maxHeight() -> Int {
            let min = minCoordinate()
            let max = maxCoordinate()

            return abs(max.y - min.y)
        }

        func printDimensions() -> String {
            return "W:\(maxWidth()) | H:\(maxHeight())"
        }

        func printableSky(consistentDimensions: Bool = true) -> String {
            var output = ""

            var min = minCoord
            var max = maxCoord

            if !consistentDimensions {
                min = minCoordinate()
                max = maxCoordinate()
            }

            for y in (min.y...max.y) {
                var row = ""
                for x in (min.x...max.x) {
                    let c = Coordinate(x: x, y: y)
                    row += lights.contains(where: { $0.position == c }) ? "#" : "."
                }
                output += "\(row)\n"
            }

            return output
        }

        var debugDescription: String {
            return printableSky(consistentDimensions: true)
        }
    }

    struct Light {
        let position: Coordinate
        let velocity: Coordinate

        /// Returns a new light with updated position based on velocity and given time.
        func move(time: Int = 1) -> Light {
            let updatedPosition = Coordinate(x: self.position.x + self.velocity.x * time,
                                             y: self.position.y + self.velocity.y * time)
            return Light(position: updatedPosition, velocity: self.velocity)
        }
    }

    @discardableResult func run(_ input: String? = nil, _ part: Int? = 1) -> Any {
        guard let input = input ?? defaultInput else {
            print("Day \(dayNumber): NO INPUT")
            exit(10)
        }

        let lights = parse(input: input)

        if part == 1 {
            let answer = partOne(lights: lights)
            print("Day \(dayNumber) Part \(part!): Final Answer \(answer)")
            return answer
        } else {
            return ""
//            let answer = partTwo(tree: tree)
//            print("Day \(dayNumber) Part \(part!): Final Answer \(answer)")
//            return answer
        }
    }

    func partOne(lights: [Light]) -> String {
        var sky = Sky(lights: lights)

        var seconds = 0
        var watchedWidth = Int.max
        var watchedHeight = Int.max

        while (true) {
            let width = sky.maxWidth()
            let height = sky.maxHeight()

            // look for the inflection point where we hit the smallest area
            if width <= watchedWidth {
                watchedWidth = width
            } else {
                break
            }

            if height <= watchedHeight {
                watchedHeight = height
            } else {
                break
            }

//            print("Tick: \(seconds) | \(sky.printDimensions())")
            sky.tick()
            seconds += 1
        }

        sky.untick()
        print(sky.printableSky(consistentDimensions: false))

        return ""
    }

//    func partTwo(tree: LicenseTree) -> Int {
//        guard let rootNode = tree.rootNode else { return Int.min }
//        return sumNodeValue(for: rootNode)
//    }


    func parse(input: String) -> [Light] {
        let lightRegx = "position=<(.*?),(.*?)> velocity=<(.*?),(.*?)>"

        return input.split(separator: "\n")
                    .map(String.init)
                    .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                    .compactMap {
                        guard let match = $0.matching(regex: lightRegx) else { return nil }

                        let captures = match.captures
                                            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                                            .compactMap(Int.init)
                        guard captures.count == 4 else { return nil }

                        return Light(position: Coordinate(x: Int(captures[0]), y: Int(captures[1])),
                                     velocity: Coordinate(x: Int(captures[2]), y: Int(captures[3])))
                    }
    }
}
