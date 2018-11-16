//
//  HeartRateMonitorViewController.swift
//  watchApp
//
//  Created by Calvin Wang on 11/14/18.
//  Copyright © 2018 Calvin Wang. All rights reserved.
//

import Foundation

class HeartRateMonitorViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
  
  let healthKitInterface = HealthKitManager()
  
  func deriveBeatsPerMinute(using heartRateMeasurementCharacteristic: CBCharacteristic) -> Int {
    
    let heartRateValue = heartRateMeasurementCharacteristic.value!
    let buffer = [UInt8](heartRateValue)
    
    if ((buffer[0] & 0x01) == 0) {
      print("BPM is UInt8")
      
      // store heart rate data in HKHealthStore
      healthKitInterface.writeHeartRateData(heartRate: Int(buffer[1]))
      
      return Int(buffer[1])
    } else {
      print("BPM is UInt16")
      return -1
    }
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    healthKitInterface.readHeartRateData()
  }

}
