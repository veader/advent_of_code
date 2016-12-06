//
//  Day2Tests.swift
//  CodeAdvent2015
//
//  Created by Shawn Veader on 12/18/15.
//  Copyright © 2015 V8 Logic. All rights reserved.
//

import XCTest

class Day2Tests: XCTestCase {
    var box: PresentBox?

    override func setUp() {
        super.setUp()
        box = PresentBox()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testRequireWrappingPaper() {
        var dimensions = "2x3x4"
        box!.parse_dimensions(dimensions)
        XCTAssertEqual(58, box!.wrapping_paper_needed())

        dimensions = "1x1x10"
        box!.parse_dimensions(dimensions)
        XCTAssertEqual(43, box!.wrapping_paper_needed())
    }

    func testRequiredRibbon() {
        let dimensions = "2x3x4"
        box!.parse_dimensions(dimensions)
        XCTAssertEqual(34, box!.ribbon_needed())
    }

}
