//
//  SimpleDisk.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/9/24.
//

import Foundation

class SimpleDisk {
    let diskMap: [Int]
    var disk: [StorageItem] = []
    var basicDisk: [String] = []

    enum StorageItem {
        case file(id: Int, size: Int)
        case space(size: Int)

        var string: String {
            switch self {
            case .space(size: let size):
                String(repeating: ".", count: size)
            case .file(id: let id, size: let size):
                String(repeating: "\(id)", count: size)
            }
        }
    }

    init(diskMap: [Int]) {
        self.diskMap = diskMap

        calculateDisk()
        oldCalculateDisk()
    }

    /// Turn the disk map into our disk representation
    private func calculateDisk() {
        var fileID = 0 // file IDs start with 0
        var isFile: Bool = true // first thing is a file
        var newDisk = [StorageItem]()

        for num in diskMap {
            if isFile {
                newDisk.append(.file(id: fileID, size: num))
                // newDisk.append(contentsOf: Array(repeating: "\(fileID)", count: num))
                fileID += 1
            } else { // space
                newDisk.append(.space(size: num))
                // newDisk.append(contentsOf: Array(repeating: ".", count: num))
            }

            isFile = !isFile
        }

        disk = newDisk
    }

    private func oldCalculateDisk() {
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

        basicDisk = newDisk
    }

    func defrag() {
        guard let left = basicDisk.firstIndex(where: { $0 == "." }),
              let right = basicDisk.lastIndex(where: { $0 != "." })
        else { return }

        var leftPointer: Int = left
        var rightPointer: Int = right

        while leftPointer < rightPointer {
            // print(printDisk())

            let file = basicDisk[rightPointer]
            basicDisk[leftPointer] = file
            basicDisk[rightPointer] = "."

            // move up to the next empty space
            while leftPointer < basicDisk.count {
                guard basicDisk[leftPointer] != "." else { break }
                leftPointer += 1
            }

            // move down to the next full space
            while rightPointer > 0 {
                guard basicDisk[rightPointer] == "." else { break }
                rightPointer -= 1
            }
        }
    }

    func wholeFileDefrag() {
        let fileIdx = disk.lastIndex(where: {
            guard case .file(_, _) = $0 else { return false }
            return true
        })

        var fileSize = 0
        var fileID = 0

        guard var fileIdx, case .file(let id, let size) = disk[fileIdx] else { return }
        fileID = id
        fileSize = size

        while fileID != 0 {

            // look for the left-most space that this file will fit in...
            let spaceIdx = disk.firstIndex(where: {
                guard case .space(let size) = $0, size >= fileSize else { return false }
                return true
            })

            // if we can find a space big enough to the left of the current file position, move the file...
            if let spaceIdx, spaceIdx < fileIdx, case .space(let spaceSize) = disk[spaceIdx] {
                // swap file into space, creating smaller space if needed
                let remainder = spaceSize - fileSize
                disk[spaceIdx] = .file(id: fileID, size: fileSize)
                disk[fileIdx] = .space(size: fileSize) // what happens if there are space records to the left/right of this idx?

                if remainder > 0 {
                    disk.insert(.space(size: remainder), at: spaceIdx + 1)
                }
            }

            // find the next file to attemp to move...
            let nextFileIdx = disk.lastIndex(where: {
                guard case .file(let i, _) = $0, i < fileID else { return false }
                return true
            })

            guard let nextFileIdx, case .file(let id, let size) = disk[nextFileIdx] else {
                print("Unable to find next file...")
                break
            }

            fileIdx = nextFileIdx
            fileID = id
            fileSize = size
        }
    }

    /// Calculate the checksum of the disk. Assumes previously defragmented disk.
    func calculateChecksum(basic: Bool = true) -> Int {
        if basic {
            return basicDisk.enumerated().reduce(0) { result, oe in
                let (offset, element) = oe
                guard element != "." else { return result }
                return result + offset * (Int(element) ?? 0)
            }
        } else {
            var idx = 0
            var checksum = 0

            for item in disk {
                switch item {
                case .file(let fileID, let fileSize):
                    for _ in 0..<fileSize {
                        checksum += (idx * fileID)
                        idx += 1
                    }
                case .space(let spaceSize):
                    idx += spaceSize
                }
            }

            return checksum
        }

    }

    func printDisk(basic: Bool = true) -> String {
        if basic {
            return basicDisk.joined()
        } else {
            return disk.reduce("") { result, item in
                result + item.string
            }
        }
    }
}
