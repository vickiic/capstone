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
  
  struct batchTuple {
    var bpm: Double
    var time: TimeInterval
  }
  
  var healthKitInterface = HealthKitManager()
  private var heartRateQuery:HKObserverQuery?
  let io: IOWebService = IOWebService.getSharedInstance()
  let currUid = Auth.auth().currentUser?.uid
  let dm: DeviceManager = DeviceManager.getSharedInstance()
  var recentBPM = [ChartDataEntry]()
  var batch = [batchTuple]()
  var prevBPM: Int = 0
  
  // test for date value formatter
  final class DateValueFormatter: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
      return formatter.string(from: Date(timeIntervalSince1970: value))
    }
    
    let formatter: DateFormatter
    
    init(formatter: DateFormatter) {
      self.formatter = formatter
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.getLastDay()

    let xAxis = bpmGraph.xAxis
    xAxis.enabled = true
    xAxis.drawAxisLineEnabled = false
    xAxis.drawGridLinesEnabled = false
    xAxis.drawLabelsEnabled = true
    xAxis.labelPosition = .bottom
    xAxis.spaceMin = 0.5
    xAxis.spaceMax = 0.5
    xAxis.labelRotationAngle = -45.0
    xAxis.granularity = 1.0
    xAxis.spaceMin = xAxis.granularity / 5
    xAxis.spaceMax = xAxis.granularity / 5
    xAxis.avoidFirstLastClippingEnabled = true
    xAxis.axisLineWidth = 1.0
    
    // RIGHT axis
    bpmGraph.rightAxis.drawGridLinesEnabled = false
    bpmGraph.rightAxis.enabled = false
    bpmGraph.rightAxis.drawAxisLineEnabled = false
    
    // LEFT axis:
    bpmGraph.leftAxis.enabled = true
    bpmGraph.leftAxis.drawGridLinesEnabled = false
    bpmGraph.leftAxis.drawAxisLineEnabled = true
    bpmGraph.leftAxis.axisMinimum = 50
    bpmGraph.leftAxis.axisMaximum = 180
    
    let f = DateFormatter()
    f.dateStyle = .short
    bpmGraph.xAxis.valueFormatter = DateValueFormatter(formatter: f)
    
    var runCount = 0
    
    self.subscribeToHeartBeatChanges()
    batchSend()
    
    Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { timer in
      print("timer fired")
      self.healthKitInterface = HealthKitManager()
      self.subscribeToHeartBeatChanges()
      runCount += 1
      
      if runCount == 1000 {
        timer.invalidate()
      }
    }
  }

  func batchSend() {
    for tuple in self.batch {
      self.io.sendBatchBPM(uid: self.currUid!, heartRate: tuple.bpm, time: tuple.time)
    }
  }
  
  public func setChartValues(_ newVals: [ChartDataEntry], count: Int = 20) {
    //    print("values")
    //    print(values)
    let set1 = LineChartDataSet(values: newVals, label: "Last couple hrs BPM")
//    set1.mode = .cubicBezier
    set1.drawCirclesEnabled = false
    set1.drawValuesEnabled = false
    set1.drawFilledEnabled = true
    set1.fillAlpha = 0.25
    set1.fillColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
    set1.highlightColor = #colorLiteral(red: 0.4513868093, green: 0.9930960536, blue: 1, alpha: 1)
    set1.highlightLineWidth = 5.0
    set1.drawHorizontalHighlightIndicatorEnabled = false
    set1.formSize = 15.0
    set1.colors = [#colorLiteral(red: 1, green: 0.3699793715, blue: 0.3755039136, alpha: 0.6)]
    
    print("set1")
    print(set1)
    let data = LineChartData(dataSet: set1)
    bpmGraph.data = data
  }
  
  public func getLastDay() {
    
    guard let sampleType: HKSampleType =
      HKObjectType.quantityType(forIdentifier: .heartRate) else {
        return
    }
    
    let prevQuery = HKObserverQuery(sampleType: sampleType, predicate: nil) { prevQuery, completionHandler, error in
      self.getRecentData(completion: { samples in
        guard let samples = samples else {
          return
        }
        for sample in samples {
          let doubleSample = sample.quantity.doubleValue(for: HKUnit(from: "count/min"))
          let timeSample = sample.endDate.timeIntervalSince1970
          self.recentBPM.append(ChartDataEntry(x: timeSample, y: doubleSample))
          let tuple = batchTuple(bpm: doubleSample, time: timeSample)
          self.batch.append(tuple)
//          self.io.sendBatchBPM(uid: self.currUid!, heartRate: doubleSample, time: timeSample)
          print(Int(doubleSample))
        }
      })
      self.setChartValues(self.recentBPM)
    }
    self.healthKitInterface.healthStore.execute(prevQuery)
  }
  
  // This gets the recent data N hours ago
  public func getRecentData(
    completion: @escaping (_ samples: [HKQuantitySample]?) -> Void) {
    
    guard let sampleType = HKObjectType
      .quantityType(forIdentifier: .heartRate) else {
        completion(nil)
        return
    }
    
    let predicate = HKQuery
      .predicateForSamples(
        withStart: Calendar.current.date(byAdding: .hour, value: -6, to: Date()),
        end: Date(),
        options: .strictEndDate)
    
    let sortDescriptor = NSSortDescriptor(
      key: HKSampleSortIdentifierStartDate,
      ascending: true)
    
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

          if (Int(heartRate) != self.prevBPM) {
            self.prevBPM = Int(heartRate)
            self.recentBPM.append(ChartDataEntry(x: time, y: heartRate))
            self.liveBPM.text = "\(Int(heartRate))"
            self.io.writeHeartRateDataToIO(uid: self.currUid!, heartRate: "\(Int(heartRate))")

            self.bpmGraph.notifyDataSetChanged()
            self.bpmGraph.animate(xAxisDuration: 0.5, yAxisDuration: 0.5, easingOption: .linear)
          }
        }
      })
    }
    
    self.healthKitInterface.healthStore.execute(tempQuery)
    if let query = heartRateQuery { self.healthKitInterface.healthStore.execute(query)
      self.healthKitInterface.healthStore.enableBackgroundDelivery(for: sampleType, frequency: .immediate){
        (true, nil) in self.healthKitInterface.healthStore.execute(tempQuery)
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
