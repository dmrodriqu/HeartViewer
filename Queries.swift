//
//  Queries.swift
//  HeartViewer
//
//  Created by Dylan Rodriquez on 2/20/17.
//  Copyright © 2017 Dylan Rodriquez. All rights reserved.
//

import Foundation
import HealthKit

class Queries{
    
    let healthStore = HKHealthStore()
    
    
    
    func fetchHeartRateWithCompletionHandler(
        completionHandler:@escaping (Double?, NSError?)->()) {
        
        let calendar = NSCalendar.current
        let now = NSDate()
        let components = calendar.dateComponents([.year,.month,.day,.hour], from: now as Date)
        
        let startDate = calendar.date(from: components)
        
        let endDate = calendar.date(byAdding: .hour, value: 10, to: startDate!)
        
        let sampleType = HKObjectType.quantityType(forIdentifier:HKQuantityTypeIdentifier.heartRate)
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate!,
                                                    end: endDate, options: .strictEndDate)
        
        let query = HKStatisticsQuery(quantityType: sampleType!,
                                      quantitySamplePredicate: predicate,
                                      options: .discreteAverage) { query, result, error in
                                        var heartRate = 0.0
                                        if result == nil {
                                            completionHandler(nil, error as NSError?)
                                            return
                                        }
                                        if let quantity = result {
                                            let unit = HKUnit(from: "count/min")
                                            let heartQuantity = quantity.averageQuantity()
                                            let heartUnit = heartQuantity?.doubleValue(for: unit)
                                            if let final = heartUnit{
                                                heartRate = final
                                            }else{
                                                print("No Data")
                                            }
                                        }
                                        completionHandler(heartRate, error as NSError?)
        }
        
        healthStore.execute(query)
    }
    
    func fetchHeartSampleOberverQuery() -> () {
        let sampleType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)
        
        let calendar = NSCalendar.current
        let now = NSDate()
        let components = calendar.dateComponents([.year,.month,. day,.hour], from: now as Date)
        
        let startDate = calendar.date(from: components)
        
        let endDate = calendar.date(byAdding: .hour, value: 10, to: startDate!)
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate!,
                                                    end: endDate, options: .strictEndDate)
        
        let query = HKObserverQuery(sampleType: sampleType!,predicate: predicate){
            query, completionHandler, error in
            
            if error != nil {
                print("\(error)")
                return;
            }
            self.fetchHeartRateWithCompletionHandler(){
                results, error in
                if results != nil{
                    print ("HUEHUE")
                    let queryResult = String(describing: Int(results!))
                    print(queryResult)
                    defer {ViewController().heartRate = results!}
                    /*if ViewController().resultLabel != nil{
                        ViewController().updateLabel(value: queryResult)
                    }else{
                        ViewController().updateUI()
                        ViewController().updateLabel(value: queryResult)
                    }*/
                }
                
            }
            completionHandler()
        }
        healthStore.execute(query)
    }
    
    func setUpBackgroundDeliveryWithCompletionHandler(
        completionHandler:@escaping (Bool?, Error?)->()) {
        let objectType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)
        let frequency = HKUpdateFrequency.hourly
        healthStore.enableBackgroundDelivery(for: objectType!, frequency: frequency){success, error in
            if success != true {
                print("\(error)")
            }
        }
    }
}
