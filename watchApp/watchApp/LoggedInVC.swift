//
//  LoggedInVC.swift
//  watchApp
//
//  Created by vchen on 11/26/18.
//  Copyright © 2018 Calvin Wang. All rights reserved.
//

import UIKit
import WatchConnectivity
import FirebaseAuth
import HealthKit

class LoggedInVC: UIViewController, WCSessionDelegate {
  
  @IBOutlet weak var beatsPerMinuteLabel: UILabel!
  
  let healthKitInterface = HealthKitManager()
  private var heartRateQuery:HKObserverQuery?
  let dm: DeviceManager = DeviceManager.getSharedInstance() // possibly create a new session?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.subscribeToHeartBeatChanges()
  }

  public func sessionDidDeactivate(_ session: WCSession) {
    // Code
  }
  public func sessionDidBecomeInactive(_ session: WCSession) {
    // Code
  }
  public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    // Dummy Implementation
  }
  
  // if WCSession is supported then create a default session
  fileprivate let session: WCSession? = WCSession.isSupported() ? WCSession.default : nil
  
  // activate the optional session?
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    session?.delegate = self
    session?.activate()
  }

  func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {

    DispatchQueue.main.async {
      print("Yes")
      self.clickStatus.text = "Watch Click"
    }
  }

  @IBOutlet weak var clickStatus: UILabel!

  @IBAction func click(_ sender: Any) {
    self.clickStatus.text = "Phone Click"
    print("clicked on Phone")
  }

  @IBAction func logoutTapped(_ sender: Any) {
      do {
          try Auth.auth().signOut()
          dismiss(animated: true, completion:nil)
      } catch {
          print("There was a problem logging out")
      }
    }

  @IBAction func sendHeartRateData(_ sender: Any) {
      dm.writeHeartRateData(uid: Api.uid, heartRate: "200")
  }
  
  public func subscribeToHeartBeatChanges() {
    
    // Creating the sample for the heart rate
    guard let sampleType: HKSampleType =
      HKObjectType.quantityType(forIdentifier: .heartRate) else {
        return
    }
    
    /// Creating an observer, so updates are received whenever HealthKit’s
    // heart rate data changes.
    print("subscribeToHeartBeatChanges fxn")
//    let tempQuery = HKObserverQuery.init(
//      sampleType: sampleType,
//      predicate: nil) { [weak self] _, _, error in
//        guard error == nil else {
//          print(error!)
//          return
//        }
//
//        print("finna fetch")
//        /// When the completion is called, an other query is executed
//        /// to fetch the latest heart rate
//        self?.fetchLatestHeartRateSample(completion: { sample in
//          guard let sample = sample else {
//            return
//          }
//
//          print("fetching")
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
//            print("\(Int(heartRate))")
//            self?.beatsPerMinuteLabel.text = "\(Int(heartRate))"
//
//          }
//        })
//    }
    
    let tempQuery = HKObserverQuery(sampleType: sampleType, predicate: nil) { tempQuery, completionHandler, error in
      print("finna fetch")
      /// When the completion is called, an other query is executed
      /// to fetch the latest heart rate
      self.fetchLatestHeartRateSample(completion: { sample in
        guard let sample = sample else {
          return
        }
        
        print("fetching")
        
        /// The completion in called on a background thread, but we
        /// need to update the UI on the main.
        DispatchQueue.main.async {
          
          /// Converting the heart rate to bpm
          let heartRateUnit = HKUnit(from: "count/min")
          let heartRate = sample
            .quantity
            .doubleValue(for: heartRateUnit)
          
          /// Updating the UI with the retrieved value
          print("\(Int(heartRate))")
          self.beatsPerMinuteLabel.text = "\(Int(heartRate))"
          self.dm.writeHeartRateData(uid: Api.uid, heartRate: "\(Int(heartRate))")
        }
      })
    }
    
    print("after observer initialization")
    self.healthKitInterface.healthStore.execute(tempQuery)
    if let query = heartRateQuery {self.healthKitInterface.healthStore.execute(query)
    
    // Background delivery for syncup when app is open in the background and we are still able to make queries and send to db 
    self.healthKitInterface.healthStore.enableBackgroundDelivery(for: sampleType, frequency: .immediate) { (true, nil) in
      self.healthKitInterface.healthStore.execute(tempQuery)
      print("error with background delivery in query")
    }
  }
}
  
  public func fetchLatestHeartRateSample(
    completion: @escaping (_ sample: HKQuantitySample?) -> Void) {
    
    /// Create sample type for the heart rate
    guard let sampleType = HKObjectType
      .quantityType(forIdentifier: .heartRate) else {
        completion(nil)
        return
    }
    
    /// Predicate for specifiying start and end dates for the query
    let predicate = HKQuery
      .predicateForSamples(
        withStart: Date.distantPast,
        end: Date(),
        options: .strictEndDate)
    
    /// Set sorting by date.
    let sortDescriptor = NSSortDescriptor(
      key: HKSampleSortIdentifierStartDate,
      ascending: false)
    
    /// Create the query
    let query = HKSampleQuery(
      sampleType: sampleType,
      predicate: predicate,
      limit: Int(HKObjectQueryNoLimit),
      sortDescriptors: [sortDescriptor]) { (_, results, error) in
        
        guard error == nil else {
          print("Error: \(error!.localizedDescription)")
          return
        }
        
        completion(results?[0] as? HKQuantitySample)
    }
    
    self.healthKitInterface.healthStore.execute(query)
  }

}

