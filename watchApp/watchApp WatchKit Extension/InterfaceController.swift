//
//  InterfaceController.swift
//  watchApp WatchKit Extension
//
//  Created by Calvin Wang on 10/29/18.
//  Copyright © 2018 Calvin Wang. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {

  public func session(_ session: WCSession, activationDidCompleteWith
    activationState: WCSessionActivationState, error: Error?) {
    // leave empty
  }
  
  // if WCSession is supported then create a default session
  fileprivate let session: WCSession? = WCSession.isSupported() ? WCSession.default : nil
  
  // activate the optional session?
  override init() {
    super.init()
    
    session?.delegate = self
    session?.activate()
  }
  
  override func awake(withContext context: Any?) {
    super.awake(withContext: context)
    
    // Configure interface objects here.
  }
  
  override func willActivate() {
    // This method is called when watch view controller is about to be visible to user
    super.willActivate()
  }
  
  override func didDeactivate() {
    // This method is called when watch view controller is no longer visible
    super.didDeactivate()
  }
  
  @IBAction func watchClick() {
    print("Button Clicked!")
    let applicationData = ["counterValue" : 1]
    
    // The paired iPhone has to be connected via Bluetooth.
    if let session = session, session.isReachable {
      session.sendMessage(applicationData,
                          replyHandler: { replyData in
                            // handle reply from iPhone app here
                            print(replyData)
      }, errorHandler: { error in
        // catch any errors here
        print(error)
      })
    } else {
      // when the iPhone is not connected via Bluetooth
    }
  }
  
  
}
