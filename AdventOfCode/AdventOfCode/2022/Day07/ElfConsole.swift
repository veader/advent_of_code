//
//  ElfConsole.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/7/22.
//

import Foundation
import RegexBuilder

protocol FilesystemObject {
    var name: String { get }
}

class FilesystemDirectory: FilesystemObject {
    let name: String
    let parent: FilesystemDirectory?
    var children: [FilesystemObject] // collection of directories or files
    var size: Int

    init(name: String, parent: FilesystemDirectory?) {
        self.name = name
        self.parent = parent
        self.children = []
        self.size = 0
    }
}

class FilesystemFile: FilesystemObject {
    let name: String
    let size: Int

    init(name: String, size: Int) {
        self.name = name
        self.size = size
    }
}

class ElfConsole {
    enum OutputType: Equatable {
        case command(name: String, options: String?)
        case directory(name: String)
        case file(name: String, size: Int)
    }

    let output: String

    var filesystem = FilesystemDirectory(name: "/", parent: nil)

    init(output: String?) {
        self.output = output ?? ""
    }

    func run() {
        var currentDir: FilesystemDirectory = filesystem // start at the root

        for outputType in parse() {
            switch outputType {
            case .file(name: let name, size: let size):
                let file = FilesystemFile(name: name, size: size)
                currentDir.children.append(file)
            case .directory(name: let name):
                let dir = FilesystemDirectory(name: name, parent: currentDir)
                currentDir.children.append(dir)
            case .command(name: let name, options: let options):
                switch name {
                case "cd":
                    // change dir name
                    if options == ".." { // ".." is a special case and we need to migrate up a level
                        if let parentDir = currentDir.parent {
                            currentDir = parentDir
                        } else {
                            print("\tNothing up from \(currentDir.name)")
                            currentDir = filesystem // default to root? (or don't switch?
                        }
                    } else {
                        if options == "/" {
                            currentDir = filesystem // go to root
                        } else if let options {
                            let childDir = currentDir.children.first(where: { $0 is FilesystemDirectory && $0.name == options })
                            if let child = childDir as? FilesystemDirectory {
                                currentDir = child
                            } else {
                                print("\t**NO CHILD BY NAME \(options)")
                            }
                        }
                    }
                case "ls":
                    continue // list of things to follow...
                default:
                    print("Unknown command: \(name)")
                    continue // NO-OP
                }
            }
        }

        // calculate size
        calculateDirectorySizes()
    }

    func parse() -> [OutputType] {
        output.split(separator: "\n").map(String.init).compactMap { line -> OutputType? in
            if let match = line.firstMatch(of: commandRegex) {
                var options: String?
                if let opt = match.2 {
                    options = String(opt)
                }

                return .command(name: String(match.1), options: options)
            } else if let match = line.firstMatch(of: directoryRegex) {
                return .directory(name: String(match.1))
            } else if let match = line.firstMatch(of: fileRegex) {
                return .file(name: String(match.2), size: Int(match.1) ?? 0)
            }

            return nil
        }
    }

    func findDirectories(where whereClause: (FilesystemDirectory) -> (Bool)) -> [FilesystemDirectory] {
        return findDirectories(from: filesystem, where: whereClause)
    }

    private func findDirectories(from dir: FilesystemDirectory, where whereClause: (FilesystemDirectory) -> (Bool)) -> [FilesystemDirectory] {
        var collectedDirs = [FilesystemDirectory]()
        for child in dir.children {
            guard let childDir = child as? FilesystemDirectory else { continue }
            collectedDirs.append(contentsOf: findDirectories(from: childDir, where: whereClause))
        }

        if whereClause(dir) {
            collectedDirs.append(dir)
        }

        return collectedDirs
    }


    // MARK: - Size Calculations

    private func calculateDirectorySizes() {
        filesystem.size = calculateSizeOf(directory: filesystem)
    }

    private func calculateSizeOf(directory: FilesystemDirectory) -> Int {
        var total = 0
        for child in directory.children {
            if let childDir = child as? FilesystemDirectory {
                total += calculateSizeOf(directory: childDir)
            } else if let childFile = child as? FilesystemFile {
                total += childFile.size
            }
        }

        // set total into map
        directory.size = total

        return total // to bubble up to parent dir
    }


    // MARK: - Print

    func printFilesystem() {
        print(printDirectory(filesystem))
    }

    private func printDirectory(_ dir: FilesystemDirectory, indent: Int = 0) -> String {
        let mainIndentLevel = Array(repeating: "\t", count: indent).joined()
        let childIndentLevel = Array(repeating: "\t", count: indent + 1).joined()

        var output = "\(mainIndentLevel)- \(dir.name) (dir, size=\(dir.size))\n"
        for child in dir.children {
            if let childDir = child as? FilesystemDirectory {
                output += printDirectory(childDir, indent: indent + 1)
            } else if let childFile = child as? FilesystemFile {
                output += "\(childIndentLevel)- \(childFile.name) (file, size=\(childFile.size))\n"
            } else {
                print("Not sure what this is: \(child)")
            }
        }

        return output
    }


    // MARK: - Regex

    let commandRegex = Regex {
        "$"
        One(.whitespace)
        Capture {
            ChoiceOf {
                "cd"
                "ls"
            }
        }
        Optionally {
            One(.whitespace)
            Capture {
                OneOrMore(/./)
            }
        }
    }//.anchorsMatchLineEndings()

    let directoryRegex = Regex {
        "dir"
        One(.whitespace)
        Capture {
            OneOrMore(/./)
        }
    }

    let fileRegex = Regex {
        Capture {
            OneOrMore(.digit)
        }
        One(.whitespace)
        Capture {
            OneOrMore(/./)
        }
    }
}
