//
//  String.swift
//  aoc2019
//
//  Created by Shawn Veader on 1/6/20.
//  Copyright © 2020 Shawn Veader. All rights reserved.
//

import Foundation

extension String {

    /// Return a set of integers that represent the ASCII values of the characters
    ///     within this string.
    func ascii() -> [Int] {
        self.compactMap { char -> Int? in
            guard let ascii = char.asciiValue else { return nil }
            return Int(ascii)
        }
    }
}
