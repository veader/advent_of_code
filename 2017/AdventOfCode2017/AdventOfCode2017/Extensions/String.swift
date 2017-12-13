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
}
