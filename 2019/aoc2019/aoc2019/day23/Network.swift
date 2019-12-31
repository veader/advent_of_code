//
//  Network.swift
//  aoc2019
//
//  Created by Shawn Veader on 12/30/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import Foundation

class Network {
    public struct Packet {
        let address: Int
        let x: Int
        let y: Int
    }

    var computers: [NetworkComputer]

    private var computerCount: Int
    private var nicInstructions: String

    private let group = DispatchGroup()
    private let computerQueue: DispatchQueue
    private let dataQueue: DispatchQueue

    init(count: Int, instructions: String) {
        computerCount = count
        nicInstructions = instructions

        computers = [NetworkComputer]()

        computerQueue = DispatchQueue(label: "networkComputerQ", qos: .default, attributes: .concurrent)
        dataQueue = DispatchQueue(label: "networkDataQ", qos: .default, attributes: .concurrent)
    }

    func setupComputers() {
        computers = (0..<computerCount).map { addr in
            NetworkComputer(address: addr, instructions: nicInstructions, network: self, dataQueue: dataQueue)
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

        group.wait()
    }

    func send(packet: Packet) {
        if (0..<computerCount).contains(packet.address) {
            let recipient = computers[packet.address]
            computerQueue.async {
//                print("Sending packet to \(packet.address)...")
                recipient.receive(packet: packet)
            }
        } else {
            print("**** Revieved packet to address: \(packet.address) -> \(packet)")
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
