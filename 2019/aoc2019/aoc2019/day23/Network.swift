//
//  Network.swift
//  aoc2019
//
//  Created by Shawn Veader on 12/30/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import Foundation

class Network {
    public struct Packet: Equatable {
        let address: Int
        let x: Int
        let y: Int
    }

    var computers: [NetworkComputer]
    var useNAT: Bool = false

    private var computerCount: Int
    private var nicInstructions: String
    private var natPackets: [Packet]
    private var natSentYValues: [Int]

    private let group = DispatchGroup()
    private let computerQueue: DispatchQueue
    public let dataQueue: DispatchQueue

    init(count: Int, instructions: String) {
        computerCount = count
        nicInstructions = instructions

        computers = [NetworkComputer]()
        natPackets = [Packet]()
        natSentYValues = [Int]()

        computerQueue = DispatchQueue(label: "networkComputerQ", qos: .default, attributes: .concurrent)
        dataQueue = DispatchQueue(label: "networkDataQ", qos: .default, attributes: .concurrent)
    }

    func setupComputers() {
        computers = (0..<computerCount).map { addr in
            NetworkComputer(address: addr, instructions: nicInstructions, network: self)
        }
        print(computers)
    }

    func go() {
        computers.forEach { computer in
            computerQueue.async { [weak self] in
                guard let self = self else { return }
                computer.boot(group: self.group)
            }
        }

        scheduledNATCheck()

        group.wait()
    }

    func send(packet: Packet) {
        if (0..<computerCount).contains(packet.address) {
            let recipient = computers[packet.address]
            computerQueue.async {
                recipient.receive(packet: packet)
            }
        } else if packet.address == 255 {
            if useNAT {
                print("**** [NAT] -> \(packet)")
                natPackets.append(packet)
            } else {
                print("**** First packet to 255: \(packet)")
                exit(0)
            }
        } else {
            print("**** Received packet to address: \(packet.address) -> \(packet)")
        }
    }

    private func scheduledNATCheck() {
        guard useNAT else { return }

        computerQueue.asyncAfter(deadline: .now() + 10) { [weak self] in
            guard let self = self else { return }

            // determine if there are computers NOT in idle state
            let nonIdleComputers = self.computers.filter { $0.state != .idle }

            if nonIdleComputers.isEmpty {
                print("**** All computers are idle... \(Date())")
                if let packet = self.natPackets.last {
                    // send the last packet to computer @ address 0
                    let newPacket = Packet(address: 0, x: packet.x, y: packet.y)
                    print("**** Sending last NAT packet... \(newPacket)")

                    if let lastSentYValue = self.natSentYValues.last {
                        if lastSentYValue == newPacket.y {
                            print("**** DUPLICATE Y SENT TO NAT: \(packet)")
                            exit(0)
                        }
                    }
                    self.natSentYValues.append(newPacket.y)

                    self.dataQueue.async {
                        self.send(packet: newPacket)
                    }
                }
            }

            self.scheduledNATCheck() // schedule again...
        }
    }
}

extension Network.Packet {
    init?(input: [Int]) {
        guard input.count == 3 else { return nil }
        address = input[0]
        x = input[1]
        y = input[2]
    }
}
