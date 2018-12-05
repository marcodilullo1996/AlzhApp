//
//  ViewController.swift
//  prova
//
//  Created by Marco Di Lullo on 30/11/2018.
//  Copyright © 2018 Marco Di Lullo. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var surnameField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    
    var db = Database.shared

    
    var address = ""
    var name = ""
    var surname = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.text = db.patient.user.firstname
        surnameField.text = db.patient.user.lastname
        addressField.text = db.patient.user.address?.text


        nameField.setBottomBorder(withColor: .black)
        surnameField.setBottomBorder(withColor: .black)
        addressField.setBottomBorder(withColor: .black)

        
        nameField.delegate = self
        surnameField.delegate = self
        addressField.delegate = self


        // Do any additional setup after loading the view.
    }
    
    @IBAction func next(_ sender: Any) {
        if !nameField.text!.isEmpty && !surnameField.text!.isEmpty && !addressField.text!.isEmpty {
            if !addressField.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty {

                name = nameField.text!
                surname = surnameField.text!
                address = addressField.text!
                
                let c = Coord(lat: 1.2, lon: 3.2)
                let addr = Address(text: address, coord: c, range: 1.0)
                let u = User(firstname: name, lastname: surname, address: addr)
                
                db.patient.user = u
                db.save(element: db.patient, forKey: "Patient")
                print(db.patient.user.firstname)
                
                
                
                performSegue(withIdentifier: "passInformation", sender: self)
            }
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}

extension UITextField {
    func setBottomBorder(withColor color: UIColor) {
        self.borderStyle = UITextField.BorderStyle.none
        self.backgroundColor = UIColor.clear
        let height: CGFloat = 1.0
        
        let borderLine = UIView(frame: CGRect(x: 0, y: self.frame.height - height, width: self.frame.width, height: height))
        borderLine.backgroundColor = color
        self.addSubview(borderLine)
    }
}




