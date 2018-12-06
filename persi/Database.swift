//
//  Database.swift
//  prova
//
//  Created by Marco Di Lullo on 03/12/2018.
//  Copyright © 2018 Marco Di Lullo. All rights reserved.
//

import Foundation

class Database {
    static let shared = Database()
    //    var keys: [String] = [String]()
    //    lazy var keys: [String] = {
    //        let mirror = Mirror(reflecting: Database.shared)
    //        var me = [String]()
    //        for member in mirror.children {
    //            if let m = (member.value as? JSONCodable) {
    //                me.append(m.key)
    //            }
    //        }
    //        return me
    //    }()
    
    // Put codable class here as class member
    //    var example: ExampleJSON
    var patient: Patient
    var POIs: SafePoints
    var contacts: EmergencyContacts
    
    static func decode<T>(forClass jsonCodable: T.Type, withKey key: String) -> T? where T: Codable {
        do {
            if let data = UserDefaults.standard.data(forKey: key) {
                return try JSONDecoder().decode(jsonCodable, from: data)
            } else if let file = Bundle.main.url(forResource: key, withExtension: "json") {
                let data = try? Data(contentsOf: file)
                return try JSONDecoder().decode(jsonCodable.self, from: data!)
            } else {
                return nil
            }
        } catch let err {
            print(err.localizedDescription)
            return nil
        }
        
    }
    
    private init() {
        self.patient = Database.decode(forClass: Patient.self, withKey: "Patient") ?? Patient(user: User(firstname: "", lastname: "", address: nil))
        self.POIs = Database.decode(forClass: SafePoints.self, withKey: "POI") ?? SafePoints()
        self.contacts = Database.decode(forClass: EmergencyContacts.self, withKey: "EmergencyContacts") ?? EmergencyContacts()
    }
    
    func removeObject(withKey key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    //    func removeAll() {
    //        for key in keys {
    //            UserDefaults.standard.removeObject(forKey: key)
    //        }
    //    }
    
    func save<T>(element jsonCodable: T, forKey key: String) where T: Codable {
        let jsonData = try? JSONEncoder().encode(jsonCodable.self)
        UserDefaults.standard.set(jsonData, forKey: key)
    }
}
