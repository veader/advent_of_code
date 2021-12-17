//
//  BITSTransmission.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/16/21.
//

import Foundation

class BITSTransmission {
    let hex: String
    let binary: String

    struct BITSPacket {
        let version: Int
        let typeID: Int

        let value: Int?
        let packets: [BITSPacket]?

        var versionSum: Int {
            version + (packets ?? []).reduce(0) { sum, p in
                sum + p.versionSum
            }
        }

        var computedValue: Int {
            switch typeID {
            case 0:
                guard let packets = packets else { return Int.min }
                return packets.map(\.computedValue).reduce(0, +)
            case 1:
                guard let packets = packets else { return Int.min }
                return packets.map(\.computedValue).reduce(1, *)
            case 2:
                guard let packets = packets else { return Int.min }
                return packets.map(\.computedValue).min() ?? Int.min
            case 3:
                guard let packets = packets else { return Int.min }
                return packets.map(\.computedValue).max() ?? Int.min
            case 4:
                return value ?? 0
            case 5:
                guard let packets = packets, packets.count == 2, let one = packets.first, let two = packets.last else { return Int.min }
                return one.computedValue > two.computedValue ? 1 : 0
            case 6:
                guard let packets = packets, packets.count == 2, let one = packets.first, let two = packets.last else { return Int.min }
                return one.computedValue < two.computedValue ? 1 : 0
            case 7:
                guard let packets = packets, packets.count == 2, let one = packets.first, let two = packets.last else { return Int.min }
                return one.computedValue == two.computedValue ? 1 : 0
            default:
                return 0
            }
        }
    }

    var packets: [BITSPacket] = []

    init(hex: String) {
        self.hex = hex

        self.binary = hex.map(String.init).compactMap { h -> String? in
            guard let hexValue = Int(h, radix: 16) else { return nil }
            return String(hexValue, radix: 2).padded(with: "0", length: 4)
        }.joined()

//        guard let hexValue = Int(hex, radix: 16) else { return nil } // invalid hex
//        self.binary = String(hexValue, radix: 2)
    }


    /// Parse the binary transmission data and analyze the packets
    func parse() {
        var index = binary.startIndex
        packets.append(parsePacket(index: &index))
    }

    /// Traverse the packet heirarchy summing the version numbers
    func packetVersionSum() -> Int {
        // not really needed since there should only be on exterior packet but ¯\_(ツ)_/¯
        packets.reduce(0) { sum, p in
            sum + p.versionSum
        }
    }

    /// Traverse the packet heirarchy calculating the computed sum
    func packetComputedValue() -> Int {
        // not really needed since there should only be on exterior packet but ¯\_(ツ)_/¯
        packets.reduce(0) { sum, p in
            sum + p.computedValue
        }
    }


    // MARK: - Private

    private func parsePacket(index: inout String.Index) -> BITSPacket {
//        print("Binary: \(binary[index...])")

        let versionBinary = readBits(count: 3, index: &index)
        let version = Int(versionBinary, radix: 2) ?? 0

        let typeBinary = readBits(count: 3, index: &index)
        let typeID = Int(typeBinary, radix: 2) ?? 0

        var value: Int?
        var packets: [BITSPacket]?

        switch typeID {
        case 4: // literal packet
            value = parseLiteral(index: &index)
        default: // operation packet
            // TODO: output?
            packets = parseOperationPackets(index: &index)
        }

        return BITSPacket(version: version, typeID: typeID, value: value, packets: packets)
    }

    /// Parse the literal value from the given index.
    private func parseLiteral(index: inout String.Index) -> Int {
//        print("\tLiteral: \(binary[index...])")

        var bits = ""
        var groupBit = peakBit(index: index)

        while groupBit == "1" {
            index = binary.index(after: index) // increment index
            bits += readBits(count: 4, index: &index)
            groupBit = peakBit(index: index) // peak again
        }

        // read final group
        index = binary.index(after: index) // increment index
        bits += readBits(count: 4, index: &index)

//        print("\t   Bits: \(bits)")

        return Int(bits, radix: 2) ?? 0
    }

    /// Parse the operation value from the given index.
    private func parseOperationPackets(index: inout String.Index) -> [BITSPacket]? {
        let lengthTypeID = readBits(count: 1, index: &index)

        var packets = [BITSPacket]()

        switch lengthTypeID {
        case "0": // read sub-packets based on length read
            guard let packetLength = Int(readBits(count: 15, index: &index), radix: 2) else { return nil }
//            print("\tSub-packet length: \(packetLength)")

            let subPacketStartIdx = index // where we started
            while binary.distance(from: subPacketStartIdx, to: index) < packetLength {
                let subPacket = parsePacket(index: &index)
                packets.append(subPacket)
            }
        case "1": // read sub-packets based on number
            guard let packetCount = Int(readBits(count: 11, index: &index), radix: 2) else { return nil }
//            print("\tSub-packet count: \(packetCount)")
            while packets.count < packetCount {
                let subPacket = parsePacket(index: &index)
                packets.append(subPacket)
            }
        default:
            print("\tUnknown length type ID: \(lengthTypeID)")
        }

        return packets
    }

    /// Read the given number of bits from the starting index.
    ///
    /// Once read, the index is moved past the read bits.
    private func readBits(count: Int, index: inout String.Index) -> String {
        let endIdx = binary.index(index, offsetBy: count)
        let value = String(binary[index..<endIdx])
        index = endIdx // move index pointer
        return value
    }

    /// Take a peak at the bit residing at the index. Does not move index.
    private func peakBit(index: String.Index) -> String {
        String(binary[index])
    }
}
