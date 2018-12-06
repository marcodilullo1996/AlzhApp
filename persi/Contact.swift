//
//  Contact.swift
//  prova
//
//  Created by Emanuel Di Nardo on 06/12/2018.
//  Copyright © 2018 Marco Di Lullo. All rights reserved.
//

import Foundation

typealias EmergencyContacts = [Contact]

struct Contact: Codable {
    let name, surname, phoneNumber: String
}
