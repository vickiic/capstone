//
//  ViewController.swift
//  watchApp
//
//  Created by Calvin Wang on 10/29/18.
//  Copyright © 2018 Calvin Wang. All rights reserved.
//

import UIKit
import WatchConnectivity
import FirebaseAuth

class ViewController: UIViewController, WCSessionDelegate  {
    

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
    // Do any additional setup after loading the view, typically from a nib.
  }

  @IBOutlet weak var clickStatus: UILabel!
  
    @IBAction func test(_ sender: Any) {
    }
    
  @IBAction func click(_ sender: Any) {
    self.clickStatus.text = "Phone Click"
    print("clicked on Phone")
  }
    
    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBAction func loginTapped(_ sender: Any) {
        if let email = usernameTextfield.text, let password = passwordTextfield.text {
            Auth.auth().signIn(withEmail: email, password: password, completion: {
                (user, error) in
                if let firebaseError = error {
                    print(firebaseError.localizedDescription)
                    return
                }
                print("login success!")
            })
    }
    }
    
    @IBAction func signupTapped(_ sender: Any) {
        if let email = usernameTextfield.text, let password = passwordTextfield.text {
            Auth.auth().createUser(withEmail: email, password: password, completion: {
                user, error in
                if let firebaseError = error {
                    print(firebaseError.localizedDescription)
                    return
                }
                print("success!")
            })
        }
    }
}

