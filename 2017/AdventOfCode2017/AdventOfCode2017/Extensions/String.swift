//
//  String.swift
//  AdventOfCode2017
//
//  Created by Shawn Veader on 12/12/17.
//  Copyright © 2017 v8logic. All rights reserved.
//

import Foundation

extension String {
    func trimmed() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }

    func centered(width: Int) -> String {
        var centeredString = self
        var isLeft = true // are we inserting the space on the left or right?
        let space = " "

        while centeredString.count < width {
            if isLeft {
                centeredString = space + centeredString
            } else {
                centeredString.append(space)
            }
            isLeft = !isLeft
        }

        return centeredString
    }
}
