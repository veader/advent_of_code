//
//  AdventDayCell.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/1/21.
//

import SwiftUI

struct AdventDayCell: View {
    var day: AdventDay
    var selected: Bool

    var body: some View {
        VStack {
            HStack(alignment: .top) {
                if selected {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.yellow)
                        .frame(width: 2)

                }

                VStack(alignment: .leading) {
                    Text("Day \(day.dayNumber)")
                        .font(.title2)
                    Text(day.dayTitle)
                        .foregroundColor(.secondary)
                }

                Spacer()

                HStack(spacing: 2) {
                    ForEach(0..<2) { starIdx in
                        if day.stars > starIdx {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                        } else {
                            Image(systemName: "star")
                        }
                    }
                }
            }
        }
    }
}

struct AdventDayCell_Previews: PreviewProvider {
    static var previews: some View {
        AdventDayCell(day: DayOne2021(), selected: false)
    }
}
