//
//  day2.swift
//  CodeAdvent2015
//
//  Created by Shawn Veader on 12/18/15.
//  Copyright © 2015 V8 Logic. All rights reserved.
//

import Foundation

struct BoxSide {
    var length: Int
    var width: Int
}

struct PresentBox {
    var dimensions: [Int] = []

    mutating func parse_dimensions(dimension_string: String) {
        self.dimensions = dimension_string.characters.split("x").map { Int(String($0)) ?? 0 }
        guard self.dimensions.count == 3 else { print("Dimension input incorrect"); exit(200) }
    }

    func area_of_side(length: Int, width: Int) -> Int {
        return length * width
    }

    func perimeter_of_side(length: Int, width: Int) -> Int {
        return (2 * length) + (2 * width)
    }

    func volume() -> Int {
        return self.dimensions[0] * self.dimensions[1] * self.dimensions[2]
    }

    func side_dimensions() -> [BoxSide] {
        var tmp: [BoxSide] = []
        tmp.append(BoxSide(length: self.dimensions[0], width: self.dimensions[1]))
        tmp.append(BoxSide(length: self.dimensions[0], width: self.dimensions[2]))
        tmp.append(BoxSide(length: self.dimensions[1], width: self.dimensions[2]))
        return tmp
    }

    func wrapping_paper_needed() -> Int {
        let sides = side_dimensions().map { area_of_side($0.length, width: $0.width) }
        let smallest_side = sides.sort().first!

        var total_area = 0
        for side in sides {
            total_area = total_area + (2 * side)
        }
        total_area = total_area + smallest_side
        return total_area
    }

    func ribbon_needed() -> Int {
        let sides = side_dimensions().map { perimeter_of_side($0.length, width: $0.width) }
        let smallest_side = sides.sort().first!
        return smallest_side + volume()
    }
}


func advent_day2(input: String) {
    var box = PresentBox()
    box.parse_dimensions(input)
    print("Box needs \(box.wrapping_paper_needed()) square feet of wrapping paper")
    print("Box needs \(box.ribbon_needed()) feet of ribbon")
}