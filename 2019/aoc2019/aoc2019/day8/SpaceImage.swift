//
//  SpaceImage.swift
//  aoc2019
//
//  Created by Shawn Veader on 12/8/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import Foundation

struct SpaceImage {
    struct Layer {
        let width: Int
        let height: Int
        let pixels: [Int]

        enum PixelColor: Int {
            case black = 0
            case white = 1
            case transparent = 2
        }

        func count(pixel value:Int) -> Int {
            pixels.filter({ $0 == value }).count
        }

        func color(x: Int, y: Int) -> PixelColor? {
            let location = y * width + x
            guard
                (0..<width).contains(x),
                (0..<height).contains(y),
                location < pixels.count
                else { return nil }
            return PixelColor(rawValue: pixels[location])
        }
    }

    let width: Int
    let height: Int
    let data: [Int]

    var layers: [SpaceImage.Layer]

    init(width: Int, height: Int, data: [Int]) {
        self.width = width
        self.height = height
        self.data = data

        // chunks of width * height pixels for each layer
        let chunks = data.chunks(size: width * height)
        layers = chunks.map { Layer(width: width, height: height, pixels: $0) }
    }

    func layer(fewest value: Int) -> Layer? {
        let counts: [(Layer, Int)] = layers.map { ($0, $0.count(pixel: value)) }
        let sorted = counts.sorted { $0.1 < $1.1 }
        return sorted.first?.0
    }

    func color(x: Int, y: Int) -> Layer.PixelColor? {
        guard (0..<width).contains(x), (0..<height).contains(y) else { return nil }

        for layer in layers {
            guard let pixelColor = layer.color(x: x, y: y) else { continue }

            if case .transparent = pixelColor {
                continue
            }

            return pixelColor
        }

        return nil
    }
}

extension SpaceImage: CustomStringConvertible {
    var description: String {
        var output = ""

        for y in (0..<height) {
            for x in (0..<width) {
                if let color = color(x: x, y: y), case .black = color {
                    output += " "
                } else {
                    output += "#"
                }
            }
            output += "\n"
        }

        return output
    }
}
