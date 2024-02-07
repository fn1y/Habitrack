//
//  Habit_TrackerApp.swift
//  Habit Tracker
//
//  Created by Finlay Carson Moretti on 11/08/2023.
//

import SwiftUI
import SwiftData

@main
struct Habit_TrackerApp: App {
    
    //Container config tutorial thanks to Sean Allen
    let container: ModelContainer = {
        let schema = Schema([BasicHabit.self, CompletionHistory.self])
        let container = try! ModelContainer(for: schema, configurations: [])
        return container
    }()
    
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .modelContainer(container)
    }
}
