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

import Foundation

class PointOfInterestViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {

    var locationManager: CLLocationManager!
    var userPosition: CLLocationCoordinate2D!
    @IBOutlet weak var mapPOI: MKMapView!
    
    @IBOutlet weak var idPOITextField: UITextField!
    @IBOutlet weak var addressPOITextField: UITextField!
    
    var idPOI = ""
    var addressPOI = ""
    
    var coordinates: CLLocationCoordinate2D?
    var range: CLLocationDistance?
    
    var geocoder = CLGeocoder()

    let db = Database.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        idPOITextField.setBottomBorder(withColor: .black)
        addressPOITextField.setBottomBorder(withColor: .black)
        
        locationManager = CLLocationManager() //INizializziamo location manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters //Accuratezza desiderata
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        coordinates = CLLocationCoordinate2D(latitude: db.patient.user.address!.coord.lat, longitude: db.patient.user.address!.coord.lon)

        range = db.patient.user.address!.range as CLLocationDistance

        var region: MKCoordinateRegion = mapPOI.region

        region.center.latitude = (coordinates?.latitude)!
        region.center.longitude = (coordinates?.longitude)!
        
        region.span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        
        mapPOI.setRegion(region, animated: true)
        
        let homeGeofence = locationManager.monitoredRegions.first as! CLCircularRegion
        mapPOI.removeOverlays(mapPOI.overlays)
        let circle = MKCircle(center: homeGeofence.center, radius: homeGeofence.radius)
        
        mapPOI.addOverlay(circle)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates!
        annotation.title = "My home"
        mapPOI.addAnnotation(annotation)
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func addPOI(_ sender: Any) {
        idPOI = idPOITextField.text!
        addressPOI = addressPOITextField.text!
        
        getCoordinates()
        
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let circleOverlay = overlay as? MKCircle else { return MKOverlayRenderer() }
        for region in locationManager.monitoredRegions {
            let circularRegion = region as? CLCircularRegion
            if circleOverlay.coordinate.latitude == circularRegion!.center.latitude,
                circleOverlay.coordinate.longitude == circularRegion!.center.longitude, !(circularRegion?.identifier.starts(with: "myhome"))! {
                    
                let circleRenderer = MKCircleRenderer(circle: circleOverlay)
                circleRenderer.strokeColor = .blue
                circleRenderer.fillColor = .blue
                circleRenderer.alpha = 0.5
                
                return circleRenderer
            }
        }
        
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

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func getCoordinates() {
        geocoder.geocodeAddressString(addressPOI) {
            [weak self] placemarks, error in
            guard let strongSelf = self else { return }
            
            let placemark = placemarks?.first
            
            strongSelf.coordinates = CLLocationCoordinate2D(
                latitude: (placemark?.location?.coordinate.latitude)!,
                longitude: (placemark?.location?.coordinate.longitude)!
            )
            
            let coord = Coord.init(
                lat: (strongSelf.coordinates?.latitude)!,
                lon: (strongSelf.coordinates?.longitude)!
            )
            
            let address = Address.init(text: strongSelf.addressPOI, coord: coord, range: 10)
            let safePOI = POI.init(name: strongSelf.idPOI, address: address)
            let safeZone = SafeArea.init(p: safePOI)
            
            strongSelf.db.POIs.append(safeZone)
            strongSelf.db.save(element: strongSelf.db.POIs, forKey: "POI")
            
            var region: MKCoordinateRegion = strongSelf.mapPOI.region
            region.center.latitude = (strongSelf.coordinates?.latitude)!
            region.center.longitude = (strongSelf.coordinates?.longitude)!
            
            region.span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            strongSelf.mapPOI.setRegion(region, animated: true)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = strongSelf.coordinates!
            strongSelf.mapPOI.addAnnotation(annotation)
            
            let circularRegion = CLCircularRegion(center: region.center, radius: 10, identifier: strongSelf.idPOI + "-geofence")
            strongSelf.locationManager.startMonitoring(for: circularRegion)
            let circleOverlay = MKCircle(center: circularRegion.center, radius: circularRegion.radius)
            strongSelf.mapPOI.addOverlay(circleOverlay)
            
        }
    }
}

extension PointOfInterestViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.coordinate.latitude == coordinates?.latitude, annotation.coordinate.longitude == coordinates?.longitude {
            if annotation is MKPointAnnotation {
                let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "safeZone1")
                
                pinAnnotationView.isDraggable = true
                pinAnnotationView.canShowCallout = true
                
                return pinAnnotationView
            }
        }
        
        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        if view.reuseIdentifier == "safeZone1" {
            if newState == .ending {
                coordinates?.latitude = (view.annotation?.coordinate.latitude)!
                coordinates?.longitude = (view.annotation?.coordinate.longitude)!
            }
        }
    }
}



    

    


