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

        struct TowerBalance {
            let tower: Tower?
            let unbalanced: Tower?
            let offset: Int
            let totalWeight: Int
        }

        init?(_ text: String) {
            towers = text.split(separator: "\n").flatMap { Tower(String($0)) }
            guard towers.count > 0 else { return nil }

            let towerTuples = towers.map { tower -> (String, Tower) in
                return (tower.name, tower)
            }

            map = Dictionary(uniqueKeysWithValues: towerTuples)
        }

        func findRoot() -> Tower? {
            var tower = map.first?.value // start anywhere in the tree
            while let parentTower = parent(of: tower) {
                tower = parentTower
            }

            return tower
        }

        func balance() -> Int? {
            guard let root = findRoot() else { return nil }

            let result = balance(root)
            return result?.offset
        }

        /// Return a tuple with the unbalanced tower and it's offset to being balanced
        private func balance(_ tower: Tower) -> TowerBalance? {
            if tower.subTowers.count == 0 {
                // leaf node
                // print("LEAF: \(tower.name)")
                return TowerBalance(tower: tower, unbalanced: nil, offset: 0, totalWeight: tower.weight)
            }

            let subBalances = tower.subTowers.flatMap { towerName -> TowerBalance? in
                guard let subTower = map[towerName] else { return nil }
                return balance(subTower)
            }

            // if any of the subtowers was unbalanced, bubble it up
            if let unbalanced = subBalances.first(where: { $0.offset != 0 }) {
                // print("CHILD: of \(tower.name) -> \(unbalanced.tower?.name ?? "?") unbalanced")
                return unbalanced
            } else {
                // are we balanced?
                let weights = subBalances.map { $0.totalWeight }
                let weightSet = Set(weights)
                if weightSet.count > 1 {
                    // we are NOT balanced
                    // print("UNBALANCED: \(tower.name) [\(weights)]")
                    let lowWeight = weightSet.min() ?? 0
                    let highWeight = weightSet.max() ?? 0
                    let offset = highWeight - lowWeight

                    let lowTowers = subBalances.filter { $0.totalWeight == lowWeight }
                    if lowTowers.count == 1 {
                        // unbalanced is the low one, should weigh as much as the high one(s)
                        let lowTower = lowTowers[0].tower
                        // print("\t Low is unbalanced -> \(highWeight) \(lowWeight) \(offset)")
                        return TowerBalance(tower: tower, unbalanced: lowTower, offset: (lowTower?.weight ?? 0) + offset, totalWeight: 0)
                    } else {
                        // unbalanced is the high one, should weigh as much as the low one(s)
                        let highTower = subBalances.first(where: { $0.totalWeight == highWeight })?.tower
                        // print("\t High is unbalanced -> \(highWeight) \(lowWeight) \(offset)")
                        return TowerBalance(tower: tower, unbalanced: highTower, offset: (highTower?.weight ?? 0) - offset, totalWeight: 0)
                    }
                } else {
                    // we are balanced
                    // print("BALANCED: \(tower.name) -> [(\(tower.subTowers))]")
                    let totalWeight = tower.weight + weights.reduce(0, +)
                    return TowerBalance(tower: tower, unbalanced: nil, offset: 0, totalWeight: totalWeight)
                }
            }
        }

        /// Return the parent of a given tower
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

        let thing2 = partTwo(input: runInput)
        guard let answer2 = thing2 else {
            print("Day 7: (Part 2) 💥 Unable to calculate answer.")
            exit(1)
        }
        print("Day 7: (Part 2) Answer ", answer2)
    }

    // MARK: -

    func partOne(input: String) -> String? {
        let towerMap = TowerMap(input)
        let root = towerMap?.findRoot()
        return root?.name
    }

    func partTwo(input: String) -> Int? {
        let towerMap = TowerMap(input)
        let weight = towerMap?.balance()
        return weight
    }
}
