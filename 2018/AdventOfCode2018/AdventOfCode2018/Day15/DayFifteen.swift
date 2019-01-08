//
//  DayFifteen.swift
//  AdventOfCode2018
//
//  Created by Shawn Veader on 12/18/18.
//  Copyright © 2018 Shawn Veader. All rights reserved.
//

import Foundation

extension Array where Element : CreatureLike {
    func sortedForReadability() -> [Element] {
        return self.sorted(by: {
            if $0.position.y == $1.position.y {
                return $0.position.x < $1.position.x
            } else {
                return $0.position.y < $1.position.y
            }
        })
    }
}

extension Array where Element : CoordinateLike {
    func sortedForReadability() -> [Element] {
        return self.sorted(by: {
            if $0.y == $1.y {
                return $0.x < $1.x
            } else {
                return $0.y < $1.y
            }
        })
    }
}

protocol CreatureLike {
    var position: Coordinate { get set }
}

struct DayFifteen: AdventDay {
    var dayNumber: Int = 15

    struct Creature: CreatureLike, CustomDebugStringConvertible, Equatable {
        enum CreatureType: Character {
            case goblin = "G"
            case elf = "E"
        }

        let creatureType: CreatureType
        var position: Coordinate
        var hitPoints: Int
        let attackPower: Int

        var dead: Bool {
            return hitPoints <= 0
        }

        var debugDescription: String {
            return "Creature(\(creatureType) @ \(position.x)x\(position.y) HP:\(hitPoints))"
        }

        init(type: CreatureType, position: Coordinate, attackPower: Int = 3) {
            self.creatureType = type
            self.position = position
            self.hitPoints = 200
            self.attackPower = attackPower
        }

        mutating func move(to newLocation: Coordinate) {
            position = newLocation
        }

        mutating func attacked(for attack: Int) {
            hitPoints -= attack
        }
    }

    struct CaveMap {
        enum CaveSegment: Character {
            case wall = "#"
            case empty = "."
        }

        var map: [[CaveSegment]]
        var creatures: [Creature]

        init(input: [String]) {
            var caveMap = [[CaveSegment]]()
            var caveCreatures = [Creature]()

            for (y, line) in input.enumerated() {
                var row = [CaveSegment]()

                for (x, char) in line.enumerated() {
                    let location = Coordinate(x: x, y: y)

                    if let segmentType = CaveSegment(rawValue: char) {
                        row.append(segmentType)
                    } else {
                        if let creatureType = Creature.CreatureType(rawValue: char) {
                            let creature = Creature(type: creatureType, position: location)
                            caveCreatures.append(creature)
                        } else {
                            print("Unknown thing at \(location) -> \(char)")
                        }
                        row.append(.empty)
                    }
                }
                caveMap.append(row)
            }

            // TODO: optimization - store and update set of creature locations
            map = caveMap
            creatures = caveCreatures
        }

        func enemies(of creature: Creature) -> [Creature] {
            return creatures.filter({
                $0.creatureType != creature.creatureType &&
                !$0.dead
            })
        }

        func attackableEnemies(of creature: Creature) -> [Creature]? {
            let foes = enemies(of: creature)
            let enemyLocations = Set(foes.map { $0.position })
            let attackableSpots = adjacentSpots(around: creature.position).intersection(enemyLocations)

            guard !attackableSpots.isEmpty else { return nil }

            let attackableFoes = foes.filter { attackableSpots.contains($0.position) }
            let lowestHP = attackableFoes.map { $0.hitPoints }.min()
            let weakestFoes = attackableFoes.filter { $0.hitPoints == lowestHP }
            return weakestFoes.sortedForReadability()
        }

        func adjacentSpots(around c: Coordinate) -> Set<Coordinate> {
            let coordinates = [Coordinate(x: c.x, y: c.y - 1),
                               Coordinate(x: c.x, y: c.y + 1),
                               Coordinate(x: c.x - 1, y: c.y),
                               Coordinate(x: c.x + 1, y: c.y)]
            return Set(coordinates.filter { isValid(location: $0) })
        }

        func emptyAdjacentSpots(around c: Coordinate) -> Set<Coordinate> {
            let creatureLocations = creatures.map { $0.position }

            return Set(adjacentSpots(around: c).filter({
                !creatureLocations.contains($0) &&
                map[$0.y][$0.x] == .empty
            }))
        }

        func isValid(location c: Coordinate) -> Bool {
            return (0..<map.count).contains(c.y) &&
                   (0..<map[c.y].count).contains(c.x)
        }

        // if the spot is empty and is not occupied by a creature
        func isEmpty(_ c: Coordinate) -> Bool {
            return  isValid(location: c) &&
                    map[c.y][c.x] == .empty &&
                    !creatures.map { $0.position }.contains(c)
        }

        func nextDestinations(for creature: Creature) -> (map: [[Int]], destinations: [Coordinate])? {
            // make sure we can't already attack anyone... (saves us some work)
            let foes = enemies(of: creature)
            let enemyLocations = Set(foes.map { $0.position })
            let attackableFoeSpots = adjacentSpots(around: creature.position).intersection(enemyLocations)
            guard attackableFoeSpots.isEmpty else { return nil }

            var spotsConsidered = Set<Coordinate>()
            var nextLayer = Set<Coordinate>()
            var destinations = [Coordinate]()

            // build move map. start with everything being max except starting point.
            var moveMap = Array(repeating: Array(repeating: Int.max, count: map.first!.count), count: map.count)
            moveMap[creature.position.y][creature.position.x] = 0

            // determine the spots adjacent all our enemies so we can identify them early
            // let foes = enemies(of: creature)
            let attackingSpots = foes.map { emptyAdjacentSpots(around: $0.position) }.joined()

            // we shouldn't be in an attacking spot...
            guard !attackingSpots.contains(creature.position) else { return nil }

            // start with the first layer directly surrounding the creature
            nextLayer.formUnion(emptyAdjacentSpots(around: creature.position))
            spotsConsidered.insert(creature.position)

            var moveCount = 1
            var foundHit = false

            while !nextLayer.isEmpty {
                var theNewNextLayer = Set<Coordinate>()

                spotsConsidered = spotsConsidered.union(nextLayer)

                for spot in nextLayer {
                    moveMap[spot.y][spot.x] = moveCount

                    if attackingSpots.contains(spot) {
                        destinations.append(spot)
                        foundHit = true
                    } else {
                        // look for the next layer of adjacent spots we haven't already considered
                        var adjacentSpots = emptyAdjacentSpots(around: spot)
                        adjacentSpots.subtract(spotsConsidered)
                        theNewNextLayer = theNewNextLayer.union(adjacentSpots)
                    }
                }

                // stop as soon as we've hit one or more attacking spots
                if foundHit {
                    break
                }

                nextLayer = theNewNextLayer
                moveCount += 1
            }

            // print(describing(moveMap: moveMap))

            return (map: moveMap, destinations: destinations.sortedForReadability())
        }

        func traceRoute(from source: Coordinate, to destination: Coordinate, map: [[Int]]) -> [Coordinate] {
            var route = [Coordinate]()
            route.append(destination)

            var movableSpots = adjacentSpots(around: destination)
            while !movableSpots.isEmpty {
                guard !movableSpots.contains(source) else { break }

                let sorted = Array(movableSpots).sortedForReadability().sorted(by: { map[$0.y][$0.x] < map[$1.y][$1.x] })
                guard let previousStep = sorted.first else { print("WHAT"); break }
                route.insert(previousStep, at: 0)

                movableSpots = adjacentSpots(around: previousStep)
            }

            // TODO: build print method to debug?

            return route
        }

        mutating func runSimulation() -> Int {
            var turnCount = 0
            print("Round \(turnCount):\n\(printable())")

            while !takeTurn() {
                turnCount += 1
                print("\nRound \(turnCount):\n\(printable())")
            }

            print("Ran \(turnCount) turns")
            print(printable())
            print("--------------------------")

            let hpSum = creatures.map { $0.hitPoints }.reduce(0, +)
            return turnCount * hpSum
        }

        /// Take a turn in the simulation.
        /// Runs creature movements and attacks for a single turn.
        ///
        /// - returns: Bool - is the simulation complete?
        @discardableResult mutating func takeTurn() -> Bool {
            for var creature in creatures.sortedForReadability() {
                guard !creature.dead else { continue }
                if !creatures.contains(where: { $0.position == creature.position }) {
                    continue
                }
//                if let c = creatures.first(where: { $0.position == creature.position }) {
//                    guard !c.dead else { continue }
//                }

                if enemies(of: creature).isEmpty {
                    print("No enemies left to attack...")
                    return true
                }

                // move first (unless we are in attack range - nil response)
                if let mappingResponse = nextDestinations(for: creature) {
                    if let destination = mappingResponse.destinations.first {
                        let route = traceRoute(from: creature.position, to: destination, map: mappingResponse.map)
//                        print("Moving \(creature) along \(route)")

                        if let idx = creatures.firstIndex(where: { $0 == creature }),
                            let newPosition = route.first {

                            creature.move(to: newPosition)
                            creatures[idx] = creature
                        } else {
//                            print("Unable to move \(creature)...")
                        }
                    } else {
//                        print("No destinations found for \(creature)...")
                    }
                }

                // attack if we are near an ememy
                if let attackable = attackableEnemies(of: creature),
                    var foe = attackable.first {

//                    print("\(creature) is attacking \(foe)")

                    if let idx = creatures.firstIndex(where: { $0 == foe }) {
                        foe.attacked(for: creature.attackPower)
                        if foe.dead {
                            print("\(foe) is dead!")
                            creatures.remove(at: idx)
                        } else {
                            creatures[idx] = foe
                        }
                    }
                }
            }

            return false // not done
        }

        func describing(moveMap: [[Int]]) -> String {
            var output = [String]()

            for (y, row) in map.enumerated() {
                var rowString = ""

                for (x, segment) in row.enumerated() {
                    let location = Coordinate(x: x, y: y)
                    if let creature = creatures.first(where: { $0.position == location }) {
                        rowString.append(creature.creatureType.rawValue)
                    } else if moveMap[y][x] < Int.max {
                        rowString.append("\(moveMap[y][x])")
                    } else {
                        rowString.append(segment.rawValue)
                    }
                }

                output.append(rowString)
            }

            return output.joined(separator: "\n")
        }

        func printable() -> String {
            var output = [String]()

            for (y, row) in map.enumerated() {
                var hitpoints = ""
                var rowString = ""

                for (x, segment) in row.enumerated() {
                    let location = Coordinate(x: x, y: y)
                    if let creature = creatures.first(where: { $0.position == location }) {
                        rowString.append(creature.creatureType.rawValue)
                        hitpoints.append("\(creature.creatureType.rawValue):\(creature.hitPoints) ")
                    } else {
                        rowString.append(segment.rawValue)
                    }
                }

                rowString.append("\t \(hitpoints)")
                output.append(rowString)
            }

            return output.joined(separator: "\n")
        }
    }

    @discardableResult func run(_ input: String? = nil, _ part: Int? = 1) -> Any {
        guard let input = input ?? defaultInput else {
            print("Day \(dayNumber): NO INPUT")
            exit(10)
        }

        let lines = input.split(separator: "\n").map(String.init).map { $0.trimmingCharacters(in: .newlines) }
        let map = DayFifteen.CaveMap(input: lines)

        if part == 1 {
            let answer = partOne(map: map)
            print("Day \(dayNumber) Part \(part!): Final Answer \(answer)")
            return answer
        } else {
            return 0
//            let answer = partTwo(tree: tree)
//            print("Day \(dayNumber) Part \(part!): Final Answer \(answer)")
//            return answer
        }
    }

     func partOne(map: CaveMap) -> Int {
        var theMap = map
        return theMap.runSimulation()
     }

    /*
     func partTwo(tree: LicenseTree) -> Int {
     guard let rootNode = tree.rootNode else { return Int.min }
     return sumNodeValue(for: rootNode)
     }
     */
}
