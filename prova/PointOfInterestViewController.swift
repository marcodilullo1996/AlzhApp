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

class PointOfInterestViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    
    
    func displayAlert() {
        
    }
    
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

        range =  db.patient.user.address!.range as CLLocationDistance

        var region: MKCoordinateRegion = mapPOI.region

        region.center.latitude = (coordinates?.latitude)!
        region.center.longitude = (coordinates?.longitude)!
        
        region.span = MKCoordinateSpan(latitudeDelta: 0.4, longitudeDelta: 0.4)
        
        mapPOI.setRegion(region, animated: true)
    
        let region2 = CLCircularRegion(center: coordinates!, radius: range!, identifier: "geofence")
        mapPOI.removeOverlays(mapPOI.overlays)
        locationManager.startMonitoring(for: region2)
        let circle = MKCircle(center: coordinates!, radius: region2.radius)
        
        mapPOI.addOverlay(circle)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates!
        mapPOI.addAnnotation(annotation)
        
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func addPOI(_ sender: Any)
    {
        idPOI = idPOITextField.text!
        addressPOI = addressPOITextField.text!
        
        print(idPOI)
        print(addressPOI)
        
        var pCoord = Coord(lat: 1.0, lon: 1.0)
        var pAddr = Addr(text: addressPOI, coordPOI: pCoord )
        var po = POI(namePOI: idPOI, addrPOI: pAddr)
        
        db.POI.p = po
        db.save(element: db.POI, forKey: "POI")
        
        getCoordinates()
        
        
        print()
        
        
        
        
        
//        let c = Coord(lat: 1.1, lon: 3.2)
//        let p = POI(addr: pointOI, poiCoord: Coord)
//
//        print(pointOI)
//
//
//        getCoordinates()
        
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

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func getCoordinates() {
        geocoder.geocodeAddressString(db.POI.p!.addrPOI.text) {
            [weak self] placemarks, error in
            guard let strongSelf = self else { return }
            
            let placemark = placemarks?.first
            strongSelf.db.POI.p?.addrPOI.coordPOI.lat = (placemark?.location?.coordinate.latitude)!
            strongSelf.db.POI.p?.addrPOI.coordPOI.lon = (placemark?.location?.coordinate.longitude)!
            
            
            var region: MKCoordinateRegion = strongSelf.mapPOI.region
            region.center.latitude = (placemark?.location?.coordinate.latitude)!
            region.center.longitude = (placemark?.location?.coordinate.longitude)!
            
            region.span = MKCoordinateSpan(latitudeDelta: 0.4, longitudeDelta: 0.4)
            
            strongSelf.mapPOI.setRegion(region, animated: true)
            
            
        }
    }
}





    

    


