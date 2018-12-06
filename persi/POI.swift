//
//  POI.swift
//  prova
//
//  Created by Marco Di Lullo on 05/12/2018.
//  Copyright © 2018 Marco Di Lullo. All rights reserved.
//

import Foundation

import MapKit

typealias SafePoints = [SafeArea]

struct SafeArea: Codable {
    var p: POI
}

struct POI: Codable {
    var name: String
    var address: Address
}
