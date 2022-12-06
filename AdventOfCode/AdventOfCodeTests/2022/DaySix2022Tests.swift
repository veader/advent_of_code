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

    func testReadWindow() {
        var radio = DaySix2022.RadioStream(data: sample1)
        var answer = radio.findStartPacketMarker()
        XCTAssertEqual(7, answer?.end)

        radio = DaySix2022.RadioStream(data: sample2)
        answer = radio.findStartPacketMarker()
        XCTAssertEqual(5, answer?.end)

        radio = DaySix2022.RadioStream(data: sample3)
        answer = radio.findStartPacketMarker()
        XCTAssertEqual(6, answer?.end)

        radio = DaySix2022.RadioStream(data: sample4)
        answer = radio.findStartPacketMarker()
        XCTAssertEqual(10, answer?.end)

        radio = DaySix2022.RadioStream(data: sample5)
        answer = radio.findStartPacketMarker()
        XCTAssertEqual(11, answer?.end)
    }
}
