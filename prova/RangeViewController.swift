//
//  RangeViewController.swift
//  prova
//
//  Created by Marco Di Lullo on 01/12/2018.
//  Copyright © 2018 Marco Di Lullo. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class RangeViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var rangeTextField: UITextField!
    @IBOutlet weak var mapRange: MKMapView!
    
    var locationManager: CLLocationManager!
    var userPosition: CLLocationCoordinate2D!
    
    var addressLocation = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rangeTextField.setBottomBorder(withColor: .black)
        
        locationManager = CLLocationManager() //INizializziamo location manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters //Accuratezza desiderata
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        //addressLocation =

        // Do any additional setup after loading the view.
    }
    
    @IBAction func showRegion(_ sender: Any)
    {
        //var coordinates: CLLocationCoordinate2D
        var geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressLocation) {
            placemarks, error in
            let placemark = placemarks?.first
            let coordinates = placemark?.location?.coordinate
            //coordinate = placemark.location!.coordinate
            //let lat = placemark?.location?.coordinate.latitude
            //let lon = placemark?.location?.coordinate.longitude
            print("Coordinate: \(coordinates)")
            
            let region = CLCircularRegion(center: coordinates!, radius: 100000, identifier: "geofence") // radius: 200
            
            
        }
        
        mapRange.removeOverlays(mapRange.overlays)
        locationManager.startMonitoring(for: region)
        let circle = MKCircle(center: coordinates!, radius: region.radius)
        mapRange.addOverlay(circle)
        
        
        
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

