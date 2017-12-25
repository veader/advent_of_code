//
//  DayTwenty.swift
//  AdventOfCode2017
//
//  Created by Shawn Veader on 12/23/17.
//  Copyright © 2017 v8logic. All rights reserved.
//

import Foundation

struct DayTwenty: AdventDay {

    struct Vector: Hashable, CustomDebugStringConvertible {
        var x: Int
        var y: Int
        var z: Int

        var debugDescription: String {
            return "<\(x),\(y),\(z)>"
        }

        var hashValue: Int {
            return x.hashValue ^ y.hashValue ^ z.hashValue &* 16777619
        }

        init() {
            x = 0; y = 0; z = 0
        }

        init?(_ input: String) {
            // input may be in the form "=<1,2,3>" or "1,2,3"
            var start = input.startIndex
            if let openAngle = input.index(of: "<") {
                start = input.index(after: openAngle)
            }
            let end = input.index(of: ">") ?? input.endIndex
            let substring = String(input[start..<end])

            let components = substring.split(separator: ",")
                                      .map { String($0).trimmed() }
                                      .flatMap(Int.init)

            guard components.count == 3 else { return nil }
            x = components[0]
            y = components[1]
            z = components[2]
        }

        static func == (lhs: Vector, rhs: Vector) -> Bool {
            return  lhs.x == rhs.x &&
                lhs.y == rhs.y &&
                lhs.z == rhs.z
        }

        static func origin() -> Vector {
            return Vector("0,0,0")!
        }

        func update(with other: Vector) -> Vector {
            var newVector = Vector()
            newVector.x = self.x + other.x
            newVector.y = self.y + other.y
            newVector.z = self.z + other.z
            return newVector
        }
    }

    struct Particle: CustomDebugStringConvertible {
        let index: Int
        var position: Vector
        var velocity: Vector
        let acceleration: Vector

        var debugDescription: String {
            return "<Particle: index=\(index) p=\(position) v=\(velocity) a=\(acceleration)>"
        }

        init?(index: Int, _ input: String) {
            self.index = index

            let components = input.split(separator: "=").map(String.init)
            // should have "p", "=....v", "=...a", "=..."
            guard components.count == 4 else { return nil }

            guard let p = Vector(components[1]) else { return nil }
            position = p

            guard let v = Vector(components[2]) else { return nil }
            velocity = v

            guard let a = Vector(components[3]) else { return nil }
            acceleration = a
        }

        mutating func update() {
            velocity = velocity.update(with: acceleration)
            position = position.update(with: velocity)
        }

        func distance(to other: Vector?) -> Int {
            let vector = other ?? Vector.origin()
            let x = abs(position.x - vector.x)
            let y = abs(position.y - vector.y)
            let z = abs(position.z - vector.z)
            return x + y + z
        }
    }

    struct GPU {
        var particles: [Particle] = [Particle]()

        init(_ input: String) {
            let lines = input.split(separator: "\n").map(String.init)
            particles = lines.enumerated().flatMap { idx, line in
                return Particle(index: idx, line)
            }
            // print("Found \(particles.count) particles")
        }

        mutating func run(cycles: Int = 100) -> Int {
            var closestIndex: Int = 0

            for cycle in (0..<cycles) {
                for idx in (0..<particles.count) {
                    particles[idx].update()
                }

                // create tuples of (index, distance)
                let distances: [(Int, Int)] = particles.map { particle -> (Int, Int) in
                    return (particle.index, particle.distance(to: Vector.origin()))
                }

                // find minimum distance and grab index from tuple
                if let closest = distances.min(by: { $0.1 < $1.1 }) {
                    closestIndex = closest.0
                } else {
                    // print("Cycle \(cycle): Unable to find closest particle.")
                }

                let closestParticle = particles[closestIndex]
                // print("Cycle \(cycle+1): Closests Particle: \(closestParticle)")
            }

            return closestIndex
        }

        mutating func detectCollisions(cycles: Int = 100) -> Int {
            for cycle in (0..<cycles) {
                for idx in (0..<particles.count) {
                    particles[idx].update()
                }

                // detect collsions ------
                // find all positions
                let positions = particles.map { $0.position }
                let positionSet = Set<Vector>(positions)
                if positionSet.count < particles.count {
                    var particlesToRemove = [Particle]()

                    for position in positionSet {
                        let collidingParticles = particles.filter { $0.position == position }
                        if collidingParticles.count > 1 {
                            particlesToRemove.append(contentsOf: collidingParticles)
                        }
                    }

                    for particle in particlesToRemove {
                        if let index = particles.index(where: { $0.index == particle.index }) {
                            particles.remove(at: index)
                        }
                    }
                }

                // print("Cycle \(cycle+1): Particle Count = \(particles.count)")
            }

            return particles.count
        }
    }


    // MARK: -

    func defaultInput() -> String? {
        let path = "\(dataPath())/day20input.txt"
        return try? String(contentsOfFile: path, encoding: .utf8)
    }

    func run(_ input: String? = nil) {
        guard let runInput = input ?? defaultInput() else {
            print("Day 20: 💥 NO INPUT")
            exit(10)
        }

        let thing = partOne(input: runInput)
        guard let answer = thing else {
            print("Day 20: (Part 1) 💥 Unable to calculate answer.")
            exit(1)
        }
        print("Day 20: (Part 1) Answer ", answer)
        print("------")

        let thing2 = partTwo(input: runInput)
        guard let answer2 = thing2 else {
            print("Day 20: (Part 2) 💥 Unable to calculate answer.")
            exit(1)
        }
        print("Day 20: (Part 2) Answer ", answer2)
    }

    // MARK: -

    func partOne(input: String) -> Int? {
        var gpu = GPU(input)
        return gpu.run(cycles: 1000)
    }

    func partTwo(input: String) -> Int? {
        var gpu = GPU(input)
        return gpu.detectCollisions(cycles: 1000)
    }
}

