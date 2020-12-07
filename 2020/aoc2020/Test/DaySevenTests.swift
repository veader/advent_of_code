//
//  DaySevenTests.swift
//  Test
//
//  Created by Shawn Veader on 12/7/20.
//

import XCTest

class DaySevenTests: XCTestCase {

    let sampleInput = """
    light red bags contain 1 bright white bag, 2 muted yellow bags.
    dark orange bags contain 3 bright white bags, 4 muted yellow bags.
    bright white bags contain 1 shiny gold bag.
    muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
    shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
    dark olive bags contain 3 faded blue bags, 4 dotted black bags.
    vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
    faded blue bags contain no other bags.
    dotted black bags contain no other bags.
    """

    let secondSampleInput = """
    shiny gold bags contain 2 dark red bags.
    dark red bags contain 2 dark orange bags.
    dark orange bags contain 2 dark yellow bags.
    dark yellow bags contain 2 dark green bags.
    dark green bags contain 2 dark blue bags.
    dark blue bags contain 2 dark violet bags.
    dark violet bags contain no other bags.
    """

    func testLuggageRuleParsing() {
        var rule: LuggageRule?

        // bad input
        rule = LuggageRule("bla blah")
        XCTAssertNil(rule)

        // no children
        rule = LuggageRule("dotted black bags contain no other bags.")
        XCTAssertNotNil(rule)
        XCTAssertEqual("dotted black", rule!.color)
        XCTAssertFalse(rule!.hasParents)
        XCTAssertFalse(rule!.hasChildren)

        // with single children
        rule = LuggageRule("bright white bags contain 1 shiny gold bag.")
        XCTAssertNotNil(rule)
        XCTAssertEqual("bright white", rule!.color)
        XCTAssertFalse(rule!.hasParents)
        XCTAssertTrue(rule!.hasChildren)
        XCTAssertEqual(1, rule!.children.count)
        XCTAssertEqual(1, rule!.children["shiny gold"])

        // with multiple children
        rule = LuggageRule("muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.")
        XCTAssertNotNil(rule)
        XCTAssertEqual("muted yellow", rule!.color)
        XCTAssertFalse(rule!.hasParents)
        XCTAssertTrue(rule!.hasChildren)
        XCTAssertEqual(2, rule!.children.count)
        XCTAssertEqual(2, rule!.children["shiny gold"])
        XCTAssertEqual(9, rule!.children["faded blue"])
    }

    func testLuggageRuleSetParsing() {
        var rule: LuggageRule?
        let ruleSet = LuggageRuleSet(sampleInput.split(separator: "\n").map(String.init))
        XCTAssertEqual(9, ruleSet.rules.count)

        rule = ruleSet.rules["faded blue"]
        XCTAssertFalse(rule!.hasChildren)
        XCTAssertEqual(3, rule?.parents.count)

        rule = ruleSet.rules["dotted black"]
        XCTAssertFalse(rule!.hasChildren)
        XCTAssertEqual(2, rule?.parents.count)

        rule = ruleSet.rules["vibrant plum"]
        XCTAssertEqual(2, rule?.children.count)
        XCTAssertEqual(1, rule?.parents.count)

        rule = ruleSet.rules["shiny gold"]
        XCTAssertEqual(2, rule?.children.count)
        XCTAssertEqual(2, rule?.parents.count)
    }

    func testLuggageRuleParentFinding() {
        let ruleSet = LuggageRuleSet(sampleInput.split(separator: "\n").map(String.init))
        let parents = ruleSet.parents(of: "shiny gold")
        XCTAssertEqual(4, parents.count)
    }

    func testLuggageRuleChildBagCount() {
        var ruleSet: LuggageRuleSet

        ruleSet = LuggageRuleSet(sampleInput.split(separator: "\n").map(String.init))
        XCTAssertEqual(32, ruleSet.childBagCount(of: "shiny gold"))

        ruleSet = LuggageRuleSet(secondSampleInput.split(separator: "\n").map(String.init))
        XCTAssertEqual(126, ruleSet.childBagCount(of: "shiny gold"))
    }
}
