//
//  String.swift
//  AdventOfCode2018
//
//  Created by Shawn Veader on 12/4/18.
//  Copyright © 2018 Shawn Veader. All rights reserved.
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
}
