//
//  ThreeDSpace.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/8/25.
//

import Foundation

class ThreeDSpace {
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

    // Attempt to build connections between the vectors.
    func buildConnections(_ limit: Int = Int.max) -> ([Circuit], ThreeDVector?) {
        var circuits = [Circuit]()

        var loopCount = 0
        let sortedVectors = distanceMap.sorted()
        var finalVector: ThreeDVector?

        // look for the next shortest distance
        for vector in sortedVectors {
            defer { loopCount += 1 }
            guard loopCount < limit else { break }

            // TODO: When there is a single circuit with N-1 edges?

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

                // remove the end circuit now that it's part of the start circuit
                if let endIndex = circuits.firstIndex(of: endCircuit) {
                    circuits.remove(at: endIndex)
                } else {
                    print("Unable to remove end circuit... uh oh!")
                }
            } else {
                // neither side exists in a circuit, create one
                let newCircuit = Circuit(points: [vector.start, vector.end])
                circuits.append(newCircuit)
            }

            if circuits.count == 1, let circuit = circuits.first, circuit.points.count == coordinates.count {
                // we've reached the end
                finalVector = vector
                break
            }
        }

        return (circuits, finalVector)
    }

    /// Calculate the "score" based on the size of the top three circuits
    func topThreeScore(circuits: [Circuit]) -> Int? {
        let sorted = circuits.sorted(by: { $0.points.count > $1.points.count })
        let score = sorted.prefix(3).reduce(1) { $0 * $1.points.count }
        return score
    }
}
