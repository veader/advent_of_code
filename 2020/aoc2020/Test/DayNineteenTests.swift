//
//  DayNineteenTests.swift
//  Test
//
//  Created by Shawn Veader on 12/19/20.
//

import XCTest

class DayNineteenTests: XCTestCase {

    func testMessageRuleParsing() {
        var rule: MessageRule?

        rule = MessageRule("asfasdfasdf")
        XCTAssertNil(rule)

        rule = MessageRule("0: \"b\"")
        XCTAssertNotNil(rule)
        XCTAssertEqual(0, rule?.number)
        XCTAssertEqual("b", rule?.letter)
        XCTAssertNil(rule?.subRules)

        rule = MessageRule("1: 2 3 4")
        XCTAssertNotNil(rule)
        XCTAssertEqual(1, rule?.number)
        XCTAssertNil(rule?.letter)
        XCTAssertEqual([[2,3,4]], rule?.subRules)

        rule = MessageRule("2: 3 4 5 | 4 5 3")
        XCTAssertNotNil(rule)
        XCTAssertEqual(2, rule?.number)
        XCTAssertNil(rule?.letter)
        XCTAssertEqual([[3,4,5], [4,5,3]], rule?.subRules)
    }

    func testRuleParser() {
        var parser: RuleParser

        parser = RuleParser("""
                0: 4 1 5
                1: 2 3 | 3 2
                2: 4 4 | 5 5
                3: 4 5 | 5 4
                4: "a"
                5: "b"
                """)
        XCTAssertEqual(6, parser.rules.count)
        XCTAssertEqual(0, parser.messages.count)

        parser = RuleParser("""
                0: 4 1 5
                1: 2 3 | 3 2
                2: 4 4 | 5 5
                3: 4 5 | 5 4
                4: "a"
                5: "b"

                ababbb
                bababa
                abbbab
                aaabbb
                aaaabbb
                """)
        XCTAssertEqual(6, parser.rules.count)
        XCTAssertEqual(5, parser.messages.count)
        XCTAssertTrue(parser.messages.contains("abbbab"))
        XCTAssertFalse(parser.messages.contains("xxyyzz"))
    }

    func testSimplePossibilities() {
        let parser = RuleParser("""
                0: 1 2
                1: "a"
                2: 1 3 | 3 1
                3: "b"
                """)
        let valid = parser.buildMap()
        XCTAssertEqual(2, valid.count)
        XCTAssert(valid.contains("aab"))
        XCTAssert(valid.contains("aba"))
    }

    func testSlightlyMoreComplexPossibilities() {
        let parser = RuleParser("""
                0: 4 1 5
                1: 2 3 | 3 2
                2: 4 4 | 5 5
                3: 4 5 | 5 4
                4: "a"
                5: "b"
                """)
        let valid = parser.buildMap()
        XCTAssertEqual(8, valid.count)
    }

    func testValidMessages() {
        let parser = RuleParser("""
                0: 4 1 5
                1: 2 3 | 3 2
                2: 4 4 | 5 5
                3: 4 5 | 5 4
                4: "a"
                5: "b"

                ababbb
                bababa
                abbbab
                aaabbb
                aaaabbb
                """)
        let messages = parser.validMessages()
        XCTAssertEqual(2, messages.count)
        XCTAssert(messages.contains("ababbb"))
        XCTAssert(messages.contains("abbbab"))
    }

}
