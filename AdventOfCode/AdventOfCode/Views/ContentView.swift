//
//  ContentView.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/1/21.
//

import SwiftUI

// https://developer.apple.com/tutorials/swiftui/creating-a-macos-app

struct ContentView: View {
    @State var year: AdventYear = AdventYear.allCases.last!
    @State var selectedProxy: AdventDayProxy?

    var days: [AdventDayProxy] { year.days.map { AdventDayProxy(day: $0) } }
    var title: String { year.rawValue }

    var body: some View {
        NavigationSplitView {
            List(AdventYear.allCases, selection: $year) { year in
                Label(year.rawValue, systemImage: "calendar")
            }
        } content: {
            List(days) { proxy in
                Button {
                    withAnimation {
                        selectedProxy = proxy
                    }
                } label: {
                    AdventDayCell(day: proxy.day, selected: proxy == selectedProxy)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        } detail: {
            if let selectedProxy {
                AdventDayView(day: selectedProxy.day)
            } else {
                Text("Select day")
            }
        }
        .onAppear {
            if let day = days.last {
                selectedProxy = day
            }
        }
        .navigationSplitViewStyle(.prominentDetail)
    }
}

// silly proxy wrapper so that the days are Hashable and Identifiable without the protocol mess
struct AdventDayProxy: Identifiable, Hashable {
    var id: String { day.id }

    let day: AdventDay

    static func == (lhs: AdventDayProxy, rhs: AdventDayProxy) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
