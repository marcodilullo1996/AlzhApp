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


class RangeViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {

    @IBOutlet weak var rangeTextField: UITextField!
    @IBOutlet weak var mapRange: MKMapView!
    @IBOutlet weak var setSafeAreaButton: UIButton!
    
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
//        setSafeAreaButton.isEnabled = false

    }
    
    
    
    @IBAction func showRegion(_ sender: Any) {
        
        guard rangeTextField.text != "" else {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
            imageView.image = #imageLiteral(resourceName: "warning")
            imageView.contentMode = .scaleAspectFit
            rangeTextField.rightView = imageView
            
            rangeTextField.placeholder = "Range required"
            rangeTextField.rightViewMode = .always
            return
        }
        
        if !(rangeTextField.text!.isEmpty) {
    
            range = Double(rangeTextField.text!)
            
            
            db.patient.user.address?.range = range!
            
            //coordinates.latitude = (db.patient.user.address!.coord.lat)
            //coordinates!.longitude = (db.patient.user.address!.coord.lon)
            //        coordinates = CLLocationCoordinate2D(latitude: db.patient.user.address!.coord.lat, longitude: db.patient.user.address!.coord.lon)
            //        coordinates!.latitude =  db.patient.user.address!.coord.lat
            //        coordinates!.longitude = db.patient.user.address!.coord.lon
            
            if let coord = coordinates {
                db.patient.user.address?.coord.lat = coord.latitude
                db.patient.user.address?.coord.lon = coord.longitude
                
                let region = CLCircularRegion(center: coordinates! , radius: range!, identifier: "myhome-geofence")
                mapRange.removeOverlays(mapRange.overlays)
                locationManager.startMonitoring(for: region)
                let circle = MKCircle(center: coordinates!, radius: region.radius)
                
                mapRange.addOverlay(circle)
                db.save(element: db.patient, forKey: "Patient")
            } else {
                let alert = UIAlertController(title: "Position error", message: "Specified location is unvailable", preferredStyle: .alert)
                present(alert, animated: true, completion: nil)
            }
        
        }
       
    }
    
    @IBAction func nextButton(_ sender: Any) {
        guard rangeTextField.text != "" else {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
            imageView.image = #imageLiteral(resourceName: "warning")
            imageView.contentMode = .scaleAspectFit
            rangeTextField.rightView = imageView
            
            rangeTextField.placeholder = "Range required"
            rangeTextField.rightViewMode = .always
            return
        }
        
        if mapRange.overlays.count > 0 {
            performSegue(withIdentifier: "goToPOI", sender: self)
        }
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
            strongSelf.coordinates = CLLocationCoordinate2D(
                latitude: (placemark?.location?.coordinate.latitude)!,
                longitude: (placemark?.location?.coordinate.longitude)!
            )
            strongSelf.db.patient.user.address?.coord.lat =  (placemark?.location?.coordinate.latitude)!
            strongSelf.db.patient.user.address?.coord.lon = (placemark?.location?.coordinate.longitude)!
            
            var region: MKCoordinateRegion = strongSelf.mapRange.region
            region.center.latitude = (placemark?.location?.coordinate.latitude)!
            region.center.longitude = (placemark?.location?.coordinate.longitude)!
            
            region.span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            strongSelf.mapRange.setRegion(region, animated: true)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = strongSelf.coordinates!
//            annotation.title = "My home"
            strongSelf.mapRange.addAnnotation(annotation)
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension RangeViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKPointAnnotation {
            let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "safeZone")

            pinAnnotationView.isDraggable = true
            pinAnnotationView.canShowCallout = true

            return pinAnnotationView
        }

        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        if newState == .ending {
            coordinates?.latitude = (view.annotation?.coordinate.latitude)!
            coordinates?.longitude = (view.annotation?.coordinate.longitude)!
        }
    }
}
