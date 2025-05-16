//
//  ProfileModel.swift
//  Rate-my-Dorm
//
//  Created by Arya Venkatesan on 4/15/25.
//

import SwiftUI

enum ProfileModel {
    static let decoder = JSONDecoder()
    static let encoder = JSONEncoder()

    static let baseUrl = "http://localhost:5001/"

    static func uploadListingAPIRequest(listingInput: Sublease, usernameActual: String, schoolActual: String) async throws -> String {
        // TODO: Implement
        let workingUrl = baseUrl + "api/listing"
        guard let url = URL(string: workingUrl) else {
            fatalError("Invalid URL")
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var json: ListingJSON
        if listingInput.comments.count < 2 {
            json = ListingJSON(
                UUID: "\(listingInput.id)",
                username: usernameActual,
                name: listingInput.name,
                address: listingInput.address,
                price: listingInput.price,
                distance: listingInput.distance,
                propertyType: ".\(listingInput.propertyType)",
                contactEmail: listingInput.contactEmail,
                phoneNumber: listingInput.phoneNumber,
                rating: Double(listingInput.rating),
                comments: "No comments",
                school: schoolActual
            )
        } else {
            json = ListingJSON(
                UUID: "\(listingInput.id)",
                username: usernameActual,
                name: listingInput.name,
                address: listingInput.address,
                price: listingInput.price,
                distance: listingInput.distance,
                propertyType: ".\(listingInput.propertyType)",
                contactEmail: listingInput.contactEmail,
                phoneNumber: listingInput.phoneNumber,
                rating: Double(listingInput.rating),
                comments: listingInput.comments,
                school: schoolActual
            )
        }
        
//        {
//          "UUID": "2E1337D7-82D4-4198-B614-43BE9264FE61",
//          "username": "user321",
//          "name": "Lebron",
//          "address": "123 College St",
//          "price": 850,
//          "distance": 0.5,
//          "propertyType": ".apartment",
//          "contactEmail": "example@gmail.com",
//          "phoneNumber": "1234567890",
//          "rating": 3,
//          "comments": "I like this place",
//          "school": "Duke"
//        }

        let encoded: Data = try encoder.encode(json)
        request.httpBody = encoded
        
        let (data, response) = try await URLSession.shared.data(for: request)
        let jsonResponse = try decoder.decode(HeartResponse.self, from: data)

        let httpResponse = response as! HTTPURLResponse
        if httpResponse.statusCode <= 299 {
            return ""
        }

        if jsonResponse.message != nil {
            // extra checks so the app doesn't crash
            return jsonResponse.message!
        } else {
            return ""
        }
    }

    static func getAllListingsAPIRequest() async throws -> [Sublease] {
        // TODO: Implement
        let workingUrl = baseUrl + "api/listing"
        guard let url = URL(string: workingUrl) else {
            fatalError("Invalid URL")
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let (data, response) = try await URLSession.shared.data(for: request)
        let jsonResponse = try decoder.decode(ContactsResponse.self, from: data) // this should be changed

        var output: [Sublease] = []

        if jsonResponse.message != nil {
            return output
        }

        for listing in jsonResponse.contacts! {
            var PType: PropertyType
            switch listing.propertyType {
            case".apartment":
                PType = PropertyType.apartment
            case".dorm":
                PType = PropertyType.dorm
            case"apartment":
                PType = PropertyType.apartment
            case"dorm":
                PType = PropertyType.dorm
            default:
                PType = PropertyType.house
            }

            let oneListing = Sublease(creatorUsername: listing.username,
                                      name: listing.name,
                                      address: listing.address,
                                      price: listing.price,
                                      distance: listing.distance,
                                      propertyType: PType,
                                      contactEmail: listing.contactEmail,
                                      heartList: listing.heartList,
                                      phoneNumber: listing.phoneNumber,
                                      rating: Int(listing.rating),
                                      comments: listing.comments,
                                      school: listing.school,
                                      idCopy: listing.UUID)
            output.append(oneListing)
        }

        let httpResponse = response as! HTTPURLResponse

        if httpResponse.statusCode <= 299 {
            // 200-299 is a success
            return output
        }

        // this part should return the error string
        // realistically it won't throw so i'm leaving it
        // best practice says I should do extra legwork
        print("Error happened in getAllListingsAPIRequest")
        return []
    }

    static func flipHeartStatusAPIRequest(listingInput: Sublease, user: String) async throws -> String {
        // TODO: Implement
        let workingUrl = baseUrl + "api/listing/"
        guard let url = URL(string: workingUrl) else {
            fatalError("Invalid URL")
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let json: [String: String] = [
            "UUID": "\(listingInput.idCopy!)",
            "username": user
        ]
        print("\(json)")
        let encoded: Data = try encoder.encode(json)
        request.httpBody = encoded

        let (data, response) = try await URLSession.shared.data(for: request)
        // dont need to decode response, its not used at all
        let jsonResponse = try decoder.decode(HeartResponse.self, from: data)

        let httpResponse = response as! HTTPURLResponse

        if httpResponse.statusCode <= 299 {
            // 200-299 is a success
            print("sucess")
            return ""
        } else {
            print("\(jsonResponse)")
            return jsonResponse.message!
        }
    }

    static func deleteAPIRequest(listingInput: Sublease) async throws -> String {
        // TODO: Implement
        let workingUrl = baseUrl + "api/listing/"
        guard let url = URL(string: workingUrl) else {
            fatalError("Invalid URL")
        }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let json = [
            "UUID": "\(listingInput.idCopy!)"
        ]
        let encoded: Data = try encoder.encode(json)
        request.httpBody = encoded

        let (data, response) = try await URLSession.shared.data(for: request)
        // dont need to decode response, its not used at all
        let jsonResponse = try decoder.decode(HeartResponse.self, from: data)

        let httpResponse = response as! HTTPURLResponse

        if httpResponse.statusCode <= 299 {
            // 200-299 is a success
            print("sucess")
            return ""
        } else {
            print("\(jsonResponse)")
            return jsonResponse.message!
        }
    }
}

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

// {
// "UUID": "2E1337D7-82D4-4198-B614-43BE9264FE61",
// "username": "user321",
// "name": "Cozy Apt",
// "address": "123 College St",
// "price": 850,
// "distance": 0.5,
// "propertyType": ".apartment",
// "contactEmail": "example@gmail.com",
// "phoneNumber": "1234567890",
// "rating": 4,
// "comments": "I like this place"
// }
