import Foundation
import Observation
import SwiftUI

@MainActor
class RentViewModel: ObservableObject {
//    @Published var subleases: [Sublease] = [
//        Sublease(creatorUsername: "user123", name: "Cozy Apt", address: "123 College St", price: 850, distance: 0.5, propertyType: .apartment, contactEmail: "contact@cozyapt.com", heartList: ["username"], phoneNumber: "123-456-7890"),
//        Sublease(creatorUsername: "user123", name: "Dorm B12", address: "Dormitory Lane", price: 600, distance: 0.2, propertyType: .dorm, contactEmail: "dormb12@school.edu", heartList: ["username"], phoneNumber: "234-567-8901"),
//        Sublease(creatorUsername: "user123", name: "Shared House", address: "789 Maple Ave", price: 950, distance: 1.2, propertyType: .house, contactEmail: "info@sharedhouse.com", heartList: ["username"], phoneNumber: "345-678-9012")
//        ]
    @Published var subleases: [Sublease] = []
        
    @Published var newSubleaseName: String = ""
    @Published var newSubleaseAddress: String = ""
    @Published var newSubleasePrice: Double? = nil
    @Published var newSubleaseDistance: Double? = nil
    @Published var newSubleasePropertyType = PropertyType.apartment
    @Published var newSubleaseEmail: String = ""
    @Published var newSubleasePhoneNumber: String = ""
    @Published var newSubleaseRating: Int = 0
    @Published var newSubleaseComments: String = ""

    func add(username: String) async {
        guard let price = newSubleasePrice, let distance = newSubleaseDistance else {
            print("Price or distance is nil. Cannot add sublease.")
            return
        }
        
        print("checkpoint1")
        let newSublease = Sublease(
            creatorUsername: username,
            name: newSubleaseName,
            address: newSubleaseAddress,
            price: newSubleasePrice!,
            distance: newSubleaseDistance!,
            propertyType: newSubleasePropertyType,
            contactEmail: newSubleaseEmail,
            heartList: [""],
            phoneNumber: newSubleasePhoneNumber,
            rating: newSubleaseRating,
            comments: newSubleaseComments)
        print("checkpoint2")
        
        
        do {
            print("checkpoint3")
            let response = try await ProfileModel.uploadListingAPIRequest(listingInput: newSublease, usernameActual: username)
                print("SKDJFLDHJS")
        } catch {
            print("Something went wrong 1")
        }
        
        resetSublease()
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

    func toggleLike(sublease: Sublease, username: String) async {
        for index in subleases.indices {
            if subleases[index].id == sublease.id {
                if subleases[index].heartList.contains(username) {
                    subleases[index].heartList.removeAll { $0 == username }
                } else {
                    subleases[index].heartList.append(username)
                }
            }
        }
        
        do {
            _ = try await ProfileModel.flipHeartStatusAPIRequest(listingInput: sublease, user: username)
//            await getAllSubleases()
            //let errmsg = response  This is not used
        } catch {
            print("Something went wrong 2")
        }
    }
    
    func getAllSubleases() async {
        do {
            let response = try await ProfileModel.getAllListingsAPIRequest()
            subleases = response
        } catch {
            print("Something went wrong 3")
        }
    }
    
    func getMyListings(username: String) async {
        Task {
            await getAllSubleases()
        }
        var output: [Sublease] = []
        for s in subleases{
            if (s.creatorUsername == username) {
                output.append(s)
            }
        }
        subleases = output
    }
    
    func getMyHeartListings(username: String) async {
        Task {
            await getAllSubleases()
        }
        var output: [Sublease] = []
        for s in subleases{
            if (s.heartList.contains(username)) {
                output.append(s)
            }
        }
        subleases = output
    }
    
    func deleteListing(sublease: Sublease) async {
        do {
            let errmsg = try await ProfileModel.deleteAPIRequest(listingInput: sublease)
            
        } catch {
            print("Something went wrong 4")
        }
    }
}
