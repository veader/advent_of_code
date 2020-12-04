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

    var fullyValid: Bool {
        valid && fields.map({ validate(field: $0, value: $1) }).reduce(true) { $0 && $1 }
    }

    func validate(field: Field, value: String) -> Bool {
        switch field {
        case .birthYear:
            guard let year = Int(value), (1920...2002).contains(year) else { return false }
            return true
        case .issueYear:
            guard let year = Int(value), (2010...2020).contains(year) else { return false }
            return true
        case .expYear:
            guard let year = Int(value), (2020...2030).contains(year) else { return false }
            return true
        case .height:
            guard let height = Int(value.dropLast(2)) else { return false }

            if value.contains("cm") {
                return (150...193).contains(height)
            } else if value.contains("in") {
                return (59...76).contains(height)
            } else {
                return false
            }
        case .hairColor:
            guard value.matching(regex: "\\#[a-f0-9]{6}") != nil else { return false }
            return true
        case .eyeColor:
            return ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"].contains(value)
        case .passportID:
            guard let match = value.matching(regex: "[0-9]{9}") else { return false }
            return match.match == value
        case .countryID:
            return true
        }
    }
}

extension Passport: CustomDebugStringConvertible {
    var debugDescription: String {
        "<Passport: [ "
            + fields.map({ "\($0.rawValue):\($1)" }).joined(separator: " ")
            + " ]>"
    }
}
