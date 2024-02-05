//
//  InterfaceFunctions.swift
//  Habit Tracker
//
//  Created by Finlay Carson Moretti on 15/08/2023.
//

import Foundation

//I stole these quotes from the internet. Tee hee!
let quotes = [
    "When you have a dream, you've got to grab it and never let go.",
    "Nobody sets the rules but you. You can design your own life.",
    "Life isn’t about finding yourself. Life is about creating yourself.",
    "Doubt kills more dreams than failure ever will.",
    "Keep your face always toward the sunshine, and shadows will fall behind you.",
    "You do not find the happy life. You make it.",
]

//Simple function for returning a random quote.
//Use ! to let Swift know there WILL be a string. Otherwise it gets scared it might return nil.
func randQuote() -> String{
    let quoteReturn = quotes.randomElement()!
    return quoteReturn
}

//This is an inefficient solution to return strings containing the days a habit is to be completed on. THIS IS HOW A 5 YEAR OLD WOULD DO THIS!! MUST OPTIMISE
func formattedFrequencyString(days: Array<Int>, hrs: Int, mins: Int) -> String{
    var returnString = ""
    var multipleDays = false
    
    if days == [1,2,3,4,5,6,7]{
        returnString.append("Daily")
    }
    else if days == [1,7]{
        returnString.append("Weekends")
    }
    else{
        
        for day in days{
            if day == 1{
                returnString.append("Sun")
                multipleDays = true
            }
            
            else if day == 2{
                if multipleDays == true{
                    returnString.append(", ")
                }
                returnString.append("Mon")
                multipleDays = true
            }
            
            else if day == 3{
                if multipleDays == true{
                    returnString.append(", ")
                }
                returnString.append("Tue")
                multipleDays = true
            }
            
            else if day == 4{
                if multipleDays == true{
                    returnString.append(", ")
                }
                returnString.append("Wed")
                multipleDays = true
            }
            
            else if day == 5{
                if multipleDays == true{
                    returnString.append(", ")
                }
                returnString.append("Thu")
                multipleDays = true
            }
            
            else if day == 6{
                if multipleDays == true{
                    returnString.append(", ")
                }
                returnString.append("Fri")
                multipleDays = true
            }
            
            else if day == 7{
                if multipleDays == true{
                    returnString.append(", ")
                }
                returnString.append("Sat")
                multipleDays = true
            }
            
        }
        
    }
    
    let timeString = " at \(hrs):\(mins)"
    
    returnString.append(timeString)
    
    return returnString
}

//Get current date and strip time info so reads 00:00:00 and no funky logic stuff breaks because of different times. WE CAN IGNORE TIME SAFELY FOR THIS APP!
func getDate() -> Date {
    let today = Date()
    let calendar = Calendar.current
    
    let dateComponents = calendar.dateComponents([.year, .month, .day], from: today)
    let dateWithoutTime = calendar.date(from: dateComponents)!
    
    return dateWithoutTime
}

//Gets the day of the week as an integer for creating habits etc.
func getDayOfWeek() -> Int {
    let today = Date()
    let calendar = Calendar.current
    
    let dayOfWeek = calendar.component(.weekday, from: today)
    
    return dayOfWeek
}

//Gets the current date as user-readable string for the top of HomeView
func getDateString() -> String{
    let today = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "d MMMM yyyy"
    
    return dateFormatter.string(from: today).uppercased()

}

