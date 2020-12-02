//
//  PasswordPolicy.swift
//  aoc2020
//
//  Created by Shawn Veader on 12/2/20.
//

import Foundation

struct PasswordPolicy {
    let range: ClosedRange<Int>
    let letter: String

    /// Parse the input to form the range and letter requirements for this policy.
    ///
    /// Example: "3-5 z"
    init?(_ input: String?) {
        guard
            let match = input?.matching(regex: "^([0-9]+)\\-([0-9]+) ([a-z])"),
            match.captures.count == 3,
            let rangeStart = Int(match.captures[0]),
            let rangeEnd = Int(match.captures[1]),
            let letterCapture = match.captures.last
            else { return nil }

        range = rangeStart...rangeEnd
        letter = letterCapture
    }

    func isValid(password: String) -> Bool {
        let occurances = password.filter { String($0) == letter }
        return range.contains(occurances.count)
    }
}

struct SamplePassword {
    let policy: PasswordPolicy
    let password: String

    /// Example: "3-5 z: zznzslv"
    init?(_ input: String?) {
        guard
            let match = input?.matching(regex: "(.*)\\: ([a-z]+)"),
            match.captures.count == 2,
            let capturedPolicy = PasswordPolicy(match.captures.first),
            let capturedSample = match.captures.last
            else { return nil }

        policy = capturedPolicy
        password = capturedSample
    }

    var valid: Bool {
        policy.isValid(password: password)
    }
}
