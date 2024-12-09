//
//  SimpleDisk.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/9/24.
//

import Foundation

class SimpleDisk {
    let diskMap: [Int]
    var disk: [String] = []

    init(diskMap: [Int]) {
        self.diskMap = diskMap

        calculateDisk()
    }

    /// Turn the disk map into our disk representation
    private func calculateDisk() {
        var fileID = 0 // file IDs start with 0
        var isFile: Bool = true // first thing is a file
        var newDisk = [String]()

        for num in diskMap {
            if isFile {
                newDisk.append(contentsOf: Array(repeating: "\(fileID)", count: num))
                fileID += 1
            } else { // space
                newDisk.append(contentsOf: Array(repeating: ".", count: num))
            }

            isFile = !isFile
        }

        disk = newDisk
    }

    func defrag() {
        guard let left = disk.firstIndex(where: { $0 == "." }),
              let right = disk.lastIndex(where: { $0 != "." })
        else { return }

        var leftPointer: Int = left
        var rightPointer: Int = right

        while leftPointer < rightPointer {
            // print(printDisk())

            let file = disk[rightPointer]
            disk[leftPointer] = file
            disk[rightPointer] = "."

            // move up to the next empty space
            while leftPointer < disk.count {
                guard disk[leftPointer] != "." else { break }
                leftPointer += 1
            }

            // move down to the next full space
            while rightPointer > 0 {
                guard disk[rightPointer] == "." else { break }
                rightPointer -= 1
            }
        }
    }

    /// Calculate the checksum of the disk. Assumes previously defragmented disk.
    func calculateChecksum() -> Int {
        disk.enumerated().reduce(0) { result, oe in
            let (offset, element) = oe
            guard element != "." else { return result }
            return result + offset * (Int(element) ?? 0)
        }
    }

    func printDisk() -> String {
        disk.joined()
    }
}
