//
//  Location.swift
//  BucketList
//
//  Created by Oleg Gavashi on 26.01.2024.
//

import Foundation
import MapKit

struct Location: Codable, Equatable, Identifiable {
    var id: UUID
    var name: String
    var description: String
    var latitude: Double
    var longtitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
    }
    
    static func ==(lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
    
#if DEBUG
    static let example = Location(id: UUID(), name: "Buckingham Palace", description: "Lit by over 40.000 lightbulbs.", latitude: 51.501, longtitude: -0.141)
#endif
}
