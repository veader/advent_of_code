//
//  AdventDayView.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/1/21.
//

import SwiftUI

struct AdventDayView: View {
    let day: AdventDay
    @State var runOutput: String = ""

    var body: some View {
        VStack(alignment: .leading) {
            Text(day.dayTitle)
                .font(.title)

            Divider()
            HStack {
                Button(action: runPartOne) {
                    Label("Part 1", systemImage: "play")
                }

                Button(action: runPartTwo) {
                    Label("Part 2", systemImage: "play")
                }
            }

            TextEditor(text: $runOutput)
                .lineSpacing(5)
                .font(Font.system(.body, design: .monospaced)) // easier on macOS 12+
                .frame(minWidth: 100, maxWidth: .infinity)

            Spacer()
        }
        .padding()
    }

    func runPartOne() {
        runOutput = "Running part one..."
        run(part: 1)
    }

    func runPartTwo() {
        runOutput = "Running part two..."
        run(part: 2)
    }

    func run(part: Int) {
        DispatchQueue.global(qos: .background).async {
            let output = day.run(part: part)
            DispatchQueue.main.async {
                runOutput = "\(output)"
            }
        }
    }

    // TODO: Consider on macOS 12+
//    func run(part: Int) async throws -> String { }
}

struct AdventDayView_Previews: PreviewProvider {
    static var previews: some View {
        AdventDayView(day: DayOne2021())
    }
}
