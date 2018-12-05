//
//  POI.swift
//  prova
//
//  Created by Marco Di Lullo on 05/12/2018.
//  Copyright © 2018 Marco Di Lullo. All rights reserved.
//

import Foundation

import MapKit


struct POIOfInterest: Codable{
    var p: POI?
}
struct POI: Codable{
    var namePOI: String
    var addrPOI: Addr
    
}

struct Addr: Codable{
    var text: String
    var coordPOI: Coord
}

struct Coord2: Codable {
    var lat, lon: CLLocationDegrees
}

