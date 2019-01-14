//
//  AuthorizeHealthKitViewController.swift
//  watchApp
//
//  Created by Matthew Mitchell on 11/2/18.
//  Copyright © 2018 Calvin Wang. All rights reserved.
//

import UIKit
import HealthKit

class AuthorizeHealthKitViewController: UIViewController {
    
    
    @IBOutlet weak var HealthKitAuthLabel: UILabel!
    var store:HealthKitManager = HealthKitManager.getInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("View did load")
        
        if(store.healthStore?.authorizationStatus(for: HKObjectType.quantityType(forIdentifier: .heartRate)!) == .sharingAuthorized){
            print("it did have access");
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let ViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.present(ViewController, animated: true, completion: nil)
            //self.performSegue(withIdentifier: "authorizedSegue", sender: nil)
        }
        else{
            print("it didnt have access");
            HealthKitAuthLabel.text = "To continue, please enable access to HealthKit data. \n\nTo authorize HealthKit go to: \n\nSettings > Privacy > Health > WatchApp \n\nand enable both read and write for heart rate data.\n"
        }
    }
    
    @IBAction func continueButton(_ sender: UIButton) {
        if(store.healthStore?.authorizationStatus(for: HKObjectType.quantityType(forIdentifier: .heartRate)!) == .sharingAuthorized){
            print("it did have access");
            self.performSegue(withIdentifier: "authorizedSegue", sender: nil)
        }
    }
    
    @IBAction func continueButtonClicked(_ sender: Any) {
        if(store.healthStore?.authorizationStatus(for: HKObjectType.quantityType(forIdentifier: .heartRate)!) == .sharingAuthorized){
            print("it did have access");
            self.performSegue(withIdentifier: "authorizedSegue", sender: nil)
        }
        else{
            print("it didnt have access");
            HealthKitAuthLabel.text = "To continue, please enable access to HealthKit data. \n\nTo authorize HealthKit go to: \n\nSettings > Privacy > Health > WatchApp \n\nand enable both read and write for heart rate data.\n"
        }
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
