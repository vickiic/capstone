//
//  IOWebService.swift
//  watchApp
//
//  Created by Matthew Mitchell on 1/27/19.
//  Copyright © 2019 InTouchTechnologies. All rights reserved.
//

import Foundation

class IOWebService {
    
    private static var sharedInstance: IOWebService? = nil
    
    public static func getSharedInstance() -> IOWebService{
        if sharedInstance == nil {
            print("device manager instance was nil")
            sharedInstance = IOWebService()
        }
        return sharedInstance!
    }
    
    public func writeHeartRateDataToIO(uid: String, heartRate: String){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let innerTime = dateFormatter.string(from: NSDate() as Date)
        
        let metricParams = ["device": uid, "value": heartRate, "time": innerTime] as [String: Any]
        
        guard let url = URL(string: "https://ithcapstone4.appspot.com/heartrates") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: metricParams, options: []) else { return }
        request.httpBody = httpBody
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
  
    public func sendBatchBPM(uid: String, heartRate: String, time: TimeInterval){
      
      print("sending: " + heartRate)
      
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
      let innerTime = dateFormatter.string(from: Date(timeIntervalSince1970: time))
      
      let metricParams = ["device": uid, "value": heartRate, "time": innerTime] as [String: Any]
      
      guard let url = URL(string: "https://ithcapstone4.appspot.com/heartrates") else { return }
      var request = URLRequest(url: url)
      request.httpMethod = "POST"
      
      guard let httpBody = try? JSONSerialization.data(withJSONObject: metricParams, options: []) else { return }
      request.httpBody = httpBody
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
    
    public func writeSymptom(uid: String, message: String){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let innerTime = dateFormatter.string(from: NSDate() as Date)
        
        /* insert rest of code to send symptom */
    }
}
