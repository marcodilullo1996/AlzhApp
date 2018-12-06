//
//  ProfileViewController.swift
//  prova
//
//  Created by Aniello Guida on 06/12/2018.
//  Copyright © 2018 Marco Di Lullo. All rights reserved.
//

import Foundation
import UIKit


class ProfileViewController: UIViewController{

    let db = Database.shared

        
        @IBOutlet weak var image: UIImageView!
        @IBOutlet weak var firstNameLabel: UILabel!
        @IBOutlet weak var lastNameLabel: UILabel!
        @IBOutlet weak var addressLabel: UILabel!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            firstNameLabel.text = db.patient.user.firstname
            lastNameLabel.text = db.patient.user.lastname
            addressLabel.text = db.patient.user.address?.text

            
            // Do any additional setup after loading the view.
        }
        
}
