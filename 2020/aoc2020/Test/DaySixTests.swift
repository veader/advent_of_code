//
//  DaySixTests.swift
//  Test
//
//  Created by Shawn Veader on 12/6/20.
//

import XCTest

class DaySixTests: XCTestCase {

    func testCustomsFormParsing() {
        let form = CustomsForm("""
                ab
                ac
                """)

        XCTAssertEqual(2, form.groupSize)
        XCTAssertEqual(2, form.reponses.count)
        XCTAssertEqual(2, form.answers["a"])
        XCTAssertEqual(1, form.answers["b"])
        XCTAssertEqual(1, form.answers["c"])
        XCTAssertEqual(3, form.yesQuestions)
    }

    func testPartOne() {
        let input = """
        abc

        a
        b
        c

        ab
        ac

        a
        a
        a
        a

        b
        """

        let day = DaySix()
        let forms = day.parse(input)
        let yeses = forms.reduce(0) { $0 + $1.yesQuestions }
        XCTAssertEqual(11, yeses)
    }


}
