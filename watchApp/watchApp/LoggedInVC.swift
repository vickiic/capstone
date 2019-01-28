//
//  LoggedInVC.swift
//  watchApp
//
//  Created by vchen on 11/26/18.
//  Copyright © 2018 Calvin Wang. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoggedInVC: UIViewController {

    @IBAction func logoutTapped(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            dismiss(animated: true, completion:nil)
        } catch {
            print("There was a problem logging out")
        }
    }
    
    
    @IBAction func sendHeartRateData(_ sender: Any) {
        let io: IOWebService = IOWebService.getSharedInstance()
        let currUid = Auth.auth().currentUser?.uid
        io.writeHeartRateDataToIO(uid:currUid!, heartRate: "52", timeStamp: "2018-11-19T22:27:12")
    }
    
    
    @IBAction func continueButton(_ sender: UIButton) {
    }
}
