//
//  DisjointedSet.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/9/25.
//

import Foundation

/// Model for a Disjointed Set (Union-Find Data Structure)
class DisjointedSet<Vertex: Hashable> {
    /// Map of vertices pointing to the start of their graph/set
    private var parent: [Vertex: Vertex] = [:]

    /// Map of vertices to their ranking/weight (ie: number of connected points?)
    private var rank: [Vertex: Int] = [:]

    init(vertices: [Vertex]) {
        for vertex in vertices {
            parent[vertex] = vertex // each vertex starts only pointing to itself
            rank[vertex] = 0 // everyone starts with 0 ranking
        }
    }

    /// Find the "root" parent for the given vertex.
    ///
    /// Traverses the parent structure and updates the parent as it goes.
    func find(_ vertex: Vertex) -> Vertex? {
        guard let parentVertex = parent[vertex] else { return vertex }

        if parentVertex != vertex {
            // traverse till we the root
            parent[vertex] = find(parentVertex)
        }

        return parent[vertex]
    }

    /// Create a union between the two vertices.
    ///
    /// - Returns: Boolean indicating if a union was created.
    func union(_ vertex1: Vertex, _ vertex2: Vertex) -> Bool {
        // find the root of any existing graph that contains the two vertices
        guard
            let root1 = find(vertex1),
            let root2 = find(vertex2)
        else { return false }

        // are the vertices already joined in the same graph?
        guard root1 != root2 else { return false }

        let rank1 = rank[vertex1] ?? 0
        let rank2 = rank[vertex2] ?? 0

        if rank1 < rank2 {
            // vertex2 belongs to a larger graph, join to it
            parent[root1] = root2
        } else if rank1 > rank2 {
            // vertex1 belongs to a larger graph, join to it
            parent[root2] = root1
        } else {
            // same size graphs (or not in one?), go with the first one
            parent[root2] = root1
            rank[root1] = rank1 + 1
        }

        return true
    }
}
