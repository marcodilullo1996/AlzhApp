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
    
    var geocoder = CLGeocoder()
    var coordinates: CLLocationCoordinate2D?
    
    var range: CLLocationDistance?
    
    let db = Database.shared
    
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
        
        db.patient.user.address?.range = range!


        
        //coordinates.latitude = (db.patient.user.address!.coord.lat)
        //coordinates!.longitude = (db.patient.user.address!.coord.lon)
        coordinates = CLLocationCoordinate2D(latitude: db.patient.user.address!.coord.lat, longitude: db.patient.user.address!.coord.lon)
//        coordinates!.latitude =  db.patient.user.address!.coord.lat
//        coordinates!.longitude = db.patient.user.address!.coord.lon
        
        range =  db.patient.user.address!.range as CLLocationDistance
        
//        print("Ciao 4 \(range)")
        
//        coordinates = CLLocationCoordinate2D(db.patient.user.address?.coord)
        
        let region = CLCircularRegion(center: coordinates! , radius: range!, identifier: "geofence") // radius: 200
        mapRange.removeOverlays(mapRange.overlays)
        locationManager.startMonitoring(for: region)
        let circle = MKCircle(center: coordinates!, radius: region.radius)
        
        mapRange.addOverlay(circle)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates!
        mapRange.addAnnotation(annotation)
        
    
    }
    
    @IBAction func nextButton(_ sender: Any)
    {
        performSegue(withIdentifier: "goToPOI", sender: self)
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
        geocoder.geocodeAddressString(db.patient.user.address!.text) {
            [weak self] placemarks, error in
            guard let strongSelf = self else { return }
            
            let placemark = placemarks?.first
            strongSelf.db.patient.user.address?.coord.lat = (placemark?.location?.coordinate.latitude)!
            strongSelf.db.patient.user.address?.coord.lon = (placemark?.location?.coordinate.longitude)!

            
            var region: MKCoordinateRegion = strongSelf.mapRange.region
            region.center.latitude = (placemark?.location?.coordinate.latitude)!
            region.center.longitude = (placemark?.location?.coordinate.longitude)!
            
            region.span = MKCoordinateSpan(latitudeDelta: 0.4, longitudeDelta: 0.4)
            
            strongSelf.mapRange.setRegion(region, animated: true)
            
            
            
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}



