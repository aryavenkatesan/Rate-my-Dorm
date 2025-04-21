import Foundation
import Observation
import SwiftUI

@MainActor
class RentViewModel: ObservableObject {
    @Published var subleases: [Sublease] = [
        Sublease(creatorUsername: "user123", name: "Cozy Apt", address: "123 College St", price: 850, distance: 0.5, propertyType: .apartment, contactEmail: "contact@cozyapt.com", heartList: ["username"], phoneNumber: "123-456-7890"),
        Sublease(creatorUsername: "user123", name: "Dorm B12", address: "Dormitory Lane", price: 600, distance: 0.2, propertyType: .dorm, contactEmail: "dormb12@school.edu", heartList: ["username"], phoneNumber: "234-567-8901"),
        Sublease(creatorUsername: "user123", name: "Shared House", address: "789 Maple Ave", price: 950, distance: 1.2, propertyType: .house, contactEmail: "info@sharedhouse.com", heartList: ["username"], phoneNumber: "345-678-9012")
        ]
        
    @Published var newSubleaseName: String = ""
    @Published var newSubleaseAddress: String = ""
    @Published var newSubleasePrice: Double? = nil
    @Published var newSubleaseDistance: Double? = nil
    @Published var newSubleasePropertyType = PropertyType.apartment
    @Published var newSubleaseEmail: String = ""
    @Published var newSubleasePhoneNumber: String = ""
    @Published var newSubleaseRating: Int = 0
    @Published var newSubleaseComments: String = ""

    func add() {
        guard let price = newSubleasePrice, let distance = newSubleaseDistance else {
            print("Price or distance is nil. Cannot add sublease.")
            return
        }

        let newSublease = Sublease(
            creatorUsername: "ADD PROPER FUNCTIONALITY TO THIS SHOULDNT BE TOO DIFFICULT",
            name: newSubleaseName,
            address: newSubleaseAddress,
            price: newSubleasePrice!,
            distance: newSubleaseDistance!,
            propertyType: newSubleasePropertyType,
            contactEmail: "CHANGE THIS TO TEXTFIELD INPUT",
            heartList: [""],
            phoneNumber: newSubleasePhoneNumber,
            rating: newSubleaseRating,
            comments: newSubleaseComments)
        
        subleases.append(newSublease);
        
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

    func toggleLike(for sublease: Sublease) {
//        if let index = subleases.firstIndex(where: { $0.id == sublease.id }) {
//            subleases[index].liked.toggle()
//        }
    }
}
