//
//  BackendConnection.swift
//  Rate-my-Dorm
//
//  Created by Arya Venkatesan on 4/15/25.
//

import SwiftUI

enum BackendConnection {
    static let decoder = JSONDecoder()
    static let encoder = JSONEncoder()
    
    static let baseUrl = "https://rmd.aryav.systems:5001/"
    
    static func uploadListingAPIRequest(listingInput: Sublease, APIInfoBus: profileInfoForApi) async throws -> String {
        let workingUrl = baseUrl + "api/listing/create"
        guard let url = URL(string: workingUrl) else {
            fatalError("Invalid URL")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(APIInfoBus.jwt)", forHTTPHeaderField: "authorization")
        
        var json: ListingJSON
        var commentActual = listingInput.comments
        if listingInput.comments.count < 2 {
            commentActual = "No comments"
        }
        json = ListingJSON(
            UUID: "\(listingInput.id)",
            username: APIInfoBus.username,
            name: listingInput.name,
            address: listingInput.address,
            price: listingInput.price,
            distance: listingInput.distance,
            propertyType: ".\(listingInput.propertyType)",
            contactEmail: listingInput.contactEmail,
            phoneNumber: listingInput.phoneNumber,
            rating: Double(listingInput.rating),
            comments: commentActual,
            school: APIInfoBus.school
        )
        
        
        let encoded: Data = try encoder.encode(json)
        request.httpBody = encoded
        
        let (data, response) = try await URLSession.shared.data(for: request)
        let jsonResponse = try decoder.decode(HeartResponse.self, from: data)
        
        let httpResponse = response as! HTTPURLResponse
        if httpResponse.statusCode <= 299 {
            return ""
        }
        if httpResponse.statusCode == 401 {
            return "Unauthorized"
        }
        
        if jsonResponse.message != nil {
            // extra checks so the app doesn't crash
            return jsonResponse.message!
        } else {
            return ""
        }
    }
    
    static func getAllListingsAPIRequest(APIInfoBus: profileInfoForApi) async throws -> [Sublease] {
        // TODO: Implement
        let workingUrl = baseUrl + "api/listing"
        guard let url = URL(string: workingUrl) else {
            fatalError("Invalid URL")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(APIInfoBus.jwt)", forHTTPHeaderField: "authorization")
        
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
        
        if httpResponse.statusCode == 401 {
            return [Sublease(creatorUsername: "Unauthorized",
                             name: "Unauthorized",
                             address: "Unauthorized",
                             price: 123,
                             distance: 123,
                             propertyType: .apartment,
                             contactEmail: "Unauthorized",
                             heartList: ["Unauthorized"],
                             phoneNumber: "Unauthorized",
                             school: "Unauthorized")]
        }
        
        // this part should return the error string
        // realistically it won't throw so i'm leaving it
        // best practice says I should do extra legwork
        print("Error happened in getAllListingsAPIRequest")
        print("\(jsonResponse)")
        return []
    }
    
    static func flipHeartStatusAPIRequest(listingInput: Sublease, APIInfoBus: profileInfoForApi) async throws -> String {
        // TODO: Implement
        let workingUrl = baseUrl + "api/listing/heart"
        guard let url = URL(string: workingUrl) else {
            fatalError("Invalid URL")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(APIInfoBus.jwt)", forHTTPHeaderField: "authorization")
        
        let json: [String: String] = [
            "UUID": "\(listingInput.idCopy!)",
            "username": APIInfoBus.username
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
        } else if  httpResponse.statusCode == 401 {
            return "Unauthorized"
        } else {
            print("\(jsonResponse)")
            return jsonResponse.message!
        }
    }
    
    static func deleteAPIRequest(listingInput: Sublease, APIInfoBus: profileInfoForApi) async throws -> String {
        // TODO: Implement
        let workingUrl = baseUrl + "api/listing/"
        guard let url = URL(string: workingUrl) else {
            fatalError("Invalid URL")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(APIInfoBus.jwt)", forHTTPHeaderField: "authorization")
        
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
        } else if httpResponse.statusCode == 401 {
            return "Unauthorized"
        } else {
            print("\(jsonResponse)")
            return jsonResponse.message!
        }
    }
}
