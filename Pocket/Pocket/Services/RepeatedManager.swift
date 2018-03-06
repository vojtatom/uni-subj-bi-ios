//
//  RepeatedManager.swift
//  Pocket
//
//  Created by Vojtěch Tomas on 11/02/2018.
//  Copyright © 2018 Vojtěch Tomas. All rights reserved.
//

import Foundation
import CoreData
import UserNotifications

class RepeatedManager {
    static let shared = RepeatedManager()
    
    private init() {}
    
    func update(context: NSManagedObjectContext) {
        guard let repeated = DataManager.shared.loadRepeated(onlyActive: true, context: context) else { return }
        let today = Date()
        for task in repeated {
            if checkNeedsUpdate(repeated: task, today: today) {
                manageTransactions(task: task, today: today, context: context)
            }
        }
    }
    
    private func checkNeedsUpdate(repeated: Repeated, today : Date) -> Bool {
        guard let from = repeated.from else { return false }
        if from > today { return false }
        guard let updated = repeated.lastUpdated else { return true }
        
        if repeated.monthly {
            let diff = Calendar.current.dateComponents([.month], from: updated, to: today).month ?? 0
            return diff >= repeated.period
        } else {
            let diff = Calendar.current.dateComponents([.day], from: updated, to: today).day ?? 0
            return diff >= repeated.period
        }
    }
    
    private func manageTransactions(task: Repeated, today: Date, context: NSManagedObjectContext){
        repeat {
            let transaction = Transaction(context: context)
            transaction.name = task.name ?? Placeholders.none.rawValue
            transaction.amount = task.amount
            transaction.isExpense = task.isExpense
            transaction.repeated = task
            if let date = task.lastUpdated {
                task.lastUpdated = Calendar.current.date(byAdding: task.monthly ? .month : .day, value: Int(task.period), to: date)
                transaction.date = task.lastUpdated
            } else if let date = task.from {
                task.lastUpdated = task.from
                transaction.date = date
            } else {
                task.lastUpdated = today
                transaction.date = today
            }
            
        } while checkNeedsUpdate(repeated: task, today: today)
    }
    
    func setupNotificationForFirstRepeated(context: NSManagedObjectContext){
        guard let repeated = DataManager.shared.loadRepeated(onlyActive: true, context: context) else { return }
        var updateTime : Date? = nil
        var updateTask : Repeated? = nil
        
        for task in repeated {
            if let toBeUpdatedAt = getDateNextUpdate(task: task) {
                if let ut = updateTime {
                    if ut > toBeUpdatedAt {
                        updateTime = toBeUpdatedAt
                        updateTask = task
                    }
                } else {
                    updateTime = toBeUpdatedAt
                    updateTask = task
                }
            }
        }
        
        if updateTask == nil {
            let notification = UNMutableNotificationContent()
            notification.title = "You have no planned transactions."
            notification.body = "You have no planned transactions. Come again soon!"
            addNotification(identifier: "reminder", notification: notification, interval: 5)
            return
        }
        
        if let ut = updateTime, let task = updateTask {
            var components = Time.calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: ut)
            components.hour = 9
            components.minute = 30
            components.second = 0
            if let notificationTime = Time.calendar.date(from: components) {
                let notification = UNMutableNotificationContent()
                notification.title = "New Transaction"
                notification.subtitle = task.name ?? "Unknown"
                notification.body = (task.isExpense ? "You account has been accounted for " : "Your account gained ") + String(task.amount) + " " + BaseViewModel.currency
                addNotification(identifier: "notification", notification: notification, interval: notificationTime.timeIntervalSinceNow)
                
                let reminder = UNMutableNotificationContent()
                reminder.title = "Your next transaction..."
                reminder.subtitle = task.name ?? "Unknown"
                reminder.body = "Next planned transaction is scheduled on " + Time.dateFormatter.string(from: notificationTime) + ", it's going to be " + (task.isExpense ? "-" : "") + String(task.amount) + ". We will remind you when it happens!"
                addNotification(identifier: "reminder", notification: reminder, interval: 5)
            }
        }
    }
    
    private func getDateNextUpdate(task: Repeated) -> Date? {
        if let updateTime = task.lastUpdated {
            let date = Calendar.current.date(byAdding: task.monthly ? .month : .day, value: Int(task.period), to: updateTime)
            return date
        } else if let updateTime = task.from {
            return updateTime
        }
        return nil
    }
    
    private func addNotification(identifier: String, notification: UNMutableNotificationContent, interval: TimeInterval){
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: notification, trigger: notificationTrigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
