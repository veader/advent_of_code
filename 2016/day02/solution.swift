#!/usr/bin/env swift

import Foundation

// ------------------------------------------------------------------
// MARK: - "MAIN()"
guard let currentDir = ProcessInfo.processInfo.environment["PWD"] else {
    print("No current directory.")
    exit(1)
}

let inputPath: String = "\(currentDir)/input.txt"
let data = try String(contentsOfFile: inputPath, encoding: .utf8)

let lines = data.components(separatedBy: "\n")
