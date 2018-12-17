//
//  DayThirteen.swift
//  AdventOfCode2018
//
//  Created by Shawn Veader on 12/13/18.
//  Copyright © 2018 Shawn Veader. All rights reserved.
//

import Foundation

struct DayThirteen: AdventDay {
    var dayNumber: Int = 13

    struct Cart {
        enum Orientation: String, CaseIterable {
            case north = "^"
            case south = "v"
            case east  = ">"
            case west  = "<"
        }

        enum DirectionChange {
            case left
            case straight
            case right
        }

        var identifier: Int
        var location: Coordinate
        var orientation: Orientation
        var nextDirectionChange: DirectionChange
        var currentSegment: String?

        init?(text: String, location: Coordinate) {
            guard let direction = Orientation(rawValue: text) else { return nil }

            self.identifier = 0
            self.location = location
            self.orientation = direction
            self.nextDirectionChange = .left // starting next change

            switch direction {
            case .north, .south:
                self.currentSegment = "|"
            case .east, .west:
                self.currentSegment = "-"
            }
        }

        /// Given the current location and oreintation, what is
        ///     the coordinate of the next location of the cart?
        var nextLocation: Coordinate {
            switch orientation {
            case .north:
                return Coordinate(x: location.x, y: location.y-1)
            case .south:
                return Coordinate(x: location.x, y: location.y+1)
            case .east:
                return Coordinate(x: location.x+1, y: location.y)
            case .west:
                return Coordinate(x: location.x-1, y: location.y)
            }
        }

        /// Move to the next location with the given segment.
        ///     the resulting coordinate, orientation, etc is
        ///     updated.
        mutating func move(with mapSegment: String) {
            switch mapSegment {
            case "|":
                guard [.north, .south].contains(orientation) else {
                //guard case .north = orientation || case .south = orientation else {
                    print("💥 N/S")
                    return
                }
                location = nextLocation
                currentSegment = mapSegment

            case "-":
                guard [.east, .west].contains(orientation) else {
                // guard case .east = orientation, case .west = orientation else {
                    print("💥 E/W")
                    return
                }
                location = nextLocation
                currentSegment = mapSegment

            case "/":
                location = nextLocation
                currentSegment = mapSegment

                switch orientation {
                case .north:
                    turn(direction: .right)
                case .south:
                    turn(direction: .right)
                case .east:
                    turn(direction: .left)
                case .west:
                    turn(direction: .left)
                }

            case "\\":
                location = nextLocation
                currentSegment = mapSegment

                switch orientation {
                case .north:
                    turn(direction: .left)
                case .south:
                    turn(direction: .left)
                case .east:
                    turn(direction: .right)
                case .west:
                    turn(direction: .right)
                }

            case "+":
                location = nextLocation
                currentSegment = mapSegment

                switch nextDirectionChange {
                case .left:
                    turn(direction: .left)
                    nextDirectionChange = .straight
                case .straight:
                    nextDirectionChange = .right
                case .right:
                    turn(direction: .right)
                    nextDirectionChange = .left
                }

            default:
                print("Unknown: \(mapSegment)")
            }
        }

        mutating internal func turn(direction: DirectionChange) {
            switch direction {
            case .left:
                switch orientation {
                case .north:
                    orientation = .west
                case .east:
                    orientation = .north
                case .south:
                    orientation = .east
                case .west:
                    orientation = .south
                }
            case .right:
                switch orientation {
                case .north:
                    orientation = .east
                case .east:
                    orientation = .south
                case .south:
                    orientation = .west
                case .west:
                    orientation = .north
                }
            case .straight:
                print("💥 Can't turn straight")
            }
        }
    }

    struct Map {
        var carts: [Cart]
        var map: [String]

        // initialize with input, find carts and pull them out
        init(lines: [String]) {
            var theCarts = [Cart]()
            var ourMap = [String]()

            let cartCharacters = Cart.Orientation.allCases.map { $0.rawValue }
            for (y, line) in lines.enumerated() {
                var updatedLine = ""
                for (x, segment) in line.enumerated() {
                    if cartCharacters.contains(String(segment)) {
                        let location = Coordinate(x: x, y: y)
                        if var cart = Cart(text: String(segment), location: location) {
                            cart.identifier = theCarts.count
                            theCarts.append(cart)
                            if let newSegment = cart.currentSegment {
                                updatedLine.append(newSegment)
                            } else {
                                updatedLine.append("*")
                            }
                        } else {
                            updatedLine.append(segment)
                        }
                    } else {
                        updatedLine.append(segment)
                    }
                }
                ourMap.append(updatedLine)
            }

            self.map = ourMap
            self.carts = theCarts
        }

        /// Move each cart in the proper order to determine where the first crash is...
        mutating func startYourEngines() -> Coordinate? {
            var collision: Coordinate? = nil

            while collision == nil {
//                print(printable(showCarts: true))
//                print("\n\n")

                let sortedCarts = carts.sorted(by: {
                    if $0.location.y == $1.location.y {
                        return $0.location.x < $1.location.x
                    } else {
                        return $0.location.y < $1.location.y
                    }
                })

                for var cart in sortedCarts {
                    // make sure we aren't about to hit something...
                    let currentLocations = carts.map { $0.location }
                    let nextLocation = cart.nextLocation
                    guard !currentLocations.contains(nextLocation) else {
                        collision = nextLocation
                        break
                    }

                    cart.move(with: segment(at: nextLocation))

                    // make sure this updated cart is
                    if let cartIndex = carts.firstIndex(where: { $0.identifier == cart.identifier }) {
                        carts[cartIndex] = cart
                    }
                }
            }

            return collision
        }

        func segment(at coordinate: Coordinate) -> String {
            let line = map[coordinate.y]
            let segment = line[line.index(line.startIndex, offsetBy: coordinate.x)]
            return String(segment)
        }

        func printable(showCarts: Bool = false) -> String {
            var output = [String]()
            for (y, line) in map.enumerated() {
                var updatedLine = line

                if showCarts {
                    for cart in carts.filter({ $0.location.y == y }) {
                        let segment = cart.orientation.rawValue
                        // remove map piece
                        let removeIndex = updatedLine.index(updatedLine.startIndex, offsetBy: cart.location.x)
                        updatedLine.remove(at: removeIndex)
                        // insert cart showing orientation
                        let insertIndex = updatedLine.index(updatedLine.startIndex, offsetBy: cart.location.x)
                        updatedLine.insert(segment[segment.startIndex], at: insertIndex)
                    }
                }

                output.append(updatedLine)
            }
            return output.joined(separator: "\n")
        }
    }

    @discardableResult func run(_ input: String? = nil, _ part: Int? = 1) -> Any {
        guard let input = input ?? defaultInput else {
            print("Day \(dayNumber): NO INPUT")
            exit(10)
        }

        let lines = input.split(separator: "\n")
                         .map(String.init)
                         .map { $0.trimmingCharacters(in: .newlines) }
        let map = Map(lines: lines)

        if part == 1 {
            let answer = partOne(map: map)!
            print("Day \(dayNumber) Part \(part!): Final Answer \(answer)")
            return answer
        } else {
            return 0
//            let answer = partTwo(tree: tree)
//            print("Day \(dayNumber) Part \(part!): Final Answer \(answer)")
//            return answer
        }
    }

    func partOne(map: Map) -> Coordinate? {
        var map = map
        return map.startYourEngines()
    }

//    func partTwo(tree: LicenseTree) -> Int {
//        guard let rootNode = tree.rootNode else { return Int.min }
//        return sumNodeValue(for: rootNode)
//    }
}
