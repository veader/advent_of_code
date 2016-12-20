#!/usr/bin/env swift

import Foundation

enum ThingType: String {
    case bot = "bot"
    case output = "output"
}

struct ChipMove {
    let chip: Int
    let toName: String
    let toType: ThingType
}

// ----------------------------------------------------------------------------
class BotNet {
    var bots = [String: Bot]()
    var outputs = [String: Int]()
    var moves = [ChipMove]()

    func setup(_ input: [String]) {
        var setterLines = [String]()

        // create bots and gather value setting lines
        input.forEach { line in
            if let bot = Bot(line) {
                bots[bot.name] = bot
            } else {
                setterLines.append(line)
            }
        }

        // http://rubular.com/r/Cfq1RqhDvG
        let setterRegex = "value (\\d+) goes to bot (\\d+)"
        setterLines.forEach { line in
            guard let matches = line.matches(regex: setterRegex) else {
                print("Unknown Line: '\(line)'"); return
            }
            guard let match = matches.first else { return }
            guard let theBot = bots[match.captures[1]] else {
                print("Unknown bot: \(line)"); return
            }

            var bot = theBot
            let results = bot.gives(chip: Int.init(match.captures[0])!)
            bots[match.captures[1]] = bot // store changes

            moves.append(contentsOf: results)
        }
    }

    func run() {
        while !moves.isEmpty {
            let move = moves.removeFirst()

            switch move.toType {
            case .bot:
                if var bot = bots[move.toName] {
                    let results = bot.gives(chip: move.chip)
                    bots[move.toName] = bot // store changes

                    moves.append(contentsOf: results)
                } else {
                    print("Unknown bot: \(move)")
                }
            case .output:
                print("Putting \(move.chip) in output \(move.toName)")
                outputs[move.toName] = move.chip
            }
        }
    }
}

// ----------------------------------------------------------------------------
struct Bot {
    let name: String
    var chipValue: Int?

    let lowType: ThingType
    let lowName: String

    let highType: ThingType
    let highName: String

    init?(_ input: String) {
        // http://rubular.com/r/fVSVFw00qF
        let botRegex = "^bot (\\d+) gives low to (bot|output) (\\d+) and high to (bot|output) (\\d+)"

        if let matches = input.matches(regex: botRegex) {
            guard let match = matches.first else { return nil }

            name = match.captures[0]

            guard let theLowType = ThingType(rawValue: match.captures[1]) else { return nil }
            lowType = theLowType
            lowName = match.captures[2]

            guard let theHighType = ThingType(rawValue: match.captures[3]) else { return nil }
            highType = theHighType
            highName = match.captures[4]
        } else {
            return nil
        }
    }

    mutating func gives(chip: Int) -> [ChipMove] {
        if let botChip = chipValue {
            // if we have 2 chips now, we need to hand them out
            var low: Int
            var high: Int

            if botChip > chip {
                high = botChip
                low = chip
            } else {
                high = chip
                low = botChip
            }

            chipValue = nil
            print("BOT \(name) gives \(low) to \(lowType)[\(lowName)] and \(high) to \(highType)[\(highName)]")
            return [ChipMove(chip: low, toName: lowName, toType: lowType),
                    ChipMove(chip: high, toName: highName, toType: highType)]
        } else {
            chipValue = chip // store and wait for second chip
            return [ChipMove]()
        }
    }
}

// ----------------------------------------------------------------------------
extension String {
    struct RegexMatch : CustomDebugStringConvertible {
        let match: String
        let captures: [String]
        let range: NSRange

        var debugDescription: String {
            return "RegexMatch( match: '\(match)', captures: [\(captures)], range: \(range) )"
        }

        init(string: String, regexMatch: NSTextCheckingResult) {
            var theCaptures: [String] = (0..<regexMatch.numberOfRanges).flatMap { index in
                let range = regexMatch.rangeAt(index)
                if let _ = range.toRange() {
                    return (string as NSString).substring(with: range)
                } else {
                    return nil
                }
            }

            match = theCaptures.removeFirst() // the 0 index is the whole string that matches
            captures = theCaptures
            range = regexMatch.range
        }
    }

    func matches(regex: String) -> [RegexMatch]? {
        do {
            let regex = try NSRegularExpression(pattern: regex, options: .caseInsensitive)
            let wholeThing = NSMakeRange(0, characters.count)
            let regexMatches = regex.matches(in: self, options: .withoutAnchoringBounds, range: wholeThing)

            guard let _ = regexMatches.first else { return nil }

            return regexMatches.flatMap { m in
                return RegexMatch.init(string: self, regexMatch: m)
            }
        } catch {
            return nil
        }
    }
}

// ----------------------------------------------------------------------------
// returns the lines out of the input file
func readInputData() -> [String] {
    guard let currentDir = ProcessInfo.processInfo.environment["PWD"] else {
        print("No current directory.")
        return []
    }

    let inputPath = "\(currentDir)/input.txt"
    do {
        let data = try String(contentsOfFile: inputPath, encoding: .utf8)
        let lines = data.components(separatedBy: "\n")
                        .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                        .filter { !$0.isEmpty }
        return lines
    } catch {
        return []
    }
}

// ----------------------------------------------------------------------------
// MARK: - "MAIN()"
let lines = readInputData()

var botNet = BotNet()
botNet.setup(lines)
botNet.run()

/*
print("\n")
// print(botNet.outputs)
let outZero = botNet.outputs["0"]
let outOne = botNet.outputs["1"]
let outTwo = botNet.outputs["2"]
print(outZero)
print(outOne)
print(outTwo)
*/
