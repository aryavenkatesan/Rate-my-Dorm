//
//  RentModel.swift
//  Rate-my-Dorm
//
//  Created by Arya Venkatesan on 4/15/25.
//
import Foundation
import MapKit
import CoreLocation

struct Review: Identifiable {
    let id = UUID()
    var rating: Int
    var comment: String?
}

struct Sublease: Identifiable {
    let id = UUID()
    var name: String
    var address: String
    var price: Double
    var distance: Double
    var propertyType: PropertyType
    var email: String
    var phoneNumber: String
    var liked: Bool = false
    var reviews: [Review] = []
    
    var latitude: Double?
    var longitude: Double?

    var averageRating: Int {
        guard !reviews.isEmpty else { return 0 }
        let total = reviews.map { $0.rating }.reduce(0, +)
        return total / reviews.count
    }

    var topComment: String {
        reviews.first(where: { (($0.comment?.isEmpty) == nil) })?.comment ?? ""
    }
    
    var coordinate: CLLocationCoordinate2D? {
            guard let lat = latitude, let lon = longitude else { return nil }
            return CLLocationCoordinate2D(latitude: lat, longitude: lon)
        }
}


enum PropertyType: String, CaseIterable, Codable {
    case apartment
    case dorm
    case house
}
