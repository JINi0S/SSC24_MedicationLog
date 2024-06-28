//
//  ChartView.swift
//  
//
//  Created by Lee Jinhee on 2/24/24.
//

import SwiftUI
import Charts

struct ChartData: Identifiable {
    let id = UUID()
    var day: Day
    var count: Int
}

struct ChartView: View {
    @State private var onAppear = false

    let datas: [ChartData]
        
    var body: some View {
        ZStack {
            Group {
                Chart(datas) { data in
                    BarMark(
                        x: .value("Time", data.day.rawValue),
                        y: .value("Sum", data.count)
                    ).cornerRadius(14)
                }
                .foregroundStyle(Color.ML_Primary.opacity(0.5))
                .frame(height: 200)
                .frame(maxWidth: .infinity)
                .chartXAxisLabel("")
                .chartYAxisLabel("")
                .animation(.easeInOut(duration: 1), value: onAppear)
                .chartXAxis {
                    AxisMarks(preset: .aligned, position: .bottom, stroke: StrokeStyle(lineWidth: 0))
                }
                .chartYAxis {
                    AxisMarks(preset: .aligned, position: .trailing, stroke: StrokeStyle(lineWidth: 0))
                }
            }
        }
        .onAppear {
            onAppear = true
        }
    }
}

#Preview {
    ChartView(datas: [])
}
