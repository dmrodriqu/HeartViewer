//
//  HealthManager.swift
//  HeartViewer
//
//  Created by Dylan Rodriquez on 2/20/17.
//  Copyright © 2017 Dylan Rodriquez. All rights reserved.
//

import Foundation
import HealthKit

class HealthManager {
    // set properties on read write. immutable vars
    
    let healthDataItemsToRead: Set<HKObjectType> = [
        HKObjectType.quantityType(forIdentifier:HKQuantityTypeIdentifier.heartRate)!,
        HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!,
        HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.basalEnergyBurned)!,
        HKObjectType.workoutType()
    ]
    
    let healthDataItemsToWrite: Set<HKSampleType> = [
    ]
    

    // function for authorization of health data
    func getHealthAuthorization(_ completion: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        // check if health data is available first
        guard HKHealthStore.isHealthDataAvailable() else {
            // throw error if not
            let error = NSError(domain: "com.dmr.HeartViewer", code: 2, userInfo: [NSLocalizedDescriptionKey: "Health data is not available on this device."])
            
            completion(false, error)
            // stop if it isnt
            return
        }
        // if health data is available:
        // Get authorization to access the data
        HKHealthStore().requestAuthorization(toShare: healthDataItemsToWrite, read: healthDataItemsToRead) { (success, error) -> Void in
            completion(success, error as NSError?)
        }
    }
}
