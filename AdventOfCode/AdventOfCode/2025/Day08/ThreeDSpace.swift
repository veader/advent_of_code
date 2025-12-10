//
//  ThreeDSpace.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/8/25.
//

import Foundation

class ThreeDSpace {
    /// A 3D vector which has a start and end and a calculated distance.
    struct ThreeDVector: Equatable, Comparable {
        let start: ThreeDCoordinate
        let end: ThreeDCoordinate
        let distance: Float

        init(start: ThreeDCoordinate, end: ThreeDCoordinate) {
            self.start = start
            self.end = end
            self.distance = start.distance(to: end)
        }

        static func == (lhs: ThreeDVector, rhs: ThreeDVector) -> Bool {
            (lhs.start == rhs.start && lhs.end == rhs.end) ||
            (lhs.start == rhs.end && lhs.end == rhs.start)
        }

        static func < (lhs: ThreeDVector, rhs:ThreeDVector) -> Bool {
            lhs.distance < rhs.distance
        }
    }

    /// A circuit is a collection of connected 3D points
    class Circuit: Equatable {
        var root: ThreeDCoordinate?
        var points: Set<ThreeDCoordinate>

        init(points: [ThreeDCoordinate]) {
            self.points = Set<ThreeDCoordinate>(points)
            self.root = points.first
        }

        init(points: Set<ThreeDCoordinate>) {
            self.points = points
            self.root = points.first
        }

        func insert(_ point: ThreeDCoordinate) {
            points.insert(point)
        }

        func insert(points newPoints: Set<ThreeDCoordinate>) {
            points.formUnion(newPoints)
        }

        func contains(point: ThreeDCoordinate) -> Bool {
            points.contains(point)
        }

        func contains(_ vector: ThreeDVector) -> Bool {
            points.contains(vector.start) && points.contains(vector.end)
        }

        func partiallyContains(_ vector: ThreeDVector) -> Bool {
            points.contains(vector.start) || points.contains(vector.end)
        }

        /// Circuits are equal if they have the same points (ignoring the root, for now)
        static func == (lhs: Circuit, rhs: Circuit) -> Bool {
            lhs.points == rhs.points
        }
    }


    /// All of the coordinates that we are tracking within this 3D space
    let coordinates: [ThreeDCoordinate]

    /// A "map" of distances between each point
    var distanceMap: [ThreeDVector] = []


    init(coordinates: [ThreeDCoordinate]) {
        self.coordinates = coordinates
        buildDistanceMap()
    }


    /// Build a distance map between each point in the 3D space.
    private func buildDistanceMap() {
        for (idx, c) in coordinates.enumerated() {
            // map from this current point to each point after it in the list
            if idx+1 < coordinates.count {
                for c2 in coordinates[idx+1..<coordinates.count] {
                    distanceMap.append(ThreeDVector(start: c, end: c2))
                }
            }
        }
    }

    /// Attempt at Kurskal's Algo...
    func buildMST(_ limit: Int = Int.max) -> [ThreeDVector] {
        let sortedVectors = distanceMap.sorted()
        let set = DisjointedSet(vertices: coordinates)

        var mst = [ThreeDVector]()
        var count = 0

        for vector in sortedVectors {
            if set.union(vector.start, vector.end) {
                mst.append(vector) // we added this
                count += 1

                // check for termination condition - (MST only had N-1 edges)
                guard mst.count < (coordinates.count - 1) else { break }
            }
        }

        return mst
    }

    // first take
    func buildConnections(_ limit: Int = Int.max) {
        var circuits = [Circuit]()

        var loopCount = 0
        var connectionsMade = 0
        let sortedVectors = distanceMap.sorted()

        // look for the next shortest distance
        for vector in sortedVectors {
            defer { loopCount += 1 }
            guard connectionsMade < limit else { break }

            // first see if the vector (both sides) are already part of a circuit
            if let _ = circuits.first(where: { $0.contains(vector) }) {
                // connection already exists in a circuit, do nothing...
                continue
            }

            // for the coordinate pair of the vector, see if either side already exists within a circuit
            let startCircuit = circuits.first(where: { $0.contains(point: vector.start) })
            let endCircuit = circuits.first(where: { $0.contains(point: vector.end) })

            if let startCircuit, endCircuit == nil {
                // start in an existing circuit, add end to it
                startCircuit.insert(vector.end)
            } else if let endCircuit, startCircuit == nil {
                // end in an existing circuit, add start to it
                endCircuit.insert(vector.start)
            } else if let startCircuit, let endCircuit {
                // both sides (start and end) belong to different circuits, join these circuits
                startCircuit.insert(points: endCircuit.points)
            } else {
                // neither side exists in a circuit, create one
            }

            let indices = circuits.indices.filter { circuits[$0].partiallyContains(vector) }
            if indices.count > 0 {
                var idx: Int? = indices.first // default to the first
                if indices.count > 1 {
                    // if we have more, grab the biggest one
                    idx = indices.sorted(by: { circuits[$0].points.count > circuits[$1].points.count}).first
                }

                // make sure we have an index to proceed
                guard let idx else {
                    assert(true, "Unable to get index from found indices...")
                    break // why compiler is this required?
                }

                var updatedPoints = circuits[idx].points

                // if so, add the "other" side to the circuit
                if updatedPoints.contains(vector.start) && updatedPoints.contains(vector.end) {
                    // connection already exists in a circuit, do nothing...
                    assert(true, "Complete match found after check for complete match.")
                    // TODO: we should NOT get here now...
                }

                updatedPoints.insert(vector.start)
                updatedPoints.insert(vector.end)

                // replace curcuit
                circuits[idx] = Circuits(points: updatedPoints)
                connectionsMade += 1
            } else {
                // if not, create a new circuit
                circuits.append(Circuits(points: [vector.start, vector.end]))
                connectionsMade += 1
            }
        }
    }

    /// Calculate the "score" based on the size of the top three circuits
    func topThreeScore() -> Int? {
        print("We have \(circuits.count) circuits")
        // sort circuits based on size
        let sorted = circuits.sorted(by: { $0.points.count > $1.points.count })
        guard sorted.count >= 3 else { return nil }

        let topThree = sorted[0...2]
        print("Top three circuits: ")
        for c in topThree {
            print("\tCurcuit: count = \(c.points.count)")
        }

        return topThree.reduce(1) { result, circuit in
            result * circuit.points.count
        }
    }
}
