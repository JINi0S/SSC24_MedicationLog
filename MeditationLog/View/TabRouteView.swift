//
//  TabRouteView.swift
//  MeditationLog
//
//  Created by Lee Jinhee on 2/19/24.
//

import SwiftUI

enum Tabs: String, CaseIterable {
    case Today
    case Log
    case Summary
    case Medication
}

struct TabRouteView: View {
    @State private var selection: Tabs = .Today
    
    @StateObject var todayViewModel = TodayViewModel()
    @StateObject var logViewModel = LogViewModel()
    @StateObject var summaryViewModel = SummaryViewModel()
    
    var body: some View {
        TabView(selection: $selection) {
            TodayView(vm: todayViewModel).tag(Tabs.Today)
                .tabItem {
                    Label("Today", systemImage: "pencil")
                }
            LogView(vm: logViewModel).tag(Tabs.Log)
                .tabItem {
                    Label("Log", systemImage: "tray.full")
                }
            SummaryView(vm: summaryViewModel).tag(Tabs.Summary)
                .tabItem {
                    Label("Summary", systemImage: "chart.xyaxis.line")
                }
            MedicationView().tag(Tabs.Medication)
                .tabItem {
                    Label("Medication", systemImage: "pill.fill")
                }
        }
        .tint(Color.ML_Primary)
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    TabRouteView()
}
