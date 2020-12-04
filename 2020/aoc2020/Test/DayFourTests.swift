//
//  DayFourTests.swift
//  Test
//
//  Created by Shawn Veader on 12/4/20.
//

import XCTest

class DayFourTests: XCTestCase {
    let validPassport = """
    ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
    byr:1937 iyr:2017 cid:147 hgt:183cm
    """

    let invalidPassport = """
    iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
    hcl:#cfa07d byr:1929
    """

    let altValidPassport = """
    hcl:#ae17e1 iyr:2013
    eyr:2024
    ecl:brn pid:760753108 byr:1931
    hgt:179cm
    """

    let altInvalidPassport = """
    hcl:#cfa07d eyr:2025 pid:166559648
    iyr:2011 ecl:brn hgt:59in
    """

    let allPassports = """
    ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
    byr:1937 iyr:2017 cid:147 hgt:183cm

    iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
    hcl:#cfa07d byr:1929

    hcl:#ae17e1 iyr:2013
    eyr:2024
    ecl:brn pid:760753108 byr:1931
    hgt:179cm

    hcl:#cfa07d eyr:2025 pid:166559648
    iyr:2011 ecl:brn hgt:59in
    """

    func testPassportParsing() {
        let passport = Passport(validPassport)
        XCTAssertNotNil(passport)
        XCTAssertEqual(8, passport?.fields.keys.count)
        print(passport!)
    }

    func testPassportValidation() {
        var valid = Passport(validPassport)!
        XCTAssertTrue(valid.valid)

        valid = Passport(altValidPassport)!
        XCTAssertTrue(valid.valid)

        // -----

        var invalid = Passport(invalidPassport)!
        XCTAssertFalse(invalid.valid)

        invalid = Passport(altInvalidPassport)!
        XCTAssertFalse(invalid.valid)
    }

    func testDayFourParsing() {
        let day = DayFour()
        let passports = day.parse(allPassports)
        XCTAssertEqual(4, passports.count)
    }
}
