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
import FirebaseFirestore



class ViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    print("Original view did load")
    
    let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
    tap.cancelsTouchesInView = false
    self.view.addGestureRecognizer(tap)
    // Do any additional setup after loading the view, typically from a nib.
  }
    
    @IBAction func SendHealthData(_ sender: Any) {
        let dm: DeviceManager = DeviceManager.getSharedInstance()
        dm.writeHeartRateData(uid: "uid", heartRate: "50")
    }
    
    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
//    @IBOutlet weak var patientNameTF: UITextField!
//    @IBOutlet weak var patientEmailTF: UITextField!
//    @IBOutlet weak var patientAgeTF: UITextField!
//    @IBOutlet weak var physicianNameTF: UITextField!
//    @IBOutlet weak var physicianLocationTF: UITextField!
//    @IBOutlet weak var physicianEmailTF: UITextField!
    var physicianName = ""
    var physicianEmail = ""
    var physicianLocation = ""
    var patientFirstName = ""
    var patientEmail = ""
    var patientAge = ""
    
    @IBAction func loginTapped(_ sender: Any) {
        if let email = usernameTextfield.text, let password = passwordTextfield.text {
            Auth.auth().signIn(withEmail: email, password: password, completion: {
                (user, error) in
                if let firebaseError = error {
                print(firebaseError.localizedDescription)
                    return
                }
                self.presentLoggedInScreen()
                //self.loadData() //loads patient & physician info in respective fields
                print("login success!")
//                let db = Firestore.firestore()
//                let currUid = Auth.auth().currentUser?.uid
//                let userinfo = db.collection("users").document(currUid!)
//                userinfo.getDocument { (document, error) in
//                    if let document = document, document.exists {
//                        let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
//                        print("Document data: \(dataDescription)")
//                        let patientFirstName = document.data()?["firstName"] as? String
//                        // let patientLastName = document.data()?["lastName"] as? String
//                        let patientAge = document.data()?["age"] as? String
//                        let patientEmail = document.data()?["email"] as? String
//                        let physicianName = document.data()?["physicianName"] as? String
//                        let physicianLocation = document.data()?["physicianLocation"] as? String
//                        let physicianEmail = document.data()?["physicianEmail"] as? String
//                    } else {
//                        print("Document does not exist")
//                        return
//                    }
//                }
             //   self.performSegue(withIdentifier: "sendInfo", sender: self)
            })
        }
    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let vc = segue.destination as! PatientViewController
//        vc.physicianName = physicianName
//        vc.physicianEmail = physicianEmail
//        vc.physicianLocation = physicianLocation
//        vc.patientFirstName = patientFirstName
//        vc.patientEmail = patientEmail
//        vc.patientAge = patientAge
//    }
    
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
    //let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    //let loggedInVC:LoggedInVC = storyboard.instantiateViewController(withIdentifier: "LoggedInVC") as! LoggedInVC
    //self.present(loggedInVC, animated: true, completion: nil)
    self.performSegue(withIdentifier: "loginSegue", sender: self)
  }
    
    
    
    
}

