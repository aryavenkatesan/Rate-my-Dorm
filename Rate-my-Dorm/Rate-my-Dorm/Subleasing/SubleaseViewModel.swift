import Foundation
import Observation
import SwiftUI

@MainActor
class SubleaseViewModel: ObservableObject {
    @Published var subleases: [Sublease] = [
        Sublease(name: "Cozy Apt", address: "123 College St", price: 850, distance: 0.5, propertyType: .apartment, email: "contact@cozyapt.com", phoneNumber: "123-456-7890"),
        Sublease(name: "Dorm B12", address: "Dormitory Lane", price: 600, distance: 0.2, propertyType: .dorm, email: "dormb12@school.edu", phoneNumber: "234-567-8901"),
        Sublease(name: "Shared House", address: "789 Maple Ave", price: 950, distance: 1.2, propertyType: .house, email: "info@sharedhouse.com", phoneNumber: "345-678-9012")
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
    
    //For reviews
    @Published var currentSubleaseForRating: Sublease? = nil
    @Published var currentSubleaseForReview: Sublease? = nil
    @Published var showRatingSheet: Bool = false
    @Published var showReviewSheet: Bool = false

    
    func add() {
        guard let price = newSubleasePrice, let distance = newSubleaseDistance else {
            print("Price or distance is nil. Cannot add sublease.")
            return
        }
        
        let newSublease = Sublease(
            name: newSubleaseName,
            address: newSubleaseAddress,
            price: price,
            distance: distance,
            propertyType: newSubleasePropertyType,
            email: newSubleaseEmail,
            phoneNumber: newSubleasePhoneNumber,
            rating: newSubleaseRating,
            comments: newSubleaseComments
        )
        subleases.append(newSublease)
        
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
        if let index = subleases.firstIndex(where: { $0.id == sublease.id }) {
            subleases[index].liked.toggle()
        }
    }
    
    func addReview(for sublease: Sublease, rating: Int, comment: String) {
        guard let index = subleases.firstIndex(where: { $0.id == sublease.id }) else { return }

        let review = Review(rating: rating, comment: comment, date: Date())
        subleases[index].reviews.append(review)

        // Optional: update average rating
        let total = subleases[index].reviews.reduce(0) { $0 + $1.rating }
        let avg = Double(total) / Double(subleases[index].reviews.count)
        subleases[index].rating = Int(round(avg))

        // Also update main comment if empty
        if subleases[index].comments.isEmpty {
            subleases[index].comments = comment
        }
    }

}
