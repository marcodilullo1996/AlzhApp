//
//  ViewController.swift
//  prova
//
//  Created by Marco Di Lullo on 30/11/2018.
//  Copyright © 2018 Marco Di Lullo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var surnameField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //p
        nameField.setBottomBorder(withColor: .black)
        surnameField.setBottomBorder(withColor: .black)
        addressField.setBottomBorder(withColor: .black)


        // Do any additional setup after loading the view.
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

extension UITextField {
    func setBottomBorder(withColor color: UIColor) {
        self.borderStyle = UITextField.BorderStyle.none
        self.backgroundColor = UIColor.clear
        let height: CGFloat = 1.0
        
        let borderLine = UIView(frame: CGRect(x: 0, y: self.frame.height - height+10, width: self.frame.width, height: height))
        borderLine.backgroundColor = color
        self.addSubview(borderLine)
    }
}
