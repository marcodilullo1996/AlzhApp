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

class PointOfInterestViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    


    var locationManager: CLLocationManager!
    var userPosition: CLLocationCoordinate2D!
    
    @IBOutlet weak var mapPOI: MKMapView!
    
    var coordinates: CLLocationCoordinate2D?
    var range: CLLocationDistance?


    let db = Database.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        print("Ciao")
        mapPOI.addOverlay(circle)
        
        
        // Do any additional setup after loading the view.
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

}
