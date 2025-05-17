import Foundation
import Observation
import SwiftUI

@MainActor
class RentViewModel: ObservableObject {
    @Published var subleases: [Sublease] = [
        Sublease(creatorUsername: "user123", name: "Union Apts", address: "425 Hillsborough Street, Chapel Hill, NC, 27514", price: 850, distance: 0.9, propertyType: .apartment, contactEmail: "contact@union.com", heartList: ["username"], phoneNumber: "123-456-7890", school: "UNC Chapel Hill"),
        Sublease(creatorUsername: "user123", name: "Ram Village 1", address: "560 Paul Hardin Dr, Chapel Hill, NC, 27514", price: 950, distance: 0.6, propertyType: .dorm, contactEmail: "dorm@unc.edu", heartList: ["username"], phoneNumber: "234-567-8901", school: "UNC Chapel Hill"),
        Sublease(creatorUsername: "user123", name: "Horace Williams House", address: "610 E Rosemary St, Chapel Hill, NC, 27514", price: 950, distance: 0.7, propertyType: .house, contactEmail: "info@horacehouse.com", heartList: ["username"], phoneNumber: "345-678-9012", school: "UNC Chapel Hill")
    ] //fake data that gets rewritten
    
    @Published var newSubleaseName: String = ""
    @Published var newSubleaseAddress: String = ""
    @Published var newSubleasePrice: Double? = nil
    @Published var newSubleaseDistance: Double? = nil
    @Published var newSubleasePropertyType = PropertyType.apartment
    @Published var newSubleaseEmail: String = ""
    @Published var newSubleasePhoneNumber: String = ""
    @Published var newSubleaseRating: Int = 0
    @Published var newSubleaseComments: String = ""
    var initializeProfileSubcards: Bool = true
    var APIInfoBus: profileInfoForApi = profileInfoForApi(username: "", school: "", jwt: "")
    var timeoutCallback: (() -> Void) = {
        print("Default timeout handler - no action taken")
    }
    
    func add() async { //APIInfoBus: profileInfoForApi
        guard let price = newSubleasePrice, let distance = newSubleaseDistance else { //change this to be better
            print("Price or distance is nil. Cannot add sublease.")
            return
        }
        
        let newSublease = Sublease(
            creatorUsername: APIInfoBus.username,
            name: newSubleaseName,
            address: newSubleaseAddress,
            price: newSubleasePrice!,
            distance: newSubleaseDistance!,
            propertyType: newSubleasePropertyType,
            contactEmail: newSubleaseEmail,
            heartList: [""],
            phoneNumber: newSubleasePhoneNumber,
            rating: newSubleaseRating,
            comments: newSubleaseComments,
            school: APIInfoBus.school)
        
        do {
            resetSublease()
            let response = try await BackendConnection.uploadListingAPIRequest(listingInput: newSublease, APIInfoBus: APIInfoBus)
            if response == "unauthorized" {
                timeoutCallback()
            }
        } catch {
            print("Something went wrong 1")
        }
    }
    
    func resetSublease() {
        newSubleaseName = ""
        newSubleaseAddress = ""
        newSubleasePrice = nil
        newSubleaseDistance = nil
        newSubleasePropertyType = PropertyType.apartment
        newSubleaseEmail = ""
        newSubleasePhoneNumber = ""
        newSubleaseRating = 0
        newSubleaseComments = ""
    }
    
    func toggleLike(sublease: Sublease) async {
        for index in subleases.indices {
            if subleases[index].id == sublease.id {
                if subleases[index].heartList.contains(APIInfoBus.username) {
                    subleases[index].heartList.removeAll { $0 == APIInfoBus.username }
                } else {
                    subleases[index].heartList.append(APIInfoBus.username)
                }
            }
        }
        
        do {
            let response = try await BackendConnection.flipHeartStatusAPIRequest(listingInput: sublease, APIInfoBus: APIInfoBus)
            if response == "Unauthorized" {
                timeoutCallback()
            }
        } catch {
            print("Something went wrong 2")
        }
    }
    
    func getAllSubleases() async {
        do {
            let response = try await BackendConnection.getAllListingsAPIRequest(APIInfoBus: APIInfoBus)
            
            do {
                // Check if array has elements and safely access the first one
                if let firstResponse = response.first, firstResponse.name == "Unauthorized" {
                    timeoutCallback()
                }
            } catch {
                // Silent error handling
            }
            
            
            var output: [Sublease] = []
            
            //Change this to do sorting within the database to make it faster and less glitchy
            for s in response {
                // filter for only currently selected school
                if s.school == APIInfoBus.school {
                    output.append(s)
                }
            }
            
            subleases = output
        } catch {
            print("Something went wrong 3")
        }
    }
    
    func getMyListings() async {
        Task {
            await getAllSubleases()
        }
        var output: [Sublease] = []
        for s in subleases {
            if s.creatorUsername == APIInfoBus.username {
                output.append(s)
            }
        }
        subleases = output
    }
    
    func getMyHeartListings() async {
        Task {
            await getAllSubleases()
        }
        var output: [Sublease] = []
        for s in subleases {
            if s.heartList.contains(APIInfoBus.username) {
                output.append(s)
            }
        }
        subleases = output
    }
    
    func deleteListing(sublease: Sublease) async {
        do {
            let errmsg = try await BackendConnection.deleteAPIRequest(listingInput: sublease, APIInfoBus: APIInfoBus)
            if errmsg == "Unauthorized" {
                timeoutCallback()
            }
            print(errmsg)
            
        } catch {
            print("Something went wrong 4")
        }
    }
    
    func allowProfileSubcardInit() {
        initializeProfileSubcards = true
    }
}
