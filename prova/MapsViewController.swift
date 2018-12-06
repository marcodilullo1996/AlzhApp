//
//  MapsViewController.swift
//  prova
//
//  Created by Aniello Guida on 05/12/2018.
//  Copyright © 2018 Marco Di Lullo. All rights reserved.
//

import Foundation
import UIKit
import MapKit


class MapsViewController: UIViewController {
    
    @IBOutlet var mapView: MKMapView!
    
    var locationManager: CLLocationManager!
    var userLocation: CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingHeading()
        
        putPatientHomeOnMap()
        putSafeZoneOnMap()
    }
    
    func putSafeZoneOnMap() {
        var annotations = [MKPointAnnotation]()
        for safeZone in Database.shared.POIs {
            let coord = CLLocationCoordinate2D(
                latitude: safeZone.p.address.coord.lat,
                longitude: safeZone.p.address.coord.lon
            )
            let annotation = MKPointAnnotation()
            annotation.title = safeZone.p.name
            annotation.coordinate = coord
            annotations.append(annotation)
            
            let overlay = MKCircle(center: coord, radius: safeZone.p.address.range)
            mapView.addOverlay(overlay)
        }
        mapView.addAnnotations(annotations)
    }
    
    func putPatientHomeOnMap() {
        let patient = Database.shared.patient
        let coord = CLLocationCoordinate2D(
            latitude: (patient.user.address?.coord.lat)!,
            longitude: (patient.user.address?.coord.lon)!
        )
        
        let regionSpan = MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025)
        let region = MKCoordinateRegion(center: coord, span: regionSpan)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.title = "Home"
        annotation.coordinate = coord
        mapView.addAnnotation(annotation)
        
        let overlay = MKCircle(center: coord, radius: patient.user.address!.range)
        mapView.addOverlay(overlay)
        
    }
    
}

extension MapsViewController: MKMapViewDelegate {
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
}

extension MapsViewController: CLLocationManagerDelegate {
    
}
