//
//  DaySixteen2021Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/16/21.
//

import XCTest

class DaySixteen2021Tests: XCTestCase {

    let sampleInput1 = "D2FE28"
    let sampleInput2 = "38006F45291200"
    let sampleInput3 = "EE00D40C823060"

    func testBITSTransmissionInit() {
        var tx = BITSTransmission(hex: sampleInput1)
        XCTAssertEqual("110100101111111000101000", tx.binary)

        tx = BITSTransmission(hex: sampleInput2)
        XCTAssertEqual("00111000000000000110111101000101001010010001001000000000", tx.binary)

        tx = BITSTransmission(hex: sampleInput3)
        XCTAssertEqual("11101110000000001101010000001100100000100011000001100000", tx.binary)
    }

    func testBITSTransmissionParsingLiteral() {
        let tx = BITSTransmission(hex: sampleInput1)
        tx.parse()

        let packet = tx.packets.first
        XCTAssertNotNil(packet)
        XCTAssertEqual(6, packet!.version)
        XCTAssertEqual(4, packet!.typeID)
        XCTAssertEqual(2021, packet!.value)

        XCTAssertEqual(6, tx.packetVersionSum())
    }

    func testBITSTransmissionParsingOperationLength() {
        let tx = BITSTransmission(hex: sampleInput2)
        tx.parse()

        let packet = tx.packets.first
        XCTAssertNotNil(packet)
        XCTAssertEqual(1, packet!.version)
        XCTAssertEqual(6, packet!.typeID)
        XCTAssertNil(packet!.value)
        XCTAssertEqual(2, packet!.packets?.count)

        XCTAssertEqual(9, tx.packetVersionSum())
    }

    func testBITSTransmissionParsingOperationCount() {
        let tx = BITSTransmission(hex: sampleInput3)
        tx.parse()

        let packet = tx.packets.first
        XCTAssertNotNil(packet)
        XCTAssertEqual(7, packet!.version)
        XCTAssertEqual(3, packet!.typeID)
        XCTAssertNil(packet!.value)
        XCTAssertEqual(3, packet!.packets?.count)

        XCTAssertEqual(14, tx.packetVersionSum())
    }

    func testBITSTransmissionVersionSum() {
        var tx = BITSTransmission(hex: "8A004A801A8002F478")
        tx.parse()
        XCTAssertEqual(16, tx.packetVersionSum())

        tx = BITSTransmission(hex: "620080001611562C8802118E34")
        tx.parse()
        XCTAssertEqual(12, tx.packetVersionSum())

        tx = BITSTransmission(hex: "C0015000016115A2E0802F182340")
        tx.parse()
        XCTAssertEqual(23, tx.packetVersionSum())

        tx = BITSTransmission(hex: "A0016C880162017C3686B18A3D4780")
        tx.parse()
        XCTAssertEqual(31, tx.packetVersionSum())
    }

    func testBITSTransmissionComputedSum() {
        var tx = BITSTransmission(hex: "C200B40A82")
        tx.parse()
        XCTAssertEqual(3, tx.packetComputedValue())

        tx = BITSTransmission(hex: "04005AC33890")
        tx.parse()
        XCTAssertEqual(54, tx.packetComputedValue())

        tx = BITSTransmission(hex: "880086C3E88112")
        tx.parse()
        XCTAssertEqual(7, tx.packetComputedValue())

        tx = BITSTransmission(hex: "CE00C43D881120")
        tx.parse()
        XCTAssertEqual(9, tx.packetComputedValue())

        tx = BITSTransmission(hex: "D8005AC2A8F0")
        tx.parse()
        XCTAssertEqual(1, tx.packetComputedValue())

        tx = BITSTransmission(hex: "F600BC2D8F")
        tx.parse()
        XCTAssertEqual(0, tx.packetComputedValue())

        tx = BITSTransmission(hex: "9C005AC2F8F0")
        tx.parse()
        XCTAssertEqual(0, tx.packetComputedValue())

        tx = BITSTransmission(hex: "9C0141080250320F1802104A08")
        tx.parse()
        XCTAssertEqual(1, tx.packetComputedValue())

    }
}
