//
//  main.swift
//  CodeAdvent2015
//
//  Created by Shawn Veader on 12/17/15.
//  Copyright © 2015 V8 Logic. All rights reserved.
//

import Foundation

enum AdventDay: String {
    case Day1 = "1"
    case Day2 = "2"
}

if Process.arguments.count > 1 {
    guard Process.arguments.count >= 2 else { print("Please specify day"); exit(100) }
    guard Process.arguments.count >= 3 else { print("Please pass input");  exit(101) }

    let day = AdventDay(rawValue: Process.arguments[1])

    let input = Process.arguments[2]
    switch day! {
    case .Day1:
        advent_day1(input)
    case .Day2:
        advent_day2(input)
    default:
        print("Please specify valid day")
    }
}
