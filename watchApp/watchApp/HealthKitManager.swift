//
//  HealthKitStore.swift
//  watchApp
//
//  Created by Matthew Mitchell on 11/2/18.
//  Updated by Calvin Wang on 11/6/18.
//  Copyright © 2018 Calvin Wang. All rights reserved.
//

import Foundation
import HealthKit

class HealthKitManager {
    
    public static var sharedInstance:HealthKitManager? = nil
    public let healthStore:HKHealthStore!
  
    init() {
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
        
        writeableHKQuantityTypes = [HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!]
        readableHKQuantityTypes = [HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!]
        
        healthStore?.requestAuthorization(toShare: writeableHKQuantityTypes,
                                          read: readableHKQuantityTypes,
                                          completion: { (success, error) -> Void in
                                            if success {
                                              print("Successful authorization.")
                                              // STEP 9.1: read gender data (see below)
                                              self.readGenderType()
                                            } else {
                                              print(error.debugDescription)
                                            }
        })
        
      } else {
        print("no data")
        healthStore = nil
        readableHKQuantityTypes = nil
        writeableHKQuantityTypes = nil
      }
    }
    
    private static let heartRate = HKObjectType.quantityType(forIdentifier: .heartRate)
    
    let genderCharacteristic = HKCharacteristicType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.biologicalSex)
    
    let readableHKQuantityTypes: Set<HKQuantityType>?
    let writeableHKQuantityTypes: Set<HKQuantityType>?
    
    func readGenderType() -> Void {
        do {
            let genderType = try self.healthStore?.biologicalSex()
            
            if genderType?.biologicalSex == .female {
                print("Gender is female.")
            }
            else if genderType?.biologicalSex == .male {
                print("Gender is male.")
            }
            else {
                print("Gender is unspecified.")
            }
        }
        catch {
            print("Error looking up gender.")
        }
    }
    
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

    func writeHeartRateData( heartRate: Int ) -> Void {
      
        print("writing heart rate data")
        
        // STEP 8.1: "Count units are used to represent raw scalar values. They are often used to represent the number of times an event occurs"
        let heartRateCountUnit = HKUnit.count()
        // STEP 8.2: "HealthKit uses quantity objects to store numerical data. When you create a quantity, you provide both the quantity’s value and unit."
        // beats per minute = heart beats / minute
        let beatsPerMinuteQuantity = HKQuantity(unit: heartRateCountUnit.unitDivided(by: HKUnit.minute()), doubleValue: Double(heartRate))
        // STEP 8.3: "HealthKit uses quantity types to create samples that store a numerical value. Use quantity type instances to create quantity samples that you can save in the HealthKit store."
        // Short-hand for HKQuantityTypeIdentifier.heartRate
        let beatsPerMinuteType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        // STEP 8.4: "you can use a quantity sample to record ... the user's current heart rate..."
        let heartRateSampleData = HKQuantitySample(type: beatsPerMinuteType, quantity: beatsPerMinuteQuantity, start: Date(), end: Date())
        
        healthStore?.save([heartRateSampleData]) { (success: Bool, error: Error?) in
            print("Heart rate \(heartRate) saved.")
        }
    }
    
    func readHeartRateData() -> Void {
      
        print("reading heart rate data")
        
        // STEP 9.1: just as in STEP 6, we're telling the `HealthKitStore`
        // that we're interested in reading heart rate data
        let heartRateType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!
        
        // STEP 9.2: define a query for "recent" heart rate data;
        // in pseudo-SQL, this would look like:
        //
        // SELECT bpm FROM HealthKitStore WHERE qtyTypeID = '.heartRate';
        let query = HKAnchoredObjectQuery(type: heartRateType, predicate: nil, anchor: nil, limit: HKObjectQueryNoLimit) {
            (query, samplesOrNil, deletedObjectsOrNil, newAnchor, errorOrNil) in
            
            if let samples = samplesOrNil {
                
                for heartRateSamples in samples {
                    print(heartRateSamples)
                }
                
            } else {
                print("No heart rate sample available.")
            }
            
        }
        
        // STEP 9.3: execute the query for heart rate data
        healthStore?.execute(query)
    }
    
    public static func getInstance() -> HealthKitManager {
        print("Made it to getInstance")
        if sharedInstance == nil {
            print("it was nil")
            sharedInstance = HealthKitManager()
        }
        return sharedInstance!
    }
  
//  public func subscribeToHeartBeatChanges() {
//    
//    // Creating the sample for the heart rate
//    guard let sampleType: HKSampleType =
//      HKObjectType.quantityType(forIdentifier: .heartRate) else {
//        return
//    }
//    
//    /// Creating an observer, so updates are received whenever HealthKit’s
//    // heart rate data changes.
//    self.heartRateQuery = HKObserverQuery.init(
//      sampleType: sampleType,
//      predicate: nil) { [weak self] _, _, error in
//        guard error == nil else {
//          log.warn(error!)
//          return
//        }
//        
//        /// When the completion is called, an other query is executed
//        /// to fetch the latest heart rate
//        self.fetchLatestHeartRateSample(completion: { sample in
//          guard let sample = sample else {
//            return
//          }
//          
//          /// The completion in called on a background thread, but we
//          /// need to update the UI on the main.
//          DispatchQueue.main.async {
//            
//            /// Converting the heart rate to bpm
//            let heartRateUnit = HKUnit(from: "count/min")
//            let heartRate = sample
//              .quantity
//              .doubleValue(for: heartRateUnit)
//            
//            /// Updating the UI with the retrieved value
//            self?.heartRateLabel.setText("\(Int(heartRate))")
//          }
//        })
//    }
//  }
//  
//  public func fetchLatestHeartRateSample(
//    completion: @escaping (_ sample: HKQuantitySample?) -> Void) {
//    
//    /// Create sample type for the heart rate
//    guard let sampleType = HKObjectType
//      .quantityType(forIdentifier: .heartRate) else {
//        completion(nil)
//        return
//    }
//    
//    /// Predicate for specifiying start and end dates for the query
//    let predicate = HKQuery
//      .predicateForSamples(
//        withStart: Date.distantPast,
//        end: Date(),
//        options: .strictEndDate)
//    
//    /// Set sorting by date.
//    let sortDescriptor = NSSortDescriptor(
//      key: HKSampleSortIdentifierStartDate,
//      ascending: false)
//    
//    /// Create the query
//    let query = HKSampleQuery(
//      sampleType: sampleType,
//      predicate: predicate,
//      limit: Int(HKObjectQueryNoLimit),
//      sortDescriptors: [sortDescriptor]) { (_, results, error) in
//        
//        guard error == nil else {
//          print("Error: \(error!.localizedDescription)")
//          return
//        }
//        
//        completion(results?[0] as? HKQuantitySample)
//    }
//    
//    self.healthStore.execute(query)
//  }
}
