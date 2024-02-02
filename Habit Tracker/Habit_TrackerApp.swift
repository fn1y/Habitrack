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
    
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .modelContainer(for: [BasicHabit.self, CompletionHistory.self])
    }
}
