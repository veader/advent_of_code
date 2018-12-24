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
        return self.sorted(by: { $0.position.y < $1.position.y && $0.position.x < $1.position.x })
    }
}

extension Array where Element : CoordinateLike {
    func sortedForReadability() -> [Element] {
        return self.sorted(by: { $0.y < $1.y && $0.x < $1.x })
    }
}

protocol CreatureLike {
    var position: Coordinate { get set }
}

struct DayFifteen: AdventDay {
    var dayNumber: Int = 15

    struct Creature: CreatureLike, CustomDebugStringConvertible {
        enum CreatureType: Character {
            case goblin = "G"
            case elf = "E"
        }

        let creatureType: CreatureType
        var position: Coordinate
        var hitPoints: Int
        let attackPower: Int = 3

        var dead: Bool {
            return hitPoints <= 0
        }

        var debugDescription: String {
            return "Creature(\(creatureType) @ \(position.x)x\(position.y) HP:\(hitPoints))"
        }

        init(type: CreatureType, position: Coordinate) {
            self.creatureType = type
            self.position = position
            self.hitPoints = 200
        }

        mutating func move(to newLocation: Coordinate) {
            position = newLocation
        }

        mutating func attacked() {
            hitPoints -= attackPower
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

        func adjacentSpots(around c: Coordinate) -> [Coordinate] {
            let coordinates = [Coordinate(x: c.x, y: c.y - 1),
                               Coordinate(x: c.x, y: c.y + 1),
                               Coordinate(x: c.x - 1, y: c.y),
                               Coordinate(x: c.x + 1, y: c.y)]
            return coordinates.filter { isValid(location: $0) }
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

        func nextDestinations(for creature: Creature) -> [Coordinate]? {
            var spotsConsidered = Set<Coordinate>()
            var nextLayer = Set<Coordinate>()
            var destinations = [Coordinate]()

            // build move map. start with everything being max except starting point.
            var moveMap = Array(repeating: Array(repeating: Int.max, count: map.first!.count), count: map.count)
            moveMap[creature.position.y][creature.position.x] = 0

            // determine the spots adjacent all our enemies so we can identify them early
            let foes = enemies(of: creature)
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

                spotsConsidered.formUnion(nextLayer)

                for spot in nextLayer {
                    moveMap[spot.y][spot.x] = moveCount

                    if attackingSpots.contains(spot) {
                        destinations.append(spot)
                        foundHit = true
                    } else {
                        // look for the next layer of adjacent spots we haven't already considered
                        var adjacentSpots = emptyAdjacentSpots(around: spot)
                        adjacentSpots.subtract(spotsConsidered)
                        theNewNextLayer.formUnion(adjacentSpots)
                    }
                }

                print(describing(moveMap: moveMap))
                print("\n\n")

                // stop as soon as we've hit one or more attacking spots
                if foundHit {
                    break
                }

                nextLayer = theNewNextLayer
                moveCount += 1
            }

            return destinations.sortedForReadability()
        }

        func reachableSpots(from c: Coordinate) -> Set<Coordinate> {
            var spotsToConsider = Set<Coordinate>()
            var spotsConsidered = Set<Coordinate>()
            var reachable = Set<Coordinate>()

            // seed with the spots around this location
            for spot in emptyAdjacentSpots(around: c) {
                spotsToConsider.insert(spot)
            }

            while !spotsToConsider.isEmpty {
                // consider the first spot in our set
                let spot = spotsToConsider.removeFirst()
                spotsConsidered.insert(spot)

                // it's reachable if it's empty
                if isEmpty(spot) {
                    reachable.insert(spot)
                }

                // for all nearby spots (based on movement), see if we should consider them
                for nearbySpot in emptyAdjacentSpots(around: spot) {
                    if !spotsConsidered.contains(nearbySpot) {
                        spotsToConsider.insert(nearbySpot)
                    }
                }
            }

            return reachable
        }

        mutating func takeTurn() {
            print(printable())

            for creature in creatures.sortedForReadability() {
                //

                // find all spot adjacent, reachable to enemies
                let foes = enemies(of: creature)
                print("Foes: ----")
                print(foes)
                let attackingSpots = foes.map { emptyAdjacentSpots(around: $0.position) }.joined()
                print("Attacking: ----")
                print(attackingSpots)
                let reachable = reachableSpots(from: creature.position)
                print("Reachable: ----")
                print(reachable)
                let spotsToConsider = reachable.intersection(Set(attackingSpots))
                print("To Consider: ----")
                print(spotsToConsider)

                // find the one with the shortest open path
                let sortedSpotToConsider = spotsToConsider.sorted(by: {
                    creature.position.distance(to: $0) < creature.position.distance(to: $1)
                })

                print(sortedSpotToConsider)

                // grab the lowest one by distance
                // determine route there
                // grab first step
                // move creature

                // repeat...
            }
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
        return 0
        /*
         guard let input = input ?? defaultInput else {
         print("Day \(dayNumber): NO INPUT")
         exit(10)
         }

         if part == 1 {
         let answer = partOne(tree: tree)
         print("Day \(dayNumber) Part \(part!): Final Answer \(answer)")
         return answer
         } else {
         let answer = partTwo(tree: tree)
         print("Day \(dayNumber) Part \(part!): Final Answer \(answer)")
         return answer
         }
         */
    }

    /*
     func partOne(tree: LicenseTree) -> Int {
     guard let rootNode = tree.rootNode else { return Int.min }
     return metadataSum(for: rootNode)
     }

     func partTwo(tree: LicenseTree) -> Int {
     guard let rootNode = tree.rootNode else { return Int.min }
     return sumNodeValue(for: rootNode)
     }
     */
}
