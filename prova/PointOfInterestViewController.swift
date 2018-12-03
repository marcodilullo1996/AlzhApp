//
//  PointOfInterestViewController.swift
//  prova
//
//  Created by Marco Di Lullo on 01/12/2018.
//  Copyright © 2018 Marco Di Lullo. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class PointOfInterestViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var rangeLabel: UILabel!
    
    var locationManager: CLLocationManager!
    var userPosition: CLLocationCoordinate2D!
    
    var rangeRead: CLLocationDistance?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var stringa: String
        var double: Double
        
        double = Double(rangeRead!)
        stringa = String(double)
        
        rangeLabel.text = stringa
        
        
        
        
        
        

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
