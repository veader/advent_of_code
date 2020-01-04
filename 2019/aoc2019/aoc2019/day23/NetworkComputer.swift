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

    enum ComputerState {
        case idle
        case receiving
        case sending
    }

    var state: ComputerState {
        if !receiveQueue.isEmpty {
            return .receiving
        } else if !packetBuffer.isEmpty {
            return .sending
        } else {
            return .idle
        }
    }

    /// Reference back to the network
    private let network: Network

    /// IntCodeMachine that powers this computer
    private var machine: IntCodeMachine


    /// Queue to store received packets until NIC is ready to read them
    private var receiveQueue: [Network.Packet] {
        var queueCopy: [Network.Packet]!

        receiveQueueAccessQueue.sync {
            queueCopy = self._receiveQueue
        }

        return queueCopy
    }

    /// Internal receiveQueue (actually stores the data) - accessed via barrier sync queue
    private var _receiveQueue: [Network.Packet]

    /// Concurrent access queue for receiveQueue
    private let receiveQueueAccessQueue = DispatchQueue(label: "network.computer.queue.receivequeue", attributes: .concurrent)


    /// Buffer to store pieces of a packet as it is output. Ideally temporarily.
    private var packetBuffer: [Int] {
        var bufferCopy: [Int]!

        packetBufferAccessQueue.sync {
            bufferCopy = self._packetBuffer
        }

        return bufferCopy
    }

    /// Internal packetBuffer (actually stores the data) - accessed via barrier sync queue
    private var _packetBuffer: [Int]

    /// Concurrent access queue for packetBuffer
    private let packetBufferAccessQueue = DispatchQueue(label: "network.computer.queue.packetbuffer", attributes: .concurrent)


    // MARK: - Init
    init(address: Int, instructions: String, network: Network) {
        self.address = address
        self.network = network

        machine = IntCodeMachine(instructions: instructions)

        _receiveQueue = [Network.Packet]()
        _packetBuffer = [Int]()
    }


    // MARK: - Public Methods

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

        receiveQueueAccessQueue.async(flags: .barrier) { [weak self] in
            guard let self = self else { return }
            self._receiveQueue.append(packet)
        }
    }


    // MARK: - Private Methods

    /// Process any queued received messages.
    private func processQueue() {
        guard !receiveQueue.isEmpty else {
            machine.set(input: -1)
            return
        }

        while !receiveQueue.isEmpty {
            // dip in and out of barrier async queue to keep things moving
            receiveQueueAccessQueue.async(flags: .barrier) { [weak self] in
                guard let self = self else { return }

                if !self._receiveQueue.isEmpty {
                    let packet = self._receiveQueue.removeFirst()

                    print("[\(self.address)] Processing: \(packet)")
                    self.machine.set(inputs: [packet.x, packet.y])
                }
            }
        }
    }

    /// Handle any queued outputs from the machine.
    ///   These are buffered to form packets which are sent out on the network.
    private func handleOutputs() {
        while !machine.outputs.isEmpty {
            let chunk = machine.outputs.removeFirst()

            packetBufferAccessQueue.async(flags: .barrier) { [weak self] in
                guard let self = self else { return }

                self._packetBuffer.append(chunk)

                if self._packetBuffer.count == 3 {
                    self.send(data: self._packetBuffer)
                    self._packetBuffer.removeAll() // clear packet buffer to gather more...
                }
            }
        }
    }

    private func send(data: [Int]) {
        guard let packet = Network.Packet(input: data) else { return }
        print("[\(address)] Sending: \(packet)")
        network.dataQueue.async {
            self.network.send(packet: packet)
        }
    }
}
