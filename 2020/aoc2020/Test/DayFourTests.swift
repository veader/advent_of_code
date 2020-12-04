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

        valid = Passport("""
        hcl:#ae17e1 iyr:2013
        eyr:2024
        ecl:brn pid:760753108 byr:1931
        hgt:179cm
        """)!
        XCTAssertTrue(valid.valid)

        // -----

        var invalid = Passport("""
        iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
        hcl:#cfa07d byr:1929
        """)!
        XCTAssertFalse(invalid.valid)

        invalid = Passport("""
        hcl:#cfa07d eyr:2025 pid:166559648
        iyr:2011 ecl:brn hgt:59in
        """)!
        XCTAssertFalse(invalid.valid)
    }

    func testDayFourParsing() {
        let day = DayFour()
        let passports = day.parse(allPassports)
        XCTAssertEqual(4, passports.count)
    }

    func testFieldValidation() {
        let password = Passport(validPassport)!

        XCTAssertTrue(password.validate(field: .birthYear, value: "2002"))
        XCTAssertFalse(password.validate(field: .birthYear, value: "2003"))

        XCTAssertTrue(password.validate(field: .height, value: "60in"))
        XCTAssertTrue(password.validate(field: .height, value: "190cm"))
        XCTAssertFalse(password.validate(field: .height, value: "190in"))
        XCTAssertFalse(password.validate(field: .height, value: "190"))

        XCTAssertTrue(password.validate(field: .hairColor, value: "#123abc"))
        XCTAssertFalse(password.validate(field: .hairColor, value: "#123abz"))
        XCTAssertFalse(password.validate(field: .hairColor, value: "123abc"))

        XCTAssertTrue(password.validate(field: .eyeColor, value: "brn"))
        XCTAssertFalse(password.validate(field: .eyeColor, value: "wat"))

        XCTAssertTrue(password.validate(field: .passportID, value: "000000001"))
        XCTAssertFalse(password.validate(field: .passportID, value: "0123456789"))
    }

    func testFullValidation() {
        var passport: Passport

        passport = Passport("""
                eyr:1972 cid:100
                hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926
                """)!
        XCTAssertFalse(passport.fullyValid)

        passport = Passport("""
                iyr:2019
                hcl:#602927 eyr:1967 hgt:170cm
                ecl:grn pid:012533040 byr:1946
                """)!
        XCTAssertFalse(passport.fullyValid)

        passport = Passport("""
                hcl:dab227 iyr:2012
                ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277
                """)!
        XCTAssertFalse(passport.fullyValid)

        passport = Passport("""
                hgt:59cm ecl:zzz
                eyr:2038 hcl:74454a iyr:2023
                pid:3556412378 byr:2007
                """)!
        XCTAssertFalse(passport.fullyValid)

        passport = Passport("""
                pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980
                hcl:#623a2f
                """)!
        XCTAssertTrue(passport.fullyValid)

        passport = Passport("""
                eyr:2029 ecl:blu cid:129 byr:1989
                iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm
                """)!
        XCTAssertTrue(passport.fullyValid)

        passport = Passport("""
                hcl:#888785
                hgt:164cm byr:2001 iyr:2015 cid:88
                pid:545766238 ecl:hzl
                eyr:2022
                """)!
        XCTAssertTrue(passport.fullyValid)

        passport = Passport("""
                iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719
                """)!
        XCTAssertTrue(passport.fullyValid)
    }
}
