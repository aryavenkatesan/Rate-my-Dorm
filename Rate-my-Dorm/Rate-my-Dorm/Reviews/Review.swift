//
//  Review.swift
//  Rate-my-Dorm
//
//  Created by Brenton on 4/21/25.
//


import Foundation

struct Review: Identifiable, Codable {
    var id = UUID()
    var rating: Int
    var comment: String
    var date: Date
}
