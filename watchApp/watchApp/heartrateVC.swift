//
//  HeartrateVC.swift
//  watchApp
//
//  Created by Calvin Wang on 2/19/19.
//  Copyright © 2019 InTouchTechnologies. All rights reserved.
//

import UIKit
import FirebaseAuth
import HealthKit
import Charts

class heartrateVC: UIViewController {
  
  @IBOutlet weak var liveBPM: UILabel!
  @IBOutlet weak var bpmGraph: LineChartView!
  
  let healthKitInterface = HealthKitManager()
  private var heartRateQuery:HKObserverQuery?
  let io: IOWebService = IOWebService.getSharedInstance()
  let dm: DeviceManager = DeviceManager.getSharedInstance()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    //    self.subscribeToHeartBeatChanges()
    self.getLastDay()
    
    var runCount = 0
    
    Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { timer in
      print("timer fired")
      self.subscribeToHeartBeatChanges()
      runCount += 1
      
      if runCount == 50 {
        timer.invalidate()
      }
    }
    
        self.title = "Heart Rate Chart"
    
        let xAxis = bpmGraph.xAxis
        xAxis.labelPosition = .topInside
        xAxis.labelFont = .systemFont(ofSize: 10, weight: .light)
        xAxis.labelTextColor = UIColor(red: 255/255, green: 192/255, blue: 56/255, alpha: 1)
        xAxis.drawAxisLineEnabled = false
        xAxis.drawGridLinesEnabled = true
        xAxis.centerAxisLabelsEnabled = true
        xAxis.granularity = 3600
//        xAxis.valueFormatter = DateFormatter()
    
  }
  
  // TODO: Override the IndexAxisValueFormatter class (Or iAxis??) for the stringForValue function
  //  class formatXaxis: IndexAxisValueFormatter {
  //    override func stringForValue(_ value: Double, axis: AxisBase?) -> String {
  //      // need to take value and format it into string for dates of xAxis -- will use time since 1970
  //      let date = Date(timeIntervalSince1970: value)
  //      return DateFormatter.string(from: date)
  //    }
  //  }
  
  //  func getTimeZoneString(sample: HKSample? = nil, shouldReturnDefaultTimeZoneInExceptions: Bool = true) -> String? {
  //    var timeZone: TimeZone?
  //    print("sample?.metadata?[HKMetadataKeyTimeZone]: \(String(describing: sample?.metadata?[HKMetadataKeyTimeZone]))") // I have steps data recorded by my iPhone6s, not getting the timezone information for that health data.
  //
  //    if let metaDataTimeZoneValue = sample?.metadata?[HKMetadataKeyTimeZone] as? String {
  //      timeZone = TimeZone(identifier: metaDataTimeZoneValue)
  //    }
  //
  //    if shouldReturnDefaultTimeZoneInExceptions == true && timeZone == nil {
  //      timeZone = TimeZone.current
  //    }
  //
  //    var timeZoneString: String?
  //
  //    if let timeZone = timeZone {
  //      let seconds = timeZone.secondsFromGMT()
  //
  //      let hours = seconds/3600
  //      let minutes = abs(seconds/60) % 60
  //
  //      timeZoneString = String(format: "%+.2d:%.2d", hours, minutes)
  //    }
  //
  //    return timeZoneString
  //  }
  
  
  public func setChartValues(_ newVals: [ChartDataEntry], count: Int = 20) {
    
    //    bpmGraph.xAxis.valueFormatter = IndexAxisValueFormatter().stringForValue(<#T##value: Double##Double#>, axis: <#T##AxisBase?#>)
    
    //    print("values")
    //    print(values)
    let set1 = LineChartDataSet(values: newVals, label: "Last 6 hrs BPM")
    print("set1")
    print(set1)
    let data = LineChartData(dataSet: set1)
    bpmGraph.data = data
  }
  
  public func getLastDay() {
    
    var recentBPM = [ChartDataEntry]()
    
    // Creating the sample for the heart rate
    guard let sampleType: HKSampleType =
      HKObjectType.quantityType(forIdentifier: .heartRate) else {
        return
    }
    let prevQuery = HKObserverQuery(sampleType: sampleType, predicate: nil) { prevQuery, completionHandler, error in
      print("finna fetch last 24 hrs ")
      self.getRecentData(completion: { samples in
        guard let samples = samples else {
          return
        }
        print("fetching last 24 hrs")
        print(samples)
        for sample in samples {
          let doubleSample = sample.quantity.doubleValue(for: HKUnit(from: "count/min"))
          let timeSample = sample.endDate.timeIntervalSince1970
          recentBPM.append(ChartDataEntry(x: timeSample, y: doubleSample))
          print(Int(doubleSample))
        }
      })
      self.setChartValues(recentBPM)
    }
    self.healthKitInterface.healthStore.execute(prevQuery)
  }
  
  public func getRecentData(
    completion: @escaping (_ samples: [HKQuantitySample]?) -> Void) {
    
    /// Create sample type for the heart rate
    guard let sampleType = HKObjectType
      .quantityType(forIdentifier: .heartRate) else {
        completion(nil)
        return
    }
    
    /// Predicate for specifiying start and end dates for the query
    let predicate = HKQuery
      .predicateForSamples(
        withStart: Calendar.current.date(byAdding: .hour, value: -6, to: Date()),
        end: Date(),
        options: .strictEndDate)
    
    /// Set sorting by date.
    let sortDescriptor = NSSortDescriptor(
      key: HKSampleSortIdentifierStartDate,
      ascending: true)
    
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
        
        completion(results as? [HKQuantitySample])
    }
    
    /// Execute the query in the health store
    self.healthKitInterface.healthStore.execute(query)
  }
  
  public func subscribeToHeartBeatChanges() {
    
    guard let sampleType: HKSampleType =
      HKObjectType.quantityType(forIdentifier: .heartRate) else {
        return
    }
    
    let tempQuery = HKObserverQuery(sampleType: sampleType, predicate: nil) { tempQuery, completionHandler, error in
      self.fetchLatestHeartRateSample(completion: { sample in
        guard let sample = sample else {
          return
        }
        DispatchQueue.main.async {
          let heartRate = sample.quantity.doubleValue(for: HKUnit(from: "count/min"))
          let time = sample.startDate.timeIntervalSince1970
          let newTime = Date(timeIntervalSince1970: time)
          
          print("\(Int(heartRate))", time, newTime)
          self.liveBPM.text = "\(Int(heartRate))"
          let currUid = Auth.auth().currentUser?.uid
          self.io.writeHeartRateDataToIO(uid: currUid!, heartRate: "\(Int(heartRate))")
          // TODO: Need to add that to the dataset first
          //          self.bpmGraph.notifyDataSetChanged()
          //          self.bpmGraph.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .linear)
        }
      })
    }
    self.healthKitInterface.healthStore.execute(tempQuery)
    if let query = heartRateQuery {self.healthKitInterface.healthStore.execute(query)
      
      self.healthKitInterface.healthStore.enableBackgroundDelivery(for: sampleType, frequency: .immediate) { (true, nil) in
        self.healthKitInterface.healthStore.execute(tempQuery)
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