//
//  RentModel.swift
//  Rate-my-Dorm
//
//  Created by Arya Venkatesan on 4/15/25.
//
import Foundation

struct Sublease: Identifiable {
    let id = UUID()
    let creatorUsername: String
    var name: String
    var address: String
    var price: Double
    var distance: Double
    var propertyType: PropertyType
    let contactEmail: String
    var heartList: [String]
    var phoneNumber: String
    var rating: Int = 0
    var comments: String = ""
    var school: String
    var idCopy: String?
}

enum PropertyType: String, CaseIterable, Codable {
    case apartment
    case dorm
    case house
}
