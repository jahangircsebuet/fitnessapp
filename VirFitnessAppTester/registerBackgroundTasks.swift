//
//  registerBackgroundTasks.swift
//  VirFitnessAppTester
//
//  Created by Lutfor on 9/28/20.
//

import Foundation
import BackgroundTasks

class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
 
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
   // Register Background task here
   registerBackgroundTasks()
   return true
  }
 
  func registerBackgroundTasks() {
    // Declared at the "Permitted background task scheduler identifiers" in info.plist
    let backgroundAppRefreshTaskSchedulerIdentifier = "com.example.fooBackgroundAppRefreshIdentifier"
    let backgroundProcessingTaskSchedulerIdentifier = "com.example.fooBackgroundProcessingIdentifier"

    // Use the identifier which represents your needs
    BGTaskScheduler.shared.register(forTaskWithIdentifier: backgroundAppRefreshTaskSchedulerIdentifier, using: nil) { (task) in
       print("BackgroundAppRefreshTaskScheduler is executed NOW!")
       print("Background time remaining: \(UIApplication.shared.backgroundTimeRemaining)")
       task.expirationHandler = {
         task.setTaskCompleted(success: false)
       }

       // Do some data fetching and call setTaskCompleted(success:) asap!
       let isFetchingSuccess = true
       task.setTaskCompleted(success: isFetchingSuccess)
     }
   }
}
