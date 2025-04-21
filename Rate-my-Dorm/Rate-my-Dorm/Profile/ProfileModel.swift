//
//  ProfileModel.swift
//  Rate-my-Dorm
//
//  Created by Arya Venkatesan on 4/15/25.
//

import SwiftUI

struct ProfileModel {
    static let decoder = JSONDecoder()
    static let encoder = JSONEncoder()

    static let baseUrl = "http://localhost:5001/"
    
    static func uploadListingAPIRequest(listingInput: Sublease, usernameActual: String) async throws -> String {
        // TODO: Implement
        let workingUrl = baseUrl + "api/listing"
        guard let url = URL(string: workingUrl) else {
            fatalError("Invalid URL")
        }

        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "POST"

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        /*
         ****** IMPORTANT IMPORTANT ******
         CREATE A NEW FIELD FOR CONTACT EMAIL SO I CAN PASS IT TO THE API REQUEST
         */

        let json = ListingJSON(
            UUID: "\(listingInput.id)",
            username: usernameActual,
            name: listingInput.name,
            address: listingInput.address,
            price: listingInput.price,
            distance: listingInput.distance,
            propertyType: "\(listingInput.propertyType)",
            contactEmail: "FIX THIS FIX THIS FIX THIS", //listingInput.email
            heartList: [""]
        )
//        let jsonold: [String: Any] = [
//            "UUID": "\(listingInput.id)",
//            "username": usernameActual,
//            "name": listingInput.name,
//            "address": listingInput.address,
//            "price": listingInput.price,
//            "distance": listingInput.distance,
//            "propertyType": "\(listingInput.propertyType)",
//            "contactEmail": "FIX THIS FIX THIS FIX THIS",//listingInput.email
//        ]
        let encoded: Data = try encoder.encode(json)
        request.httpBody = encoded
        
        let (data, response) = try await URLSession.shared.data(for: request)
        let jsonResponse = try decoder.decode(ListingResponseJSON.self, from: data)
        
        let httpResponse = response as! HTTPURLResponse
        if httpResponse.statusCode <= 299 {
            return ""
        }
        
        if (jsonResponse.message != nil) {
            //extra checks so the app doesn't crash
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

        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "GET"

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        let jsonResponse = try decoder.decode([ListingJSON].self, from: data)
        
        var output: [Sublease] = []
        
        for listing in jsonResponse {
            var PType: PropertyType
            switch (listing.propertyType){
            case("apartment"):
                PType = PropertyType.apartment
            case("dorm"):
                PType = PropertyType.dorm
            default:
                PType = PropertyType.house
                
            }
            let oneListing: Sublease = Sublease(creatorUsername: listing.username, name: listing.name, address: listing.address, price: listing.price, distance: listing.distance, propertyType: PType, contactEmail: listing.contactEmail, heartList: listing.heartList)
            output.append(oneListing)
        }
        
        let httpResponse = response as! HTTPURLResponse
        
        if httpResponse.statusCode <= 299 {
            //200-299 is a success
            return output
        }
        
        //this part should return the error string
        //realistically it won't throw so i'm leaving it
        //best practice says I should do extra legwork
        print("Error happened in getAllListingsAPIRequest")
        return output
    }
    
    static func flipHeartStatusAPIRequest(listingInput: Sublease) async throws -> String {
        // TODO: Implement
        let workingUrl = baseUrl + "api/listing/:id=\(listingInput.id)"
        guard let url = URL(string: workingUrl) else {
            fatalError("Invalid URL")
        }

        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "POST"

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let json: [String: String] = [
            "username": listingInput.creatorUsername
        ]
        let encoded: Data = try encoder.encode(json)
        request.httpBody = encoded
        
        let (data, response) = try await URLSession.shared.data(for: request)
        let jsonResponse = try decoder.decode(ListingResponseJSON.self, from: data)
        
        let httpResponse = response as! HTTPURLResponse
        
        if httpResponse.statusCode <= 299 {
            //200-299 is a success
            return ""
        } else {
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
    let heartList: [String]
}
