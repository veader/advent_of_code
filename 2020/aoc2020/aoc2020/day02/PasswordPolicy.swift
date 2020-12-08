//
//  PasswordPolicy.swift
//  aoc2020
//
//  Created by Shawn Veader on 12/2/20.
//

import Foundation

struct PasswordPolicy {
    enum PolicyType {
        case count
        case position
    }

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

    /// Is the given password valid given the policy described here?
    ///
    /// Policy type dictates how the range and letter are treated in determining what is valid.
    func isValid(password: String, type: PolicyType? = .count) -> Bool {
        guard let type = type else { return false }

        switch type {
        case .count:
            let occurances = password.filter { String($0) == letter }
            return range.contains(occurances.count)
        case .position:
            let chars = Array(password).map(String.init)
            guard var firstIdx = range.first, var lastIdx = range.last else { return false }

            // make 0 indexed
            firstIdx -= 1
            lastIdx -= 1

            let firstIdxMatch = chars.indices.contains(firstIdx) && chars[firstIdx] == letter
            let lastIdxMatch = chars.indices.contains(lastIdx) && chars[lastIdx] == letter

            return (firstIdxMatch || lastIdxMatch) && !(firstIdxMatch && lastIdxMatch)
        }
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

    func valid(policyType: PasswordPolicy.PolicyType? = .count) -> Bool {
        policy.isValid(password: password, type: policyType)
    }
}
