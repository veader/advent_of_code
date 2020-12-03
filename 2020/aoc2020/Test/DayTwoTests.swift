//
//  DayTwoTests.swift
//  Test
//
//  Created by Shawn Veader on 12/2/20.
//

import XCTest

class DayTwoTests: XCTestCase {

    func testPasswordPolicyParsing() throws {
        let goodPolicy = PasswordPolicy("1-2 a")
        XCTAssertNotNil(goodPolicy)
        XCTAssertEqual(1, goodPolicy?.range.first)
        XCTAssertEqual(2, goodPolicy?.range.last)
        XCTAssertEqual("a", goodPolicy?.letter)

        let badPolicy = PasswordPolicy("something -1-1 a a;: 123")
        XCTAssertNil(badPolicy)

        XCTAssertNil(PasswordPolicy(nil))
    }

    func testSamplePasswordParsing() throws {
        let goodPassword = SamplePassword("1-2 a: abcde")
        XCTAssertNotNil(goodPassword)
        XCTAssertEqual("abcde", goodPassword?.password)

        let badPassword = SamplePassword("abced 1-2")
        XCTAssertNil(badPassword)

        XCTAssertNil(SamplePassword(nil))
    }

    func testPasswordValidation() {
        let policy = PasswordPolicy("1-2 a")!
        XCTAssertTrue(policy.isValid(password: "a"))
        XCTAssertTrue(policy.isValid(password: "aa"))
        XCTAssertFalse(policy.isValid(password: "aaa"))
        XCTAssertFalse(policy.isValid(password: "b"))
    }

    func testPasswordPolicyPositionValidation() {
        let policy = PasswordPolicy("1-3 a")!
        XCTAssertTrue(policy.isValid(password: "abc", type: .position))
        XCTAssertTrue(policy.isValid(password: "cba", type: .position))
        XCTAssertTrue(policy.isValid(password: "cbazzzzz", type: .position))
        XCTAssertFalse(policy.isValid(password: "cccccc", type: .position))
    }
}
