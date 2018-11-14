//
//  ViewController.swift
//  watchApp
//
//  Created by Calvin Wang on 10/29/18.
//  Copyright © 2018 Calvin Wang. All rights reserved.
//

import UIKit
import WatchConnectivity

class ViewController: UIViewController, WCSessionDelegate  {
    
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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    print("Original view did load")
    // Do any additional setup after loading the view, typically from a nib.
  }

  @IBOutlet weak var clickStatus: UILabel!
  
    @IBAction func test(_ sender: Any) {
    }
    
  @IBAction func click(_ sender: Any) {
    self.clickStatus.text = "Phone Click"
    print("clicked on Phone")
  }
    
    @IBAction func SendHealthData(_ sender: Any) {
        let dm: DeviceManager = DeviceManager.getSharedInstance()
        dm.writeHeartRateData(heartRate: "50", timeStamp: "11122018")
    }
    
}

