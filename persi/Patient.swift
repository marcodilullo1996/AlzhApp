import Foundation

struct Patient: Codable {
    var user: User
}

struct User: Codable {
    var firstname, lastname: String
    var address: Address?
}


struct Address: Codable {
    var text: String
    var coord: Coord
}

struct Coord: Codable {
    var lat, lon: Double
}
