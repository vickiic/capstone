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
import FirebaseStorage
import FirebaseDatabase
import Firebase

class PatientViewController: UIViewController {
    
    let io: IOWebService = IOWebService.getSharedInstance()

    @IBOutlet weak var patientEmailTF: UILabel!
    @IBOutlet weak var patientNameTF: UILabel!
    @IBOutlet weak var patientAgeTF: UILabel!
    @IBOutlet weak var patientImage: UIImageView!
    
    @IBOutlet weak var reportButton: UIButton!
    
    @IBOutlet weak var symptomView: SymptomDialogView!
    
    var physicianName = ""
    var physicianEmail = ""
    var physicianLocation = ""
    var patientFirstName = ""
    var patientEmail = ""
    var patientAge = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        patientImage.contentMode = .scaleAspectFit
        
        symptomView.isHidden = true
        symptomView.layer.borderWidth = 2.0
        symptomView.layer.borderColor = UIColor(red: 214.0/255.0, green: 214.0/255.0, blue: 214.0/255.0, alpha: 1.0).cgColor
        symptomView.layer.cornerRadius = 70
        symptomView.clipsToBounds = true
        
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
                if let imageLoc = document.data()?["image"] {
                    self.downloadImage(loc: imageLoc as! String)
                }
                
            } else {
                print("Document does not exist")
                return
            }
        }
    
       //  Do any additional setup after loading the view.
    }
    
    func downloadImage(loc: String){
        let location = "images/" + loc
        let pathReference = Storage.storage().reference(withPath: location)
        
        pathReference.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                // Uh-oh, an error occurred!
                print("Error downloading image: " + error.localizedDescription)
            } else{
                // Data for "images/island.jpg" is returned
                self.patientImage.image = UIImage(data: data!)
                self.patientImage.layer.borderWidth = 3.0
                self.patientImage.layer.cornerRadius = 154/2
                let borderColor = UIColor(red: 255.0/255.0, green: 139.0/255.0, blue: 127.0/255.0, alpha: 1.0)
                self.patientImage.layer.borderColor = borderColor.cgColor
                self.patientImage.clipsToBounds = true
            }
        }
    }
    
    
    @IBAction func reportButtonClicked(_ sender: UIButton) {
        
        if(symptomView.isHidden){
            symptomView.isHidden = false
            reportButton.setTitle("Cancel", for: .normal)
        }
        else{
            symptomView.isHidden = true
            reportButton.setTitle("Report Symptom", for: .normal)
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
