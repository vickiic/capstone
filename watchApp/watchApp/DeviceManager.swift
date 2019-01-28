//
//  DeviceManager.swift
//  watchApp
//
//  Created by Matthew Mitchell on 11/13/18.
//  Copyright © 2018 Calvin Wang. All rights reserved.
//

import Foundation

class DeviceManager {
    
    private static var sharedInstance: DeviceManager? = nil
    
    public static func getSharedInstance() -> DeviceManager{
        if sharedInstance == nil {
            print("device manager instance was nil")
            sharedInstance = DeviceManager()
        }
        return sharedInstance!
    }
    
    public func writeHeartRateData(uid: String, heartRate: String) {
      
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
      let innerTime = dateFormatter.string(from: NSDate() as Date)
      
      let innerParams = ["value": heartRate,  "timestamp": innerTime]
      let heartRateParams = ["heartRate": innerParams]
      let metricParams = ["device_uid": uid, "metric_field_values": heartRateParams] as [String : Any]
      
      guard let url = URL(string: "https://devices.intouchhealth.com/api/v1/metric_field_values") else { return }
      var request = URLRequest(url: url)
      request.httpMethod = "POST"
      
      guard let httpBody = try? JSONSerialization.data(withJSONObject: metricParams, options: []) else { return }
      request.httpBody = httpBody
      request.addValue(Api.apiKey, forHTTPHeaderField: "ITH-API-Key")
      request.addValue(Api.username, forHTTPHeaderField: "ITH-Username")
      request.addValue("application/json", forHTTPHeaderField: "Content-Type")
      
      let session = URLSession.shared
      session.dataTask(with: request) { (data, response, error) in
        if let response = response {
          print(response)
        }
        if let data = data {
          do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            print(json)
          } catch {
            print(error)
          }
        }
        }.resume()
      
    }
}
