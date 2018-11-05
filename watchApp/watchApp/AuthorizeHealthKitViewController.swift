//
//  AuthorizeHealthKitViewController.swift
//  watchApp
//
//  Created by Matthew Mitchell on 11/2/18.
//  Copyright © 2018 Calvin Wang. All rights reserved.
//

import UIKit

class AuthorizeHealthKitViewController: UIViewController {

    var store:HealthKitManager = HealthKitManager.getInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("View did load")
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func authButtonClicked(_ sender: Any) {
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
