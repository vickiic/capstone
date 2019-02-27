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
import Firebase

class PatientViewController: UIViewController {
    
    let io: IOWebService = IOWebService.getSharedInstance()

    @IBOutlet weak var patientEmailTF: UILabel!
    @IBOutlet weak var patientNameTF: UILabel!
    @IBOutlet weak var patientAgeTF: UILabel!
    @IBOutlet weak var patientImage: UIImageView!

    var physicianName = ""
    var physicianEmail = ""
    var physicianLocation = ""
    var patientFirstName = ""
    var patientEmail = ""
    var patientAge = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        patientImage.contentMode = .scaleAspectFit
        
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
            }
        }
    }
    
    
    @IBAction func reportButtonClicked(_ sender: UIButton) {
        
        let currUid = Auth.auth().currentUser?.uid
        
        let alert = UIAlertController(title: "Symptom Report", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Describe your symptom..."
        })
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            
            if let symptom = alert.textFields?.first?.text {
                self.io.writeSymptom(uid: currUid!, message: symptom);
            }
        }))
        
        self.present(alert, animated: true)
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
