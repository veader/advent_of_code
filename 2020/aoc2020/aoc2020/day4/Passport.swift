//
//  Passport.swift
//  aoc2020
//
//  Created by Shawn Veader on 12/4/20.
//

import Foundation

struct Passport {
    enum Field: String, CaseIterable {
        case birthYear = "byr"
        case issueYear = "iyr"
        case expYear = "eyr"
        case height = "hgt"
        case hairColor = "hcl"
        case eyeColor = "ecl"
        case passportID = "pid"
        case countryID = "cid"
    }

    let fields: [Field: String]

    init?(_ input: String) {
        var tmpFields = [Field: String]()

        input.replacingOccurrences(of: "\n", with: " ") // pretend it's one long string instead of multiple lines
            .split(separator: " ") // String -> [String] : separate fields
            .map(String.init) // [Substring] -> [String] : sigh...
            .forEach { fieldData in
                let pieces = fieldData.split(separator: ":").map(String.init)
                guard
                    pieces.count == 2,
                    let field = Field(rawValue: pieces[0])
                    else { return }

                tmpFields[field] = pieces[1]
            }

        fields = tmpFields
    }

    private var requiredFields: Set<Field> {
        Set(Field.allCases).subtracting(Set([Field.countryID]))
    }

    /// Examine the fields in the passport to determine if it is valid
    var valid: Bool {
        let intersection = Set(fields.keys).intersection(requiredFields)
        return intersection == requiredFields
    }
}

extension Passport: CustomDebugStringConvertible {
    var debugDescription: String {
        "<Passport: [ "
            + fields.map({ "\($0.rawValue):\($1)" }).joined(separator: " ")
            + " ]>"
    }
}
