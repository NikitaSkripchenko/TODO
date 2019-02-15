//
//  CheckListItem.swift
//  Checklists
//
//  Created by Nikita Skrypchenko  on 2/6/19.
//  Copyright © 2019 Nikita Skrypchenko . All rights reserved.
//

import Foundation
import UserNotifications
class ChecklistItem: NSObject, Codable{
    var text = ""
    var checked = false
    var dueDate = Date()
    var itemId = -1 //id is special keyword in obj-c
    var shouldRemind = false
    
    override init(){
        super.init()
        itemId = DataModel.nextChecklistItemId()
    }
    
    deinit {
        removeNotification()
    }
    
    func toggleChecked(){
        checked = !checked
    }
    
    func removeNotification(){
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["\(itemId)"])
        print("Deleted:  \(itemId)")
    }
    
    func scheduleNotification(){
        removeNotification()
        if shouldRemind && dueDate > Date(){
            let content = UNMutableNotificationContent()
            content.title = "Reminder: "
            content.body = text
            content.sound = UNNotificationSound.default
            let calendar = Calendar(identifier: .gregorian)
            let components = calendar.dateComponents(
                [.year, .month, .day, .hour, .minute],
                from: dueDate)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            let request = UNNotificationRequest(identifier: "\(itemId)", content: content, trigger: trigger)
            let center = UNUserNotificationCenter.current()
            
            center.add(request)
            print("Scheduled: \(request) for itemID: \(itemId)")
        }
    }
   
}
