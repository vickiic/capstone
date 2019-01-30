//
//  ViewController.swift
//  watchApp
//
//  Created by Calvin Wang on 10/29/18.
//  Copyright © 2018 Calvin Wang. All rights reserved.
//

import UIKit
//import WatchConnectivity
import FirebaseAuth
import Firebase


class ViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    print("Original view did load")
    // Do any additional setup after loading the view, typically from a nib.
  }
    
    @IBAction func SendHealthData(_ sender: Any) {
        let dm: DeviceManager = DeviceManager.getSharedInstance()
        dm.writeHeartRateData(uid: "uid", heartRate: "50")
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
                self.presentLoggedInScreen()
                print("login success!")
            })
        }
    }
    @IBAction func signupTapped(_ sender: Any) {
        
        /*if let email = usernameTextfield.text, let password = passwordTextfield.text {
            Auth.auth().createUser(withEmail: email, password: password, completion: {
                user, error in
                if let firebaseError = error {
                print(firebaseError.localizedDescription)
                    return
                }
                if let firebaseUser = user?.user {
                    let email = firebaseUser.email
                    let uid = firebaseUser.uid
                    self.dm.createDevice(username:email!, uid:uid)
                }
                self.presentLoggedInScreen()
                print("sign up success!")
            })
        }*/
    }
  
  func presentLoggedInScreen(){
    let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let loggedInVC:LoggedInVC = storyboard.instantiateViewController(withIdentifier: "LoggedInVC") as! LoggedInVC
    self.present(loggedInVC, animated: true, completion: nil)
  }
    
}

