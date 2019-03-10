//
//  IOWebService.swift
//  watchApp
//
//  Created by Matthew Mitchell on 1/27/19.
//  Copyright © 2019 InTouchTechnologies. All rights reserved.
//

import Foundation

class IOWebService {
    
    let dateFormatConfig = "yyyy-MM-dd HH:mm:ss"
    var liveBPM: String = "0"
    
    private static var sharedInstance: IOWebService? = nil
    
    public static func getSharedInstance() -> IOWebService{
        if sharedInstance == nil {
            print("device manager instance was nil")
            sharedInstance = IOWebService()
        }
        return sharedInstance!
    }
    
    public func sendSymptomIO(uid: String, type: Int) {
        
        var symptomType:String = ""
        if(type == 1){
            symptomType = "fatigue"
        }
        else if(type == 2){
            symptomType = "nausea"
        }
        else if(type == 3){
            symptomType = "discomfort"
        }
        else if(type == 4){
            symptomType = "pain"
        }
        else{
            symptomType = "error"
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormatConfig
        let innerTime = dateFormatter.string(from: NSDate() as Date)
        print("sending SYMPTOM: " + symptomType + ", heartrate: " + self.liveBPM)
        
        let metricParams = ["device": uid, "value": self.liveBPM, "time": innerTime, "symptom": symptomType] as [String: Any]
        
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
    
    public func writeHeartRateDataToIO(uid: String, heartRate: String){
        
        // Update liveBPM
        self.liveBPM = heartRate
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormatConfig
        let innerTime = dateFormatter.string(from: NSDate() as Date)
        print("sending: " + heartRate + ", " + innerTime)
        
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
      
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = dateFormatConfig
      let innerTime = dateFormatter.string(from: Date(timeIntervalSince1970: time))
      print("sending: " + heartRate + ", " + innerTime)
      
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
}
