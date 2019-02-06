//
//  PhysicianViewController.swift
//  BoringSSL
//
//  Created by vchen on 2/5/19.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import Firebase

class PhysicianViewController: UIViewController {
    
    @IBOutlet weak var physicianNameTF: UILabel!
    
    @IBOutlet weak var physicianLocationTF: UILabel!
    @IBOutlet weak var physicianEmailTF: UILabel!
    var physicianName = ""
    var physicianEmail = ""
    var physicianLocation = ""
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
                if let physicianName = document.data()?["physicianName"]{
                    self.physicianNameTF.text = (physicianName as! String)
                }
                if let physicianLocation = document.data()?["physicianLocation"] {
                    self.physicianLocationTF.text = (physicianLocation as! String)
                }
                if let physicianEmail = document.data()?["physicianEmail"] {
                    self.physicianEmailTF.text = physicianEmail as? String
                }
            
            } else {
                print("Document does not exist")
                return
            }
        }
        // Do any additional setup after loading the view.
    }

    
}
