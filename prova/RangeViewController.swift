//
//  RangeViewController.swift
//  prova
//
//  Created by Marco Di Lullo on 01/12/2018.
//  Copyright © 2018 Marco Di Lullo. All rights reserved.
//

import UIKit
import MapKit

class RangeViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var rangeTexField: UITextField!
    var locationManager: CLLocationManager!
    var userPosition: CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rangeTexField.setBottomBorder(withColor: .black)
        
        locationManager = CLLocationManager() //INizializziamo location manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters //Accuratezza desiderata
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()

        // Do any additional setup after loading the view.
    }
    
    /*
    func region(withGeotification geotification: Geotification) -> CLCircularRegion {
        // 1
        let region = CLCircularRegion(center: geotification.coordinate, radius: geotification.radius, identifier: geotification.identifier)
        // 2
        region.notifyOnEntry = (geotification.eventType == .onEntry)
        region.notifyOnExit = !region.notifyOnEntry
        return region
    }
 */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

/*extension UITextField {
    func setBottomBorder(withColor color: UIColor) {
        self.borderStyle = UITextField.BorderStyle.none
        self.backgroundColor = UIColor.clear
        let height: CGFloat = 1.0
        
        let borderLine = UIView(frame: CGRect(x: 0, y: self.frame.height - height+10, width: self.frame.width, height: height))
        borderLine.backgroundColor = color
        self.addSubview(borderLine)
    }
}*/

