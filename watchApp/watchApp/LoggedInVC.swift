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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.subscribeToHeartBeatChanges()
//    for n in 1...10 {
//      // extra yolo query infinite recursion -- hope to kickstart the observer
//      self.fetchLatestHeartRateSample(completion: { sample in
//        guard let sample = sample else {
//          return
//        }
//        
//        print("fetching" + String(n))
//        
//        /// The completion in called on a background thread, but we
//        /// need to update the UI on the main.
//        DispatchQueue.main.async {
//          
//          /// Converting the heart rate to bpm
//          let heartRateUnit = HKUnit(from: "count/min")
//          let heartRate = sample
//            .quantity
//            .doubleValue(for: heartRateUnit)
//          
//          /// Updating the UI with the retrieved value
//          print("\(Int(heartRate))")
//          self.beatsPerMinuteLabel.text = "\(Int(heartRate))"
//        }
//      })
//    }
  }
  
  let store:HealthKitManager = HealthKitManager.getInstance()

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
        let dm: DeviceManager = DeviceManager.getSharedInstance()
        dm.writeHeartRateData(apiKey: "apikey", username: "username", uid: "uid", heartRate: "50", timeStamp: "2018-11-19T22:26:12")
    }
  
  private var heartRateQuery:HKObserverQuery?
  
  public func subscribeToHeartBeatChanges() {
    
    // Creating the sample for the heart rate
    guard let sampleType: HKSampleType =
      HKObjectType.quantityType(forIdentifier: .heartRate) else {
        return
    }
    
    /// Creating an observer, so updates are received whenever HealthKit’s
    // heart rate data changes.
    print("subscribeToHeartBeatChanges fxn")
    self.heartRateQuery = HKObserverQuery.init(
      sampleType: sampleType,
      predicate: nil) { [weak self] _, _, error in
        guard error == nil else {
          print(error!)
          return
        }
        
        print("finna fetch")
        /// When the completion is called, an other query is executed
        /// to fetch the latest heart rate
        self?.fetchLatestHeartRateSample(completion: { sample in
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
            self?.beatsPerMinuteLabel.text = "\(Int(heartRate))"
            
          }
        })
    }
    
    print("after observer initialization")
    self.healthKitInterface.healthStore.execute(heartRateQuery ?? nil!)
  
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

