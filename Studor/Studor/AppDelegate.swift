//
//  AppDelegate.swift
//  Studor
//
//  Created by James Ahrens on 2/1/19.
//  Copyright © 2019 James Ahrens. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        let center = UNUserNotificationCenter.current()
        let category = UNNotificationCategory(identifier: "Note", actions: [], intentIdentifiers: [], options: [])
        center.setNotificationCategories([category])
        
        let options: UNAuthorizationOptions = [.alert, .sound]
        center.requestAuthorization(options: options, completionHandler: {    (granted, error) in    if !granted {        print("Bad things have happened")    }})
        
        center.delegate = self
        
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print(notification.request.content.body)
        completionHandler([.alert])
    }
}

