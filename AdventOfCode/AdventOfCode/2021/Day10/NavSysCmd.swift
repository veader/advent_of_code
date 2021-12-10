//
//  NavSysCmd.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/10/21.
//

import Foundation

struct NavSysCmd {
    enum ChunkDelimiter {
        enum DelimitedDirection {
            case open
            case close
        }

        case parens(direction: DelimitedDirection)
        case squareBrackets(direction: DelimitedDirection)
        case curlyBraces(direction: DelimitedDirection)
        case angles(direction: DelimitedDirection)
        case invalid

        var isOpen: Bool {
            if case .parens(let direction) = self, case .open = direction {
                return true
            } else if case .squareBrackets(let direction) = self, case .open = direction {
                return true
            } else if case .curlyBraces(let direction) = self, case .open = direction {
                return true
            } else if case .angles(let direction) = self, case .open = direction {
                return true
            }
            return false
        }

        var isClose: Bool {
            !isOpen
        }

        func sameType(as del: ChunkDelimiter) -> Bool {
            switch (self, del) {
            case (.parens, .parens):
                return true
            case (.squareBrackets, .squareBrackets):
                return true
            case (.curlyBraces, .curlyBraces):
                return true
            case (.angles, .angles):
                return true
            default:
                return false
            }
        }

        static func parse(_ input: String) -> ChunkDelimiter {
            switch input {
            case "(":
                return .parens(direction: .open)
            case ")":
                return .parens(direction: .close)
            case "[":
                return .squareBrackets(direction: .open)
            case "]":
                return .squareBrackets(direction: .close)
            case "{":
                return .curlyBraces(direction: .open)
            case "}":
                return .curlyBraces(direction: .close)
            case "<":
                return .angles(direction: .open)
            case ">":
                return .angles(direction: .close)
            default:
                return .invalid
            }
        }
    }

    let command: String

    /// Is the command corrupted? And if so, what was the failing character
    func isCorrupted() -> (Bool, String?) {
        var openChunks = [ChunkDelimiter]()

        for (i,s) in command.map(String.init).enumerated() {
            let delimiter = ChunkDelimiter.parse(s)
            if delimiter.isOpen {
                // if we are opening a new chunk, just add it to our open pile
                openChunks.append(delimiter)
            } else {
                // if it's closing, see if it matches the last open delimiter
                guard let last = openChunks.last else {
                    print("\(s) @ \(i) : No open chunks! ")
                    return (true, s)
                }

                if delimiter.sameType(as: last) {
                    _ = openChunks.removeLast()
                } else {
                    print("\(s) @ \(i) : Does not match open chunk! ")
                    return (true, s)
                }
            }
        }

        return (false, nil)
    }
}
