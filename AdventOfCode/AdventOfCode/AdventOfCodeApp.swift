//
//  AdventOfCodeApp.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/1/21.
//

import SwiftUI

@main
struct AdventOfCodeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .commands {
            AdventCommands()
        }
    }
}
