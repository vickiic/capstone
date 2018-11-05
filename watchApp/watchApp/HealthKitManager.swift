//
//  HealthKitStore.swift
//  watchApp
//
//  Created by Matthew Mitchell on 11/2/18.
//  Copyright © 2018 Calvin Wang. All rights reserved.
//

import Foundation
import HealthKit

class HealthKitManager {
    
    public static var sharedInstance:HealthKitManager? = nil
    public let healthStore:HKHealthStore?
    
    private static let heartRate = HKObjectType.quantityType(forIdentifier: .heartRate)
    
    private enum HealthStoreErrors : Error {
        case noHealthDataFound
        case noAgeFound
        case noSexEntered
    }
    
    private enum HealthkitSetupError: Error {
        case notAvailableOnDevice
        case dataTypeNotAvailable
    }
    
    public func isHealthKitAvailable() -> Bool {
        print("Made it to isHealthKitAvail")
        return HKHealthStore.isHealthDataAvailable()
    }
    
    public static func authorizeHealthKit(completion: @escaping (Bool, Error?) -> Void) {
        
        print("Made it to authorizeHealthKit")
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, HealthkitSetupError.notAvailableOnDevice)
            return
        }
        
        guard let currHeartRate = heartRate else {
            completion(false, HealthkitSetupError.dataTypeNotAvailable)
            return
        }
        
        print("Made it to the authorize function")
        let writeTypes: Set<HKSampleType> = [currHeartRate]
        let readTypes: Set<HKObjectType> = [currHeartRate]
        
        HKHealthStore().requestAuthorization(toShare: writeTypes, read: readTypes, completion: { (success, error) -> Void in
            completion(success, error)
        })
    }
    
    private init() {
        print("Made it to initialization")
        HealthKitManager.authorizeHealthKit { (authorized, error) in
            guard authorized else {
                let baseMessage = "HealthKit Authorization Failed"
                if let error = error {
                    print("\(baseMessage). Reason: \(error.localizedDescription)")
                } else {
                    print(baseMessage)
                }
                return
            }
            print("HealthKit Successfully Authorized.")
        }
        
        if(HKHealthStore.isHealthDataAvailable()) {
            healthStore = HKHealthStore()
            print("data found")
        } else {
            print("no data")
            healthStore = nil
        }
    }
    
    public static func getInstance() -> HealthKitManager {
        print("Made it to getInstance")
        if sharedInstance == nil {
            print("it was nil")
            sharedInstance = HealthKitManager()
        }
        return sharedInstance!
    }
}
