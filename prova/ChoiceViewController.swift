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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PatientButton.layer.cornerRadius = 5
        PatientButton.layer.borderWidth = 1
        PatientButton.layer.borderColor = UIColor.white.cgColor
        
        TutorButton.layer.cornerRadius = 5
        TutorButton.layer.borderWidth = 1
        TutorButton.layer.borderColor = UIColor.white.cgColor
        

    }
    
}
