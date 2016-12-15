#!/usr/bin/env swift

import Foundation

extension String {
    struct RegexMatch : CustomDebugStringConvertible {
        let match: String
        let captures: [String]?
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

// MARK: - Address
struct Address {
    var supernetSequences: [String]?
    var hypernetSequences: [String]?
    let input: String

    init(_ theInput: String) {
        input = theInput
        supernetSequences = [String]()
        hypernetSequences = [String]()

        let parsedResults = parseInput(theInput)
        supernetSequences = parsedResults.nonBrackets
        hypernetSequences = parsedResults.brackets
    }

    func supportsTLS() -> Bool {
        guard let sequences = supernetSequences else { return false }
        let abbas = sequences.flatMap { findABBA($0) }

        if let _ = hypernetSequences {
            let abbasInHypernetSequenes = hypernetSequences!.flatMap { findABBA($0) }

            if abbasInHypernetSequenes.count > 0 {
                return false
            }
        }

        return abbas.count > 0
    }

    func findABBA(_ str: String) -> String? {
        // abba is an ABBA
        // aaaa is NOT an ABBA
        // abcd is NOT an ABBA
        var abba: String?

        // http://rubular.com/r/vnleSZmZzJ
        let abbaRegExPattern = "([a-z])([^\\1])\\2\\1"
        if let matches = str.matches(regex: abbaRegExPattern) {
            _ = matches.map { match -> Void in
                guard let captures = match.captures else { return }
                if captures[0] != captures[1] { // prevent aaaa from matching
                    abba = match.match
                }
            }
        }

        return abba
    }

    func supportsSSL() -> Bool {
        guard let superSequences = supernetSequences else { return false }
        var sslSupport = false

        // find all ABA's in the supernet sequences
        var ABAs = [ABA]()
        _ = superSequences.map { ABAs.append(contentsOf: findABA($0)) }

        // only one ABA needs to have a corresponding BAB in the hypernet sequences
        _ = ABAs.map { aba -> Void in
            if sslSupport { return }

            if hasBAB(for: aba.bab) {
                sslSupport = true
            }
        }

        return sslSupport
    }

    struct ABA {
        let value: String
        let firstLetter: String
        let secondLetter: String

        var bab: String {
            return "\(secondLetter)\(firstLetter)\(secondLetter)"
        }
    }

    // find all ABA sequences
    func findABA(_ str: String) -> [ABA] {
        // aba is an ABA
        // aaa is NOT an ABA
        // abc is NOT an ABA
        var abas = [ABA]()

        // http://rubular.com/r/AME7RKDfRy
        let abaRegExPattern = "([a-z])([^\\1])\\1"
        _ = (0..<str.characters.count).map { offset in
            // grab substring, this allows us to capture ABA that share a char
            //    example: zazbz -> zaz & zbz
            let index = str.index(str.startIndex, offsetBy: offset)
            let subString = str.substring(from: index)

            if let matches = subString.matches(regex: abaRegExPattern) {
                _ = matches.map { match -> Void in
                    guard let captures = match.captures else { return }
                    if captures[0] != captures[1] { // prevent aaa from matching
                        let aba = ABA.init(value: match.match, firstLetter: captures[0], secondLetter: captures[1])
                        abas.append(aba)
                    }
                }
            }
        }

        return abas
    }

    func hasBAB(for aba: String) -> Bool {
        guard let hyperSequences = hypernetSequences else { return false }
        let match = hyperSequences.first( where: { $0.contains(aba) } )
        return match != nil
    }

    func hasMatchingBAB(_ bab: String) -> Bool {
        return false
    }

    private func parseInput(_ theInput: String) -> (nonBrackets: [String]?, brackets: [String]?) {
        let regex = "\\[(.*?)\\]" // match brackets
        if let matches = theInput.matches(regex: regex) {
            var nonBrackets = [String]()
            var brackets = [String]()
            var startIndex: String.Index?

            _ = matches.map { match -> Void in
                brackets.append(match.match)

                guard let range = match.range.toRange() else { print("NO RANGE!"); return }
                let index = theInput.index(theInput.startIndex, offsetBy: range.lowerBound)

                if startIndex != nil { // middle of string
                    let s = theInput.substring(with: (startIndex!..<index))
                    nonBrackets.append(s)
                } else { // beginning of string
                    let s = theInput.substring(to: index)
                    nonBrackets.append(s)
                }

                // jump over the brackets
                let finalIndex = theInput.index(theInput.startIndex, offsetBy: range.upperBound)
                startIndex = finalIndex
            }

            // determine if anything is left at the tail of the string
            if startIndex != nil && startIndex != theInput.endIndex {
                let s = theInput.substring(from: startIndex!)
                nonBrackets.append(s)
            }

            return (nonBrackets, brackets)
        }
        return (nil, nil)
    }
}


// MARK: - Helpers
// returns the lines out of the input file
func readInputData() -> [String] {
    guard let currentDir = ProcessInfo.processInfo.environment["PWD"] else {
        print("No current directory.")
        return []
    }

    let inputPath: String = "\(currentDir)/input.txt"
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

// ------------------------------------------------------------------
// MARK: - "MAIN()"

let lines = readInputData()

let addresses = lines.map { Address.init($0) }
let nonTLSAddresses = addresses.flatMap { addr -> Address? in
    if addr.supportsTLS() {
        return addr
    } else {
        return nil
    }
}

let sslAddresses = addresses.flatMap { addr -> Address? in
    if addr.supportsSSL() {
        return addr
    } else {
        return nil
    }
}

print("Found \(nonTLSAddresses.count) Addresses that support TLS")
print("Found \(sslAddresses.count) Addresses that support SSL")
