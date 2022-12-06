//
//  DaySix2022.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/6/22.
//

import Foundation

struct DaySix2022: AdventDay {
    var year = 2022
    var dayNumber = 6
    var dayTitle = "Tuning Trouble"
    var stars = 1

    struct RadioStream {
        let data: String

        func findStartPacketMarker() -> String.ReadWindow? {
            let markerLength = 4
            guard data.count >= markerLength else { return nil }

            var readWindow = String.ReadWindow(start: 0, length: markerLength)

            while readWindow.end < data.count {
                guard let segment = data.substring(at: readWindow) else { break }
                let substring = String(segment).map(String.init)

                if Set(substring).count == markerLength {
                    break
                } else {
                    readWindow.move()
                }
            }

            return readWindow
        }
    }

    func partOne(input: String?) -> Any {
        let radio = RadioStream(data: input ?? "")
        let answer = radio.findStartPacketMarker()
        return answer?.end ?? 0
    }

    func partTwo(input: String?) -> Any {
        return 0
    }
}
