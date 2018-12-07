//
//  MapsViewControllerTutor.swift
//  prova
//
//  Created by Aniello Guida on 06/12/2018.
//  Copyright © 2018 Marco Di Lullo. All rights reserved.
//

import Foundation

import Foundation
import UIKit
import MapKit


class MapsViewControllerTutor: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    

    @IBOutlet weak var mapView: MKMapView!
    
    var  userLocation: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: userLocation!, span: span)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = userLocation!
        annotation.title = "Patient"
        mapView.addAnnotation(annotation)
    }
    
}
