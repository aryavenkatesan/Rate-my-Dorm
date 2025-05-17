//
//  Schemas.swift
//  Rate-my-Dorm
//
//  Created by Arya Venkatesan on 5/16/25.
//

struct ListingResponseJSON: Decodable {
    let accessToken: String?
    let _id: String?
    let title: String?
    let message: String?
    let stackTrace: String?
}

struct ListingJSON: Codable {
    let UUID: String
    let username: String
    let name: String
    let address: String
    let price: Double
    let distance: Double
    let propertyType: String
    let contactEmail: String
    let phoneNumber: String
    let rating: Double
    let comments: String
    let school: String
}

struct ContactsResponse: Codable {
    let contacts: [ListingJSONResponse]?
    let title: String?
    let message: String?
    let stackTrace: String?
}

struct HeartResponse: Codable {
    let _id: String?
    let UUID: String?
    let username: String?
    let name: String?
    let address: String?
    let price: Double?
    let distance: Double?
    let propertyType: String?
    let contactEmail: String?
    let heartList: [String]?
    let phoneNumber: String?
    let rating: Int?
    let comments: String?
    let __v: Int?
    let title: String?
    let message: String?
    let school: String?
    let stackTrace: String?
}

struct ListingJSONResponse: Codable {
    let _id: String
    let UUID: String
    let username: String
    let name: String
    let address: String
    let price: Double
    let distance: Double
    let propertyType: String
    let contactEmail: String
    let heartList: [String]
    let phoneNumber: String
    let rating: Int
    let comments: String
    let school: String
    let __v: Int
}

struct profileInfoForApi: Codable { //da bus
    let username: String
    let school: String
    let jwt: String
}
