//
//  DaySix2022Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/6/22.
//

import XCTest

final class DaySix2022Tests: XCTestCase {
    let sample1 = "mjqjpqmgbljsphdztnvjfqwrcgsmlb"
    let sample2 = "bvwbjplbgvbhsrlpgdmjqwftvncz"
    let sample3 = "nppdvjthqldpwncqszvftbrmjlhg"
    let sample4 = "nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg"
    let sample5 = "zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw"

    func testFindPacketMarker() {
        var radio = DaySix2022.RadioStream(data: sample1)
        var answer = radio.findMarker(.packet)
        XCTAssertEqual(7, answer?.end)

        radio = DaySix2022.RadioStream(data: sample2)
        answer = radio.findMarker(.packet)
        XCTAssertEqual(5, answer?.end)

        radio = DaySix2022.RadioStream(data: sample3)
        answer = radio.findMarker(.packet)
        XCTAssertEqual(6, answer?.end)

        radio = DaySix2022.RadioStream(data: sample4)
        answer = radio.findMarker(.packet)
        XCTAssertEqual(10, answer?.end)

        radio = DaySix2022.RadioStream(data: sample5)
        answer = radio.findMarker(.packet)
        XCTAssertEqual(11, answer?.end)
    }

    func testFindMessageMarker() {
        var radio = DaySix2022.RadioStream(data: sample1)
        var answer = radio.findMarker(.message)
        XCTAssertEqual(19, answer?.end)

        radio = DaySix2022.RadioStream(data: sample2)
        answer = radio.findMarker(.message)
        XCTAssertEqual(23, answer?.end)

        radio = DaySix2022.RadioStream(data: sample3)
        answer = radio.findMarker(.message)
        XCTAssertEqual(23, answer?.end)

        radio = DaySix2022.RadioStream(data: sample4)
        answer = radio.findMarker(.message)
        XCTAssertEqual(29, answer?.end)

        radio = DaySix2022.RadioStream(data: sample5)
        answer = radio.findMarker(.message)
        XCTAssertEqual(26, answer?.end)
    }
}
