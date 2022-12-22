//
//  ValveMap.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/20/22.
//

import Foundation
import RegexBuilder

class ValveMap {

    struct Valve {
        let name: String
        let flowRate: Int
        let connected: [String]
    }

    static func parse(_ input: String) -> [Valve] {
        input.split(separator: "\n").map(String.init).compactMap { line -> Valve? in
            guard
                let match = line.firstMatch(of: valveRegex),
                let flowRate = Int(match.2)
            else { print("No match: '\(line)'"); return nil }

            let connected = String(match.3).split(separator: ", ").map(String.init)
            return Valve(name: String(match.1), flowRate: flowRate, connected: connected)
        }
    }

    // Valve OK has flow rate=0; tunnels lead to valves RW, FX
    static let valveRegex = Regex {
        "Valve "
        Capture {
            Repeat(count: 2) {
                One(.word)
            }
        }
        " has flow rate="
        Capture {
            OneOrMore(.digit)
        }
        "; "
        ChoiceOf {
            "tunnel leads to valve "
            "tunnels lead to valves "
        }
        Capture {
            OneOrMore {
                Repeat(count: 2) {
                    One(.word)
                }
                Optionally {
                    ", "
                }
            }
        }
    }
}
