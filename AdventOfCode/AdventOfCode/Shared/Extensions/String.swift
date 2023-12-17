//
//  String.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/2/21.
//

import Foundation

extension String {
    /// Applies regular expression to string returning the match and captures.
    /// - note: Only catches first match
    ///
    /// - parameters:
    ///     - regex: String describing regular expression. Converted into `NSRegularExpression`
    ///
    /// - returns: Tuple with match and captures. Nil if no match was found.
    func matching(regex regexPattern: String) -> (match: String, captures: [String])? {
        guard
            let regex = try? NSRegularExpression(pattern: regexPattern, options: .caseInsensitive)
            else { return nil }

        let matches = regex.matches(in: self, options: [], range: NSRange(location: 0, length: count))
        guard let match = matches.first else { return nil }

        var captures = [String]()

        for index in 0..<match.numberOfRanges {
            let range = match.range(at: index)
            captures.append((self as NSString).substring(with: range))
        }

        // first capture is the full match
        guard let matchString = captures.first else { return nil }
        captures = Array(captures.dropFirst())

        return (match: matchString, captures)
    }

    /// Returns a new String padded to the appropriate length with the given padding string.
    func padded(with padding: String, length: Int) -> String {
        var copy = self

        while copy.count < length {
            copy = padding + copy
        }

        return copy
    }

    /// Alphabetically sort the characters in the string and return a new string
    func sortedString() -> String {
        sorted().map(String.init).joined()
    }

    /// Create a histogram for the number of occurances of each character within the string.
    func histogram() -> [String: Int] {
        var gram = [String: Int]()
        self.forEach { c in
            gram.incrementing(String(c), by: 1)
        }
        return gram
    }

    /// Structure defining a moving read window within a string
    struct ReadWindow {
        var start: Int
        var length: Int

        var end: Int {
            start + length
        }

        mutating func move() {
            start += 1
        }
    }

    /// Return a `Substring` using the provided `ReadWindow`
    func substring(at window: ReadWindow) -> Substring? {
        guard window.end < count else { return nil }
        let startIdx = index(startIndex, offsetBy: window.start)
        let endIdx = index(startIndex, offsetBy: window.end)
        return self[startIdx..<endIdx]
    }

    /// Return a collection of Strings created by splitting this string by newline.
    func lines() -> [String] {
        split(separator: "\n").map(String.init)
    }

    /// Return a collection of Strings created by splitting this string by each character.
    func charSplit() -> [String] {
        split(separator: "").map(String.init)
    }

    /// Silly, simple "hash" algo from 2023 day 15.
    var simpleHash: Int {
        var value = 0

        for char in self {
            guard let ascii = char.asciiValue else {
                print("⚠️ Unknown value for \(char)") // TODO: should we throw?
                continue
            }

            value = ((value + Int(ascii)) * 17) % 256
        }

        return value
    }
}
