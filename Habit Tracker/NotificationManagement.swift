//
//  NotificationManagement.swift
//  Habit Tracker
//
//  Created by Finlay Carson Moretti on 16/08/2023.
//

import Foundation
import NiceNotifications
import DateBuilder
import SwiftData
import UIKit
import UserNotifications


func handleNotifications(){
    let center = UNUserNotificationCenter.current()
    center.removeAllDeliveredNotifications()    // to remove all delivered notifications
    center.removeAllPendingNotificationRequests()   // to remove all pending notifications
}

//func convertDayToEnum(dayInt: Int) -> day? {
//    let dayEnums: [Int: DayOfWeek] = [1: .sunday, 2: .monday, 3: .tuesday, 4: .wednesday, 5: .thursday, 6: .friday, 7: .saturday]
//    return dayEnums[dayInt]
//}

//THIS ENTIRE SOLUTION IS CURRENTLY A BODGE WHILE I FIGURE OUT HOW TO PROPERLY IMPLEMENT THINGS
//IT SCHEDULES A MONTH'S WORTH OF NOTIFICATIONS UPON HABIT CREATION AND DOES NOT ACCOUNT FOR ANYTHING LIKE THE HABIT BEING DELETED OR SOMEHOW EDITED



func scheduleNotifs(habitId: String, hour: Int, minute: Int, days: Array<Int>, bodyText: String, bodyIcon: String){
    let body = String(bodyIcon + " " + bodyText)
    
    let notifContent = UNMutableNotificationContent()
    notifContent.title = "Habit Reminder"
    notifContent.body = body
    
    let calendar = Calendar.current
    
    for day in days{
        var components = DateComponents()
        components.hour = hour
        components.minute = minute
        components.weekday = day
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        //I previously set the identifier to the habitId exactly but this overwrites itself if scheduled for multiple days. What I do is add a suffix for the day of the week to help things. Also acts as a way to see the day of a notification just from its id.
        
        let requestIdentifier = "\(habitId)_\(day)"
        let request = UNNotificationRequest(identifier: requestIdentifier, content: notifContent, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if error != nil {
                print("Error scheduling notification for \(habitId) on day \(day)")
                
            }
            
        }
        
    }
}

func debugPrintAllNotifs(){
    UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { (requests) in

        for request in requests {
            
            print(request)
            
        }
    })
}

func deleteNotifs(identifier: String) {
    
    var currentIdentifier = ""
    
    for day in 1...7{
        
        currentIdentifier = String("\(identifier)_\(day)")
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [currentIdentifier])
    }
}
        
        
        func oldScheduleNotifications(habitId: String, hour: Int, minute: Int, days: Array<Int>, bodyText: String, bodyIcon: String){
            
            let body = String(bodyIcon + " " + bodyText)
            
            for day in days{
                
                if day == 1{
                    
                    LocalNotifications.schedule(permissionStrategy: .askSystemPermissionIfNeeded) {
                        EveryWeek(forWeeks: 4, starting: .thisWeek)
                            .weekday(.sunday)
                            .at(hour: hour, minute: minute)
                            .schedule(title: "Habit Reminder", body: body)
                    }
                }
                
                else if day == 2{
                    LocalNotifications.schedule(permissionStrategy: .askSystemPermissionIfNeeded) {
                        EveryWeek(forWeeks: 4, starting: .thisWeek)
                            .weekday(.monday)
                            .at(hour: hour, minute: minute)
                            .schedule(title: "Habit Reminder", body: body)
                    }
                }
                
                else if day == 3{
                    LocalNotifications.schedule(permissionStrategy: .askSystemPermissionIfNeeded) {
                        EveryWeek(forWeeks: 4, starting: .thisWeek)
                            .weekday(.tuesday)
                            .at(hour: hour, minute: minute)
                            .schedule(title: "Habit Reminder", body: body)
                    }
                }
                
                else if day == 4{
                    LocalNotifications.schedule(permissionStrategy: .askSystemPermissionIfNeeded) {
                        EveryWeek(forWeeks: 4, starting: .thisWeek)
                            .weekday(.wednesday)
                            .at(hour: hour, minute: minute)
                            .schedule(title: "Habit Reminder", body: body)
                    }
                }
                
                else if day == 5{
                    LocalNotifications.schedule(permissionStrategy: .askSystemPermissionIfNeeded) {
                        EveryWeek(forWeeks: 4, starting: .thisWeek)
                            .weekday(.thursday)
                            .at(hour: hour, minute: minute)
                            .schedule(title: "Habit Reminder", body: body)
                    }
                }
                
                else if day == 6{
                    LocalNotifications.schedule(permissionStrategy: .askSystemPermissionIfNeeded) {
                        EveryWeek(forWeeks: 4, starting: .thisWeek)
                            .weekday(.friday)
                            .at(hour: hour, minute: minute)
                            .schedule(title: "Habit Reminder", body: body)
                    }
                }
                
                else if day == 7{
                    LocalNotifications.schedule(permissionStrategy: .askSystemPermissionIfNeeded) {
                        EveryWeek(forWeeks: 4, starting: .thisWeek)
                            .weekday(.saturday)
                            .at(hour: hour, minute: minute)
                            .schedule(title: "Habit Reminder", body: body)
                    }
                }
            }
        }
        
