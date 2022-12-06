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
    var stars = 2

    struct RadioStream {
        let data: String

        enum MarkerType {
            case packet
            case message

            var size: Int {
                switch self {
                case .packet:
                    return 4
                case .message:
                    return 14
                }
            }
        }

        func findMarker(_ type: MarkerType) -> String.ReadWindow? {
            guard data.count >= type.size else { return nil }

            var readWindow = String.ReadWindow(start: 0, length: type.size)

            while readWindow.end < data.count {
                guard let segment = data.substring(at: readWindow) else { break }
                let substring = String(segment).map(String.init)

                if Set(substring).count == type.size {
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
        let answer = radio.findMarker(.packet)
        return answer?.end ?? 0
    }

    func partTwo(input: String?) -> Any {
        let radio = RadioStream(data: input ?? "")
        let answer = radio.findMarker(.message)
        return answer?.end ?? 0
    }
}
