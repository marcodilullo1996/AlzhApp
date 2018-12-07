//
//  ChoiceviewController.swift
//  prova
//
//  Created by Aniello Guida on 06/12/2018.
//  Copyright © 2018 Marco Di Lullo. All rights reserved.
//

import Foundation
import UIKit

class ChoiceViewController: UIViewController{
    
    @IBOutlet weak var PatientButton: UIButton!
    @IBOutlet weak var TutorButton: UIButton!

    var db = Database.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        
        PatientButton.layer.cornerRadius = 5
        PatientButton.layer.borderWidth = 1
        PatientButton.layer.borderColor = UIColor.white.cgColor
        
        TutorButton.layer.cornerRadius = 5
        TutorButton.layer.borderWidth = 1
        TutorButton.layer.borderColor = UIColor.white.cgColor
        

    }
    
    @IBAction func seguePatient(_ sender: Any) {
        // check db consistency
        // perform a segue or another segue depending where the user was already inserted
//        if db.patient.user.address!.text.isEmpty {
        
            performSegue(withIdentifier: "toPatientApp", sender: self)

//        } else {
//
//            performSegue(withIdentifier: "skipPatientData", sender: self)
//
//        }
        
//        if !nameField.text!.isEmpty && !surnameField.text!.isEmpty && !addressField.text!.isEmpty {
//            if !addressField.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty {

    
}
}
