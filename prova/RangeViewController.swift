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


class RangeViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var rangeTextField: UITextField!
    @IBOutlet weak var mapRange: MKMapView!
    
    var locationManager: CLLocationManager!
    var userPosition: CLLocationCoordinate2D!
    
    var geocoder = CLGeocoder()
    var coordinates: CLLocationCoordinate2D?
    
    var addressLocation = ""
    var range: CLLocationDistance?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rangeTextField.setBottomBorder(withColor: .black)
        rangeTextField.delegate = self
        
        
        
        locationManager = CLLocationManager() //INizializziamo location manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters //Accuratezza desiderata
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        
        getCoordinates()
    }
    
    
    
    @IBAction func showRegion(_ sender: Any) {
        
        range = Double(rangeTextField.text!)
        
        let region = CLCircularRegion(center: coordinates!, radius: range!, identifier: "geofence") // radius: 200
        mapRange.removeOverlays(mapRange.overlays)
        locationManager.startMonitoring(for: region)
        let circle = MKCircle(center: coordinates!, radius: region.radius)
        mapRange.addOverlay(circle)
    
    }
    
    @IBAction func nextButton(_ sender: Any)
    {
        performSegue(withIdentifier: "goToPOI", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        var vc = segue.destination as! PointOfInterestViewController
    
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let circleOverlay = overlay as? MKCircle else { return MKOverlayRenderer() }
        let circleRenderer = MKCircleRenderer(circle: circleOverlay)
        circleRenderer.strokeColor = .red
        circleRenderer.fillColor = .red
        circleRenderer.alpha = 0.5
        
        
        
        return circleRenderer
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    //MARK: - Helper
    
     func getCoordinates() {
        geocoder.geocodeAddressString(addressLocation) {
            [weak self] placemarks, error in
            guard let strongSelf = self else { return }
            
            let placemark = placemarks?.first
            strongSelf.coordinates = placemark?.location?.coordinate
            
            var region: MKCoordinateRegion = strongSelf.mapRange.region
            region.center.latitude = (placemark?.location?.coordinate.latitude)!
            region.center.longitude = (placemark?.location?.coordinate.longitude)!
            
            region.span = MKCoordinateSpan(latitudeDelta: 0.4, longitudeDelta: 0.4)
            
            strongSelf.mapRange.setRegion(region, animated: true)
            
            print("Coordinate: \(strongSelf.coordinates!)")
            
            
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}



