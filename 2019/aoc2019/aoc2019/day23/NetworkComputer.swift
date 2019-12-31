//
//  NetworkComputer.swift
//  aoc2019
//
//  Created by Shawn Veader on 12/30/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import Foundation

class NetworkComputer {
    let address: Int

    private let network: Network
    private var machine: IntCodeMachine

    /// Queue to store received packets until NIC is ready to read them
    private var receiveQueue: [Network.Packet]

    /// Buffer to store pieces of a packet as it is output. Ideally temporarily.
    private var packetBuffer: [Int]

    private var dataQueue: DispatchQueue

    init(address: Int, instructions: String, network: Network, dataQueue: DispatchQueue) {
        self.address = address
        self.network = network
        self.dataQueue = dataQueue

        machine = IntCodeMachine(instructions: instructions)

        receiveQueue = [Network.Packet]()
        packetBuffer = [Int]()
    }

    // Boot and start the machine running...
    func boot(group: DispatchGroup) {
        defer { group.leave() }
        group.enter()

        var finished = false

        print("[\(address)] Booting...")
        machine.silent = true
        machine.set(input: address)
        machine.run()

        while !finished {
            if case .finished(output: _) = machine.state {
                print("[\(address)] Finished")
                handleOutputs()

                finished = true
            } else if case .awaitingInput = machine.state {
                // print("[\(address)] Awaiting Input")
                handleOutputs()

                sleep(1)
                processQueue()
            }
        }
    }

    /// Receive a packet on the network interface.
    func receive(packet: Network.Packet) {
        guard packet.address == address else { print("[\(address)] Why did we get someone else's packet?"); return }

        // TODO: protect writing to the receiveQueue... it's not safe now
        receiveQueue.append(packet)
        // TODO: could just load inputs for this immediately on the machine...
    }

    private func processQueue() {
        guard !receiveQueue.isEmpty else {
            machine.set(input: -1)
            return
        }

        while !receiveQueue.isEmpty {
            let packet = receiveQueue.removeFirst()
            print("[\(address)] Processing: \(packet)")
            machine.set(inputs: [packet.x, packet.y])
        }
    }

    private func handleOutputs() {
        while !machine.outputs.isEmpty {
            let chunk = machine.outputs.removeFirst()
            packetBuffer.append(chunk)

            if packetBuffer.count == 3 {
                send(data: packetBuffer)
                packetBuffer.removeAll() // clear packet buffer to gather more...
            }
        }
    }

    private func send(data: [Int]) {
        guard let packet = Network.Packet(input: data) else { return }
        print("[\(address)] Sending: \(packet)")
        dataQueue.async {
            self.network.send(packet: packet)
        }
    }
}
