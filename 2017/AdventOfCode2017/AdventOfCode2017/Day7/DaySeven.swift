//
//  DaySeven.swift
//  AdventOfCode2017
//
//  Created by Shawn Veader on 12/7/17.
//  Copyright © 2017 v8logic. All rights reserved.
//

import Foundation

struct DaySeven: AdventDay {

    struct TowerMap {
        let towers: [Tower]
        let map: [String: Tower]
        var rootTower: Tower?

        init?(_ text: String) {
            towers = text.split(separator: "\n").flatMap { Tower(String($0)) }
            guard towers.count > 0 else { return nil }

            let towerTuples = towers.map { tower -> (String, Tower) in
                return (tower.name, tower)
            }

            map = Dictionary(uniqueKeysWithValues: towerTuples)
        }

        mutating func findRoot() -> Tower? {
            var tower = map.first?.value // start anywhere in the tree
            while let parentTower = parent(of: tower) {
                tower = parentTower
            }

            rootTower = tower
            return tower
        }

        private func parent(of tower: Tower?) -> Tower? {
            guard let tower = tower else { return nil }

            let towersWithSubs = towers.filter { $0.subTowers.count > 0 }
            for possibleParent in towersWithSubs {
                if possibleParent.subTowers.contains(tower.name) {
                    return possibleParent
                }
            }

            return nil
        }
    }

    struct Tower {
        let name: String
        let weight: Int
        let subTowers: [String]

        init?(_ text: String) {
            // possible formats:
            //      pbga (66)
            //      fwft (72) -> ktlj, cntj, xhth
            let pieces = text.split(separator: " ").map(String.init)
            guard pieces.count > 1 else { return nil }

            name = pieces[0]
            guard
                let theWeight = Int(pieces[1].replacingOccurrences(of: "(", with: "")
                                             .replacingOccurrences(of: ")", with: ""))
                else {
                    return nil
                }
            weight = theWeight

            if let arrowIndex = text.range(of: "->") {
                let subTowersText = text.suffix(from: arrowIndex.upperBound)
                subTowers = subTowersText.split(separator: ",")
                                         .map(String.init)
                                         .map { $0.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) }
            } else {
                subTowers = [String]() // no subtowers
            }
        }
    }

    // MARK: -

    func defaultInput() -> String? {
        let path = "\(dataPath())/day7input.txt"
        return try? String(contentsOfFile: path, encoding: .utf8)
    }

    func run(_ input: String? = nil) {
        guard let runInput = input ?? defaultInput() else {
            print("Day 7: 💥 NO INPUT")
            exit(10)
        }

        let thing = partOne(input: runInput)
        guard let answer = thing else {
            print("Day 7: (Part 1) 💥 Unable to calculate answer.")
            exit(1)
        }
        print("Day 7: (Part 1) Answer ", answer)

        // ...
    }

    // MARK: -

    func partOne(input: String) -> String? {
        var towerMap = TowerMap(input)
        let root = towerMap?.findRoot()
        return root?.name
    }

    func partTwo(input: String) -> Int? {
        return nil
    }
}
