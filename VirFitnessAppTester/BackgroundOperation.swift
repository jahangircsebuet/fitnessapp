//
//  BackgroundOperation.swift
//  HealthKitTest
//
//  Created by Bryton Shoffner on 5/11/20.
//  Copyright © 2020 Bryton Shoffner. All rights reserved.
//

import Foundation
import HealthKit

class BackgroundOperation {
    var completionHandler: (() -> ())? {
        didSet {
            print("Completion handler set")
        }
    }
    var isCancelled: Bool?
    var healthStore: HKHealthStore?
    
    init(withHealthStore store: HKHealthStore) {
        print("initializing background operation")
        self.healthStore = store
    }
    
    func start() {
        print("Starting background operation")
        self.isCancelled = false
        self.addStepsToHealthKit(steps: 60)
    }
    
    func cancel() {
        print("Cancelling background operation")
        self.isCancelled = true
    }
    
    private func addStepsToHealthKit(steps: Double) {
        print("adding steps to healthkit")
        // Create HKObjectType so we know what HealthKit type to read.
        let stepType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
        
        // Create a count HKUnit to measure steps. See more https://developer.apple.com/documentation/healthkit/hkunit
        let stepUnit = HKUnit.count()
        
        // Create an HKQuantity to associate with the step type.
        let stepQuantity = HKQuantity(unit: stepUnit, doubleValue: steps)
        
        // Create a sample using the type and quantity. The interval when this happens is right now and instant.
        let sample = HKQuantitySample(type: stepType, quantity: stepQuantity, start: Date(), end: Date())
        
        // Attempt to save this sample in the HK store.
        self.healthStore?.save(sample, withCompletion: { (success, error) in
            if (error != nil) {
                NSLog("Error occurred saving step data.")
            }
        })
    }
}
