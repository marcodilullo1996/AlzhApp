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


class MapsViewController: UITabBarController, MKMapViewDelegate, CLLocationManagerDelegate{
    
    @IBOutlet var MapView: UIView! = MKMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
