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

struct FilesystemDirectory: FilesystemObject {
    let parent: String?
    let name: String
    let children: [FilesystemObject] // collection of directories or files

    func replacing(children newChildren: [FilesystemObject]) -> FilesystemDirectory {
        FilesystemDirectory(parent: parent, name: name, children: newChildren)
    }
}

struct FilesystemFile: FilesystemObject {
    let parent: String?
    let name: String
    let size: Int
}

class ElfConsole {
    enum OutputType: Equatable {
        case command(name: String, options: String?)
        case directory(name: String)
        case file(name: String, size: Int)
    }

    let output: String

    /// Mapping of directories within our filesystem
    var fileSystemMap = [String: FilesystemDirectory]()

    /// Map from the directory name to size of all items in its heirarchy
    var directorySizeMap = [String: Int]()

    init(output: String?) {
        self.output = output ?? ""
    }

    func run() {
        var currentDirName: String?
        var currentDirItems = [FilesystemObject]()
        var listingDirContents = false

        for outputType in parse() {
            switch outputType {
            case .file(name: let name, size: let size):
                guard listingDirContents else { print("Got a file when not listing..."); continue }
                let file = FilesystemFile(parent: currentDirName, name: name, size: size)
                currentDirItems.append(file)
            case .directory(name: let name):
                guard listingDirContents else { print("Got a directory when not listing..."); continue }
                let dir = FilesystemDirectory(parent: currentDirName, name: name, children: [])
                currentDirItems.append(dir)
            case .command(name: let name, options: let options):
                switch name {
                case "cd":
                    print("Change dir to '\(options ?? "")'")
                    print("\tCurrent things: \(currentDirName ?? "") | [\(currentDirItems.count)]")

                    // wrap up any current dir, if we have one
                    if let dirName = currentDirName {
                        updateMap(directory: dirName, children: currentDirItems)
                    }

                    // turn off listing
                    listingDirContents = false
                    currentDirItems = [FilesystemObject]() // clear the list

                    // change dir name
                    if options == ".." { // ".." is a special case and we need to migrate up a level
                        if let dirName = currentDirName, let dir = fileSystemMap[dirName] {
                            print("\tOne up: \(dir.parent)")
                            currentDirName = dir.parent
                        } else {
                            print("NO DIR UP: \(currentDirName ?? ""): <- cd ..")
                            currentDirName = "/"
                        }
                        //else { print("NO DIR UP: '\(currentDirName ?? "")' | TRYING TO GO TO '..'"); continue }
                    } else {
                        if options == "/" {
                            currentDirName = "/"
                        } else {
                            // make sure the directory is a child
                            guard let dirName = currentDirName, let dir = fileSystemMap[dirName] else { print("?"); continue }

                            if dir.children.contains(where: { $0.name == options }) {
                                currentDirName = options
                            } else {
                                print("CD to invalid dir: \(options ?? "|")")
                            }
                        }
                    }
                case "ls":
                    print("List -> \(currentDirName ?? "**")")
                    currentDirItems = [FilesystemObject]() // clear the list
                    listingDirContents = true
                default:
                    print("Unknown command: \(name)")
                    continue // NO-OP
                }
            }
        }

        // handle any dangling dir info
        if let dirName = currentDirName {
            updateMap(directory: dirName, children: currentDirItems)
        }
    }

    private func updateMap(directory: String, children: [FilesystemObject]) {
        print("\t\tSaving \(directory) with [\(children.count)]")
        if let dir = fileSystemMap[directory] {
            // update an existing directory entry
            let updatedDir = dir.replacing(children: children) // TODO: Is this true?
            fileSystemMap[directory] = updatedDir
        } else {
            // setup this directory
            let dir = FilesystemDirectory(parent: nil, name: directory, children: children)
            fileSystemMap[directory] = dir
        }
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


    // MARK: - Size Calculations

    func calculateSizeMap() {
        let totalSize = calculateDirectorySize("/")
        directorySizeMap["/"] = totalSize
    }

    private func calculateDirectorySize(_ dirName: String) -> Int {
        guard let dir = fileSystemMap[dirName] else { print("Unable to locate '\(dirName)'"); return 0 }

        var total = 0
        for child in dir.children {
            if let childDir = child as? FilesystemDirectory {
                total += calculateDirectorySize(childDir.name)
            } else if let childFile = child as? FilesystemFile {
                total += childFile.size
            }
        }

        // set total into map
        directorySizeMap[dirName] = total

        return total // to bubble up to parent dir
    }


    // MARK: - Print

    func printFilesystem() {
        print(printDirectory("/"))
    }

    private func printDirectory(_ dirName: String, indent: Int = 0) -> String {
        guard let dir = fileSystemMap[dirName] else { print("Unable to locate '\(dirName)'"); return "**\(dirName)**\n" }

        let mainIndentLevel = Array(repeating: "\t", count: indent).joined()
        let childIndentLevel = Array(repeating: "\t", count: indent + 1).joined()

        var output = "\(mainIndentLevel)- \(dir.name) (dir)\n"
        for child in dir.children {
            if let childDir = child as? FilesystemDirectory {
                output += printDirectory(childDir.name, indent: indent + 1)
            } else if let childFile = child as? FilesystemFile {
                output += "\(childIndentLevel)- \(childFile.name) (file, size=\(childFile.size)\n"
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
