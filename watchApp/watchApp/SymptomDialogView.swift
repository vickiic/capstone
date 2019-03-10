//
//  SymptomDialogView.swift
//  watchApp
//
//  Created by Matthew Mitchell on 3/6/19.
//  Copyright © 2019 InTouchTechnologies. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class SymptomDialogView: UIView {
    
    @IBOutlet weak var discomfortButton: UIButton!
    @IBOutlet weak var fatigueButton: UIButton!
    @IBOutlet weak var nauseaButton: UIButton!
    @IBOutlet weak var painButton: UIButton!
    
    let io: IOWebService = IOWebService.getSharedInstance()
    let currUid = Auth.auth().currentUser?.uid
    
    override func layoutSubviews() {
        painButton?.layer.cornerRadius = 30
        discomfortButton?.layer.cornerRadius = 30
        fatigueButton?.layer.cornerRadius = 30
        nauseaButton?.layer.cornerRadius = 30
        
        painButton?.clipsToBounds = true
        discomfortButton?.clipsToBounds = true
        fatigueButton?.clipsToBounds = true
        nauseaButton?.clipsToBounds = true
    }
    
    @IBAction func fatigueClicked(_ sender: UIButton) {
        sendSymptom(type: 1)
        self.io.sendSymptomIO(uid: self.currUid!, type: 1)
    }
    
    @IBAction func nauseaClicked(_ sender: UIButton) {
        sendSymptom(type: 2)
        self.io.sendSymptomIO(uid: self.currUid!, type: 2)
    }
    
    @IBAction func discomfortClicked(_ sender: UIButton) {
        sendSymptom(type: 3)
        self.io.sendSymptomIO(uid: self.currUid!, type: 3)
    }
    
    @IBAction func painClicked(_ sender: UIButton) {
        sendSymptom(type: 4)
        self.io.sendSymptomIO(uid: self.currUid!, type: 4)
    }
    
    
    func sendSymptom(type: Int){
        
        let symptomRef = Database.database().reference().child("symptoms")
        let newRef = symptomRef.childByAutoId();
        
        let currUid = Auth.auth().currentUser?.uid
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let innerTime = dateFormatter.string(from: NSDate() as Date)
        
        var symptomType:String = ""
        if(type == 1){
            symptomType = "fatigue"
        }
        else if(type == 2){
            symptomType = "nausea"
        }
        else if(type == 3){
            symptomType = "discomfort"
        }
        else if(type == 4){
            symptomType = "pain"
        }
        else{
            symptomType = "error"
        }
        
        let symptomData = ["sender_id": currUid ?? "user id doesn't exist", "symptom_type": symptomType, "time": innerTime] as [String: Any]
        
        newRef.setValue(symptomData)
        
        
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
