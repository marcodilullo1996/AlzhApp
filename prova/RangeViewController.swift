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


class RangeViewController: UIViewController, CLLocationManagerDelegate {

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
        var geocoder = CLGeocoder()
        var coordinates: CLLocationCoordinate2D?
        geocoder.geocodeAddressString(addressLocation) {
            placemarks, error in
            let placemark = placemarks?.first
            coordinates = placemark?.location?.coordinate
            
            print("Coordinate: \(coordinates!)")
            
            let region = CLCircularRegion(center: coordinates!, radius: 10000, identifier: "geofence") // radius: 200
            self.mapRange.removeOverlays(self.mapRange.overlays)
            self.locationManager.startMonitoring(for: region)
            let circle = MKCircle(center: coordinates!, radius: region.radius)
            self.mapRange.addOverlay(circle)

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

extension RangeViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let circleOverlay = overlay as? MKCircle else { return MKOverlayRenderer() }
        let circleRenderer = MKCircleRenderer(circle: circleOverlay)
        circleRenderer.strokeColor = .red
        circleRenderer.fillColor = .red
        circleRenderer.alpha = 0.5
        return circleRenderer
    }
}
