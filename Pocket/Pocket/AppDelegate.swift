//
//  AppDelegate.swift
//  Pocket
//
//  Created by Vojtěch Tomas on 08/02/2018.
//  Copyright © 2018 Vojtěch Tomas. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        RepeatedManager.shared.update(context: self.persistentContainer.viewContext)
        
        UITabBar.appearance().tintColor = .red
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let overviewController = UINavigationController(rootViewController: OverviewViewController())
        overviewController.tabBarItem.title = "Overview"
        overviewController.tabBarItem.image = UIImage(named: "overview")
        
        let transactionController = UINavigationController(rootViewController: TransactionViewController(viewModel: TransactionViewModel(monthWithDate: Date())))
        transactionController.tabBarItem.title = "Transactions"
        transactionController.tabBarItem.image = UIImage(named: "transactions")
        
        let repeatedController = UINavigationController(rootViewController: RepeatedViewController(viewModel: RepeatedViewModel()))
        repeatedController.tabBarItem.title = "Repeated"
        repeatedController.tabBarItem.image = UIImage(named: "repeated")
        
        let settingsController = UINavigationController(rootViewController: SettingsViewController())
        settingsController.tabBarItem.title = "Settings"
        settingsController.tabBarItem.image = UIImage(named: "settings")
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [overviewController, transactionController, repeatedController, settingsController]
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        self.saveContext()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        RepeatedManager.shared.setupNotificationForFirstRepeated(context: self.persistentContainer.viewContext)
        self.saveContext()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
       
    }

    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }

    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Pocket")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                print("context saved")
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

