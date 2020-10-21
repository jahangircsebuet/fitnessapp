import UIKit
import BackgroundTasks

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print("appdelegate")
        ViewController().authorizehealthkit()
        registerBackgroundTaks()
      //  registerLocalNotification()
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("applicationDidEnterBackground")
        cancelAllPandingBGTask()
        scheduleAppRefresh()
        checkBackgroundRefreshStatus()
       // scheduleImageFetcher()
    }
 
    //MARK: Regiater BackGround Tasks
    private func registerBackgroundTaks() {
        print("registerBackgroundTaks")
        print("New status: \(UIApplication.shared.backgroundRefreshStatus)")
        let backgroundAppRefreshTaskSchedulerIdentifier = "com.example.refresh"
      //  let backgroundProcessingTaskSchedulerIdentifier = "com.example.fooBackgroundProcessingIdentifier"
        
        BGTaskScheduler.shared.register(forTaskWithIdentifier: backgroundAppRefreshTaskSchedulerIdentifier, using: nil) { task in
            //This task is cast with processing request (BGAppRefreshTask)
          //  self.scheduleLocalNotification()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
              print("Time remaining: \(UIApplication.shared.backgroundTimeRemaining)")
            }
            print("BackgroundAppRefreshTaskScheduler is executed NOW!")
            self.handleAppRefreshTask(task: task as! BGAppRefreshTask)
        }
    }
}

//MARK:- BGTask Helper
extension AppDelegate {
    
    func cancelAllPandingBGTask() {
        print("cancelAllPandingBGTask")
        BGTaskScheduler.shared.cancelAllTaskRequests()
    }

    
    func scheduleAppRefresh() {
        print("scheduleAppRefresh")
        print("New status: \(UIApplication.shared.backgroundRefreshStatus)")
        let request = BGAppRefreshTaskRequest(identifier: "com.example.refresh")
      //  request.earliestBeginDate = Date(timeIntervalSinceNow: 60) // App Refresh after 2 minute.
        //Note :: EarliestBeginDate should not be set to too far into the future.
        do {
            //print("BGTaskScheduler.shared.submit(request)")
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule app refresh: \(error)")
        }
    }
    
    func handleAppRefreshTask(task: BGAppRefreshTask) {
        scheduleAppRefresh()
        print("New status: \(UIApplication.shared.backgroundRefreshStatus)")
        print("handleAppRefreshTask")
        task.expirationHandler = {
            print("expirationhandler")
            task.setTaskCompleted(success: false)
        }
        task.setTaskCompleted(success: true)
    }
    
  //  func handleAppRefreshTask(task: BGAppRefreshTask) {
  //      print("Refresh called")
   //     scheduleAppRefresh()
  //      let operationQueue = OperationQueue()
  //      let refreshOperation = BlockOperation {
         //   let refreshManager = BackgroundRefresh()
  //         // refreshManager.updateInfoForServer()
  //          print("Refresh executed")
  //      }
  //      task.expirationHandler = { refreshOperation.cancel() }
   //     refreshOperation.completionBlock = {
    //        task.setTaskCompleted(success: !refreshOperation.isCancelled)
   //     }
    //    operationQueue.addOperation(refreshOperation)
        
        //ViewController().writeDataHealthkitBackground()
    //    print(Date())
    //}
    func checkBackgroundRefreshStatus() {
      switch UIApplication.shared.backgroundRefreshStatus {
      case .available:
        print("Background fetch is enabled")
      case .denied:
        print("Background fetch is explicitly disbaled")
        
        // Redirect user to Settings page only once; Respect user's choice is important
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
      case .restricted:
        // Should not redirect user to Settings since he / she cannot toggle the settings
        print("Background fetch is restricted, e.g. under parental control")
      default:
        print("Unknown property")
      }
    }

}

