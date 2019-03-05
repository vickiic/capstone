//
//  PhysicianViewController.swift
//  BoringSSL
//
//  Created by vchen on 2/5/19.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import Firebase

class PhysicianViewController: UIViewController {
    
    @IBOutlet weak var physicianNameTF: UILabel!
    
    @IBOutlet weak var physicianLocationTF: UILabel!
    @IBOutlet weak var physicianEmailTF: UILabel!
    var physicianName = ""
    var physicianEmail = ""
    var physicianLocation = ""
    @IBOutlet weak var physicianImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        physicianImage.contentMode = .scaleAspectFit
        
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
                if let imageLoc = document.data()?["physicianImage"] {
                    self.downloadImage(loc: imageLoc as! String)
                }
            
            } else {
                print("Document does not exist")
                return
            }
        }
        // Do any additional setup after loading the view.
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
                self.physicianImage.image = UIImage(data: data!)
                self.physicianImage.layer.borderWidth = 3.0
                self.physicianImage.layer.cornerRadius = 154/2
                let borderColor = UIColor(red: 255.0/255.0, green: 139.0/255.0, blue: 127.0/255.0, alpha: 1.0)
                self.physicianImage.layer.borderColor = borderColor.cgColor
                self.physicianImage.clipsToBounds = true
            }
        }
    }

    
}
