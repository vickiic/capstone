//
//  SignUpViewController.swift
//  watchApp
//
//  Created by Matthew Mitchell on 1/22/19.
//  Copyright © 2019 InTouchTechnologies. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignUpViewController: UIViewController {
    
    let dm:DeviceManager = DeviceManager.getSharedInstance()
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUpButtonClick(_ sender: UIButton) {
        
        let db = Firestore.firestore()
        
        if let email = emailTextField.text, let password = passwordTextField.text, let firstName = firstNameTextField.text, let lastName = lastNameTextField.text {
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
                    
                    db.collection("users").document(uid).setData([
                        "first": firstName,
                        "last": lastName,
                        "email": email!
                    ]) { err in
                        if let err = err {
                            print("Error adding document: \(err)")
                        } else {
                            print("Document added with ID")
                        }
                    }
                }
                self.presentLoggedInScreen()
                print("sign up success!")
            })
        }
    }
    
    func presentLoggedInScreen(){
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loggedInVC:LoggedInVC = storyboard.instantiateViewController(withIdentifier: "LoggedInVC") as! LoggedInVC
        self.present(loggedInVC, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
