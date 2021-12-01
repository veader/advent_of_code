//
//  ContentView.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/1/21.
//

import SwiftUI

// https://developer.apple.com/tutorials/swiftui/creating-a-macos-app

struct ContentView: View {
    @State var year: AdventYear = .year2021
    @State var selectedDay: AdventDay?

    var days: [AdventDay] { year.days }
    var title: String { year.rawValue }

    var body: some View {
        NavigationView {
            List {
                ForEach(days, id: \.id) { day in
                    NavigationLink {
                        AdventDayView(day: day)
                    } label: {
                        AdventDayCell(day: day)
                    }
                }
            }
            .navigationTitle(title)
            .frame(minWidth: 300)
            .toolbar {
                ToolbarItem {
                    Menu {
                        Picker("Year", selection: $year) {
                            ForEach(AdventYear.allCases) { theYear in
                                Text(theYear.rawValue).tag(theYear)
                            }
                        }
                        .pickerStyle(.inline)
                    } label: {
                        Text(title)
                        //Label(title, systemImage: "slider.horizontal.3")
                    }
                }
            }

            Text("Select a day")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
