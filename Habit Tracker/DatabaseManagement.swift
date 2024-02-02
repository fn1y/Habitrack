//
//  HabitManager.swift
//  Habit Tracker
//
//  Created by Finlay Carson Moretti on 13/08/2023.
//

import Foundation
import SwiftData


//An old unused model for testing UI stuff
@Model
class HabitTest: Identifiable {
    var id: String
    var icon: String
    var name: String
    
    var type: Int
    
    init(icon: String, name: String){
        
        self.id = UUID().uuidString
        
        self.icon = String(icon)
        self.name = String(name)
        
        self.type = 0
    }
}

//The main habit class
@Model
class BasicHabit: Identifiable {
    var id: String
    
    var icon: String
    var name: String
    
    var type: Int
    
    //Treat days of the week as an array of integers. E.g. 1 = Monday
    var days: Array<Int>
    
    var timeHours: Int
    var timeMins: Int
    
    var progressCurrent: Int
    var progressGoal: Int
    
    //var isCompleted: [Date: Bool]
    
    init(icon: String, name: String, days: Array<Int>, timeHours: Int, timeMins: Int, progressCurrent: Int, progressGoal: Int){
        self.id = UUID().uuidString
        
        self.icon = icon
        self.name = name
        
        self.type = 1
        
        self.days = days
        
        self.timeHours = timeHours
        self.timeMins = timeMins
        
        self.progressCurrent = progressCurrent
        self.progressGoal = progressGoal
        
        //self.isCompleted = false
    }
}

//The CompletionHistory class
//Stores habit IDs completed for each day
//Also stores completion amount for progress/segmented habits
@Model
class CompletionHistory: Identifiable {
    //This SwiftData model will act like a dictionary, where the date is the key.
    //Each date will have an array of habit UUIDs that were completed on that specific day.
    var date: Date
    var habits: Array<String>
    var completion: Int
    
    init(inputDate: Date, inputHabits: Array<String>, inputCompletion: Int){
        
        self.date = inputDate
        self.habits = inputHabits
        self.completion = inputCompletion
        
        
    }
}

//func deleteHabit(deleteId: String, habitArray: [Habit]){
//    for habit in habitArray{
//        if habit.id == deleteId{
//            
//        }
//    }
//}
