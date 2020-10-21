//
//  ViewController.swift
//  VirFitnessAppTester
//
//  Created by Lutfor on 9/22/20.
//

import UIKit
import SwiftUI
import CoreData
import HealthKit
import BackgroundTasks
import AuthenticationServices
import LocalAuthentication
import CryptoKit
import CoreData
import AVFoundation
import AVKit
//import BackgroundTasks

public var stepSpeed = 5
public var writeToHealhkitTimer: Timer?
public var flag = false
class ViewController: UIViewController {
    
    let healthStore = HKHealthStore()
    var numberOfMinute = Int.random(in: 0..<3)
    
    @IBOutlet weak var stepSpeedLabel: UILabel!
    @IBOutlet weak var speedSlider: UISlider!
    @IBOutlet weak var showStep: UILabel!
    @IBOutlet weak var minuteSpent: UILabel!
    var imageView:UIImageView!
    var stepDetials:[Journal]?
   // @IBOutlet weak var imageViewToggle: UIImageView!
   // @IBOutlet weak var ImageViewToggle2: UIImageView!
    
  
    let userLicenseAgreement  = """
    Your privacy is at the heart of our policies. We do not share or sell any of your personal data. Transparency and customer trust is our priority.
     We do not share any information with any third party.
     We log minimal information in an anonymised manner to show analytics and debug our services.
     We retain the logs for no more than 30 days.

    
     Collection Of Your Information
     Our app does not ask for any of your personal information (email, name, address, demographic details, etc.)
     We do not share any data with third parties.
     Traffic logs are aggregated/anonymized and are used for network management; not shared with third-parties.
     On-device performance logs. These logs are primarily used for debugging purposes & are retained strictly locally on device only. These are never shared over the network. Local device logs stay on device and are never reported.
    """
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    class FooViewController: UIViewController {
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            print("viewDidLoad")
        }
        
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
        }

    }
    
   // @IBAction func showJournal(_ sender: Any) {
    //    guard let vc = //storyboard?.instantiateViewController(identifier: //"journal_vc") as? JournalViewController else {
   //        return
   //     }
   //     present(vc, animated: true)
   // }
    
    func displayLicenAgreement(message:String){
        
        //create alert
        let alert = UIAlertController(title: "License Agreement", message: message, preferredStyle: .alert)
        
        //create Decline button
        let declineAction = UIAlertAction(title: "Decline" , style: .destructive){ (action) -> Void in
            //DECLINE LOGIC GOES HERE
            AppDelegate().hasAlreadyLaunched = false
            exit(0);
            
        }
        
        //create Accept button
        let acceptAction = UIAlertAction(title: "Accept", style: .default) { (action) -> Void in
            
            //ACCEPT LOGIC GOES HERE
        }
        
        //add task to tableview buttons
        alert.addAction(declineAction)
        alert.addAction(acceptAction)
        
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func authorize(_ sender: Any) {
        if(!appDelegate.hasAlreadyLaunched){
            //set hasAlreadyLaunched to false
            appDelegate.sethasAlreadyLaunched()
            //display user agreement license
            displayLicenAgreement(message: self.userLicenseAgreement)
        }
        
        authorizehealthkit()
    }
    
    @IBAction func speedSliderAction(_ sender: Any) {
        stepSpeed = Int(speedSlider.value)
        stepSpeedLabel.text = String(stepSpeed)
        //print("slider value \(speedSlider.value)")
    }
    
    
    @IBAction func syncToggle(_ sender: UISwitch) {
        if(imageView != nil && !imageView.isHidden)
        {
            imageView.removeFromSuperview()
        }
        if sender.isOn {
            let runningslow = UIImage.gifImageWithName("ezgif.com-gif-maker_300")
          //  let runningslow1 = UIImage.gifImageWithURL("https://www.animatedimages.org/data/media/169/animated-running-image-0041.gif")
            imageView = UIImageView(image: runningslow)
            imageView.frame = CGRect(x: 20.0, y: 390.0, width: self.view.frame.size.width - 300, height: 100.0)
            view.addSubview(imageView)
            
            flag = true
            //  writeToHealhkitTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(writeDataHealthkit), userInfo: nil, repeats: true)
            print("toggle on")
            self.writeDataHealthkit()
            // Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.writeDataHealthkit), userInfo: nil, repeats: true)
            
        }
        else{
         //   imageViewToggle.image = UIImage(named: "standing")
         //   self.imageViewToggle.image()
         //   let runningslow = UIImage.gifImageWithURL("https://www.animatedimages.org/data/media/169/animated-running-image-0082.gif")
            let runningslow = UIImage.gifImageWithName("ezgif.com-gif-maker_stand")
            imageView = UIImageView(image: runningslow)
            imageView.frame = CGRect(x: 20.0, y: 390.0, width: self.view.frame.size.width - 300, height: 100.0)
            view.addSubview(imageView)

            writeToHealhkitTimer?.invalidate()
            writeToHealhkitTimer = nil
            print("toggle off")
            flag = false
        }
        
    }
    
    
    func authorizehealthkit(){
        let readtypes = Set([HKObjectType.quantityType(forIdentifier: .stepCount)!])
        let sharetypes = Set([HKObjectType.quantityType(forIdentifier: .stepCount)!])
        
        healthStore.requestAuthorization(toShare: sharetypes, read: readtypes) { (succes, error) in
            if (succes){
                print("health app permission granted")
                //     self.writeDataHealthkit()
                //    self.lateststepcount()
            }
        }
        
    }
    
    @objc func writeDataHealthkit(){
        
        let randomNum = Int.random(in: 5..<10)
        //  let randomNum = Int.random(in: 61..<90)
        minuteSpent.text = String(randomNum/60)
        print("random second wait: \(randomNum)")
        writeToHealhkitTimer = Timer.scheduledTimer(timeInterval: TimeInterval(randomNum),target: self, selector: #selector(writeDataHealthkit), userInfo: nil, repeats: false)
        guard let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            fatalError("Step Count Type is no longer available in HealthKit")
        }
        let upperspeed = stepSpeed + 2
        let lowerspeed = stepSpeed - 2
        // let SpeedCount = Int.random(in: lowerspeed..<upperspeed)
        let SpeedCount = Int(arc4random_uniform(UInt32((upperspeed - lowerspeed) + 1))) + lowerspeed
        //let numberOfMinute = Int.random(in: 0..<3)
        // let numberOfStepCount = SpeedCount * randomNum
        // let numberOfStepCount = SpeedCount * randomNum/60
        let numberOfStepCount = 5 
        print("stepspeed: \(SpeedCount)")
        print("numberOfStepCount: \(numberOfStepCount)")
        showStep.text = String(numberOfStepCount)
        print("time: \(Date())")
        
        let stepsCountUnit:HKUnit = HKUnit.count()
        let stepsCountQuantity = HKQuantity(unit: stepsCountUnit,doubleValue: Double(numberOfStepCount))
        let stepsCountSample = HKQuantitySample(type: stepCountType,quantity: stepsCountQuantity,start: Date(),end: Date())
        HKHealthStore().save(stepsCountSample) { (success, error) in
            
            if let error = error {
                print("Error Saving Steps Count Sample: \(error.localizedDescription)")
            } else {
                print("Successfully saved Steps Count Sample")
            }
        }
        self.saveCoreDate()
        self.fetchCoreData()
        fetchAllSteps()
        //self.deleteCoreData()
        
        self.lateststepcount()
        // self?.writeDataHealthkit()
        
    }
    
    func saveCoreDate(){
        let newStep = Journal (context: self.context)
        newStep.entry_time = Date()
        newStep.step_count = 5
        newStep.step_distance = 10
        
        do {
            try self.context.save()
        } catch  {
            print("can not save to core data")
        }
    }
    
    func fetchAllSteps() {
        var pp: [Journal] = []
        do {
            let r = NSFetchRequest<NSFetchRequestResult>(entityName: "Journal")
            let f = try context.fetch(r)
            pp = f as! [Journal]
        } catch let error as NSError {
            print("Grabbing all step \(error)")
        }
        print(pp)
        for p: Journal in pp {
            print(" >> \(p.step_count) \(p.step_distance)")
        }
    }
    
    
    
    func fetchCoreData(){
        var request = NSFetchRequest<NSFetchRequestResult>()
        request = Journal.fetchRequest()
        request.returnsObjectsAsFaults = false
        do {
            let stepdetails = try context.fetch(request)
            print("stepdetails")
            print(stepdetails)
        } catch {
            print("can not fetch data from core data")
        }
        
    }
    
    func deleteCoreData(){
        let stepsToRemove = self.stepDetials![0]
        self.context.delete(stepsToRemove)
        
        do {
            try self.context.save()
        } catch {
            print("can not save after delete")
        }
    }
    
    
    func lateststepcount(){
        guard let sampletype = HKObjectType.quantityType(forIdentifier: .stepCount) else{
            return
        }
        let startOfDay = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: Date(), options: .strictEndDate)
        var interval = DateComponents()
        interval.day = 1
        let query = HKStatisticsCollectionQuery(quantityType: sampletype, quantitySamplePredicate: predicate, options: [.cumulativeSum], anchorDate: startOfDay, intervalComponents: interval)
        query.initialResultsHandler = {
            query,result, error in
            if let myresult = result {
                myresult.enumerateStatistics(from: startOfDay, to: Date()) {(statistic, value) in
                    if let count = statistic.sumQuantity(){
                        let val = count.doubleValue(for: HKUnit.count())
                        print("total \(val)")
                    }
                    
                }
                
            }
        }
        healthStore.execute(query)
    }
    
}

