//
//  PatientViewController.swift
//  watchApp
//
//  Created by vchen on 2/5/19.
//  Copyright © 2019 InTouchTechnologies. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import Firebase
class PatientViewController: UIViewController {

    @IBOutlet weak var patientEmailTF: UILabel!
    @IBOutlet weak var patientNameTF: UILabel!
    @IBOutlet weak var patientAgeTF: UILabel!
//    @IBOutlet weak var physicianNameTF: UILabel!
//    @IBOutlet weak var physicianEmailTF: UILabel!
//    @IBOutlet weak var physicianLocationTF: UILabel!
    var physicianName = ""
    var physicianEmail = ""
    var physicianLocation = ""
    var patientFirstName = ""
    var patientEmail = ""
    var patientAge = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        let currUid = Auth.auth().currentUser?.uid
        let userinfo = db.collection("users").document(currUid!)
        userinfo.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                if let patientFirstName = document.data()?["firstName"] {
                    self.patientNameTF.text = (patientFirstName as! String)
                }
                // let patientLastName = document.data()?["lastName"] as? String
                if let patientAge = document.data()?["age"] {
                    self.patientAgeTF.text = (patientAge as! String)
                }
                if let patientEmail = document.data()?["email"] {
                    self.patientEmailTF.text = (patientEmail as! String)
                }
//                if let physicianName = document.data()?["physicianName"]{
//                    self.physicianNameTF.text = (physicianName as! String)
//                }
//                if let physicianLocation = document.data()?["physicianLocation"] {
//                    self.physicianLocationTF.text = (physicianLocation as! String)
//                }
//                if let physicianEmail = document.data()?["physicianEmail"] {
//                    self.physicianEmailTF.text = physicianEmail as? String
//                }
//
            } else {
                print("Document does not exist")
                return
            }
        }
    
       //  Do any additional setup after loading the view.
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
