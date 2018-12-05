//
//  StringTests.swift
//  Test
//
//  Created by Shawn Veader on 12/4/18.
//  Copyright © 2018 Shawn Veader. All rights reserved.
//

import XCTest

class StringTests: XCTestCase {

    func testNotMatching() {
        XCTAssertNil("foo".matching(regex: "bar"))
    }

    func testMatchingString() {
        let result = "foo".matching(regex: "oo")
        XCTAssertNotNil(result)
        XCTAssertEqual("oo", result?.match)
        XCTAssertEqual(0, result?.captures.count)
    }

    func testMatchingCaptures() {
        let result = "foo".matching(regex: "f(.+)")
        XCTAssertNotNil(result)
        XCTAssertEqual("foo", result?.match)
        XCTAssertEqual(1, result?.captures.count)
    }

    func testMatchingDotRegEx() {
        let result = "foo".matching(regex: ".")
        XCTAssertNotNil(result)
        XCTAssertEqual("f", result?.match)
        XCTAssertEqual(0, result?.captures.count)
    }

}
