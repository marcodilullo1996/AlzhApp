//
//  Notifications.swift
//  PushNotificationsExample
//
//  Created by Riccardo Stinca on 04/12/2018.
//  Copyright © 2018 Emanuel Di Nardo. All rights reserved.
//

import Foundation

struct Notifications: Codable {
    var interests: [String]
    var apns: Apns
}

struct Apns: Codable {
    var aps: Aps
    var coordinates: Coordinates
}

struct Aps: Codable {
    var alert: Alert
    var badge: Int
    var category: String
}

struct Alert: Codable {
    var title, body: String
}

struct Coordinates: Codable {
    var lat, lon: Double
}
