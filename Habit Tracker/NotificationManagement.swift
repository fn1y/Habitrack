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

//this is just for debug purposes, removes all scheduled and delivered notifs
func handleNotifications(){
    let center = UNUserNotificationCenter.current()
    center.removeAllDeliveredNotifications()    // to remove all delivered notifications
    center.removeAllPendingNotificationRequests()   // to remove all pending notifications
}

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
