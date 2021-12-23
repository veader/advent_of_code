//
//  TrenchMap.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/21/21.
//

import Foundation

class TrenchMap {
    enum BinaryPixel: String {
        case lit = "#"
        case dark = "."

        static func parse(_ input: String) -> BinaryPixel? {
            switch input {
            case "#":
                return .lit
            case ".":
                return .dark
            default:
                return nil
            }
        }
    }

    var algoDecoder: [BinaryPixel]
    var litPixels: Set<Coordinate>
    var defaultPixelValue: BinaryPixel
    var xBounds: ClosedRange<Int>
    var yBounds: ClosedRange<Int>

    init(decoder: [BinaryPixel], litPixels: Set<Coordinate>) {
        self.algoDecoder = decoder
        self.litPixels = litPixels
        self.defaultPixelValue = .dark

        // make compiler happy, then find the real ones
        self.xBounds = 0...10
        self.yBounds = 0...10
        calculateBounds()
    }

    /// Find the adjacent set of pixels (including this pixel) and build a 9 character map.
    ///
    /// Takes for of 3 pixels above, 2 pixels on either side of this pixel, and 3 pixels below.
    /// Example:
    ///
    /// ```
    /// # . . # .
    /// #[. . .].
    /// #[# . .]#
    /// .[. # .].
    /// . . # # #
    /// ```
    ///
    /// For coordinate 2,2 we get " `...#...#.` "
    func pixelMap(for coordinate: Coordinate) -> String {
        let bounds = stretchedBounds(by: 10)

        var adjacent = coordinate.adjacent(xBounds: bounds.xs, yBounds: bounds.ys)
        adjacent.insert(coordinate, at: adjacent.count / 2) // should be the middle of the array

        return adjacent.map({ value(at: $0) }).joined()
    }

    /// What is the value (as a `String`) for a given coordinate?
    func value(at coordinate: Coordinate) -> String {
        if litPixels.contains(coordinate) {
            return BinaryPixel.lit.rawValue // pixel is lit
        } else if xBounds.contains(coordinate.x) && yBounds.contains(coordinate.y) {
            return BinaryPixel.dark.rawValue // pixel is dark if it is in our bounds and NOT lit
        } else {
            return defaultPixelValue.rawValue // use our default pixel for anything out of bounds
        }
    }

    /// Using the `pixelMap` result, build an index into the algorithm decoder array.
    func binaryIndex(for coordinate: Coordinate) -> Int {
        let pixels = pixelMap(for: coordinate)
        let bits = pixels.map({ $0 == "#" ? "1": "0" }).joined()
        return Int(bits, radix: 2) ?? 0
    }

    /// Run the image enhancement algorithm to calculate the new image.
    func enhanceImage(count: Int = 1) {
        var step = 0
        while step < count {
            let pixelSpace = stretchedBounds(by: 1) // extend by 1 above/below current space

            var newLitPixels = Set<Coordinate>()
            pixelSpace.ys.forEach { y in
                pixelSpace.xs.forEach { x  in
                    let c = Coordinate(x: x, y: y)
                    let index = binaryIndex(for: c)
                    let newPixel = algoDecoder[index]
                    if case .lit = newPixel {
                        newLitPixels.insert(c)
                    }
                }
            }

            // calculate new default pixel
            let faroutCoordinate = Coordinate(x: xBounds.lowerBound - 3, y: yBounds.lowerBound - 3)
            let faroutIndex = binaryIndex(for: faroutCoordinate)
            let newDefaultPixel = algoDecoder[faroutIndex]
//            print("Current Default: \(defaultPixelValue.rawValue) | New: \(newDefaultPixel.rawValue)")
//            print("\tValue @0: \(algoDecoder.first!) | Value @511: \(algoDecoder.last!)")
            defaultPixelValue = newDefaultPixel
            // not sure this matters for any case other than the algoDecoder[0] being lit causing the infinite space to flash on/off

            // find our new lit pixels
            litPixels = newLitPixels
            // recalculate our bounds
            calculateBounds()

            step += 1
        }
    }

    func printImage() {
        let pixelSpace = stretchedBounds(by: 1) // extend by 1 above/below current space

        let output: String = pixelSpace.ys.map({ y -> String in
            pixelSpace.xs.map({ x -> String in
                value(at: Coordinate(x: x, y: y))
            }).joined()
        }).joined(separator: "\n")

        print(output)
    }

    private func stretchedBounds(by amount: Int) -> (xs: ClosedRange<Int>, ys: ClosedRange<Int>) {
        let xRange = (xBounds.lowerBound - amount)...(xBounds.upperBound + amount)
        let yRange = (yBounds.lowerBound - amount)...(yBounds.upperBound + amount)
        return (xRange, yRange)
    }

    private func calculateBounds() {
        let xs = litPixels.map(\.x)
        xBounds = (xs.min() ?? 0)...(xs.max() ?? 100)
        let ys = litPixels.map(\.y)
        yBounds = (ys.min() ?? 0)...(ys.max() ?? 100)
    }
}
