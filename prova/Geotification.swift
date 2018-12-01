//
//  Geotification.swift
//  prova
//
//  Created by Marco Di Lullo on 01/12/2018.
//  Copyright © 2018 Marco Di Lullo. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

struct GeoKey {
    static let latitude = "latitude"
    static let longitude = "longitude"
    static let radius = "radius"
    static let identifier = "identifier"
    static let eventType = "eventTYpe"

    
}

enum EventType: String {
    case onExit = "On Exit"
}

class Geotification: NSObject, NSCoding, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var radius: CLLocationDistance
    var identifier: String
    var eventType: EventType
    
    var subtitle: String? {
        let eventTypeString = eventType.rawValue
        return "Radius: \(radius)m - \(eventTypeString)"
    }
    
    
    init(coordinate: CLLocationCoordinate2D, radius: CLLocationDistance, identifier: String, eventType: EventType) {
        self.coordinate = coordinate
        self.radius = radius
        self.identifier = identifier
        self.eventType = eventType
    }
    
    // MARK: NSCoding
    required init?(coder decoder: NSCoder) {
        let latitude = decoder.decodeDouble(forKey: GeoKey.latitude)
        let longitude = decoder.decodeDouble(forKey: GeoKey.longitude)
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        radius = decoder.decodeDouble(forKey: GeoKey.radius)
        identifier = decoder.decodeObject(forKey: GeoKey.identifier) as! String
        eventType = EventType(rawValue: decoder.decodeObject(forKey: GeoKey.eventType) as! String)!
        }
    
    func encode(with coder: NSCoder) {
        coder.encode(coordinate.latitude, forKey: GeoKey.latitude)
        coder.encode(coordinate.longitude, forKey: GeoKey.longitude)
        coder.encode(radius, forKey: GeoKey.radius)
        coder.encode(identifier, forKey: GeoKey.identifier)
        coder.encode(eventType.rawValue, forKey: GeoKey.eventType)
        }
    
}
