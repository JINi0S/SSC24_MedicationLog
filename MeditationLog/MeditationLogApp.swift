//
//  MeditationLogApp.swift
//  MeditationLog
//
//  Created by Lee Jinhee on 4/24/24.
//

import SwiftUI

@main
struct MeditationLogApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            StartView()
            //ContentView()
                //.environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
