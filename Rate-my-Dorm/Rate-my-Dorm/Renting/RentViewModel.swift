//
//  RentViewModel.swift
//  Rate-my-Dorm
//
//  Created by Arya Venkatesan on 4/15/25.
//

import Foundation
import Observation
import SwiftUI

@MainActor
class RentViewModel: ObservableObject {
    @Published var subleases: [Sublease] = [
        Sublease(creatorUsername: "user123", name: "Cozy Apt", address: "123 College St", price: 850, distance: 0.5, propertyType: .apartment, contactEmail: "example@gmail.com", heartList: ["username"]),
        Sublease(creatorUsername: "user123", name: "Dorm B12", address: "Dormitory Lane", price: 600, distance: 0.2, propertyType: .dorm, contactEmail: "example@gmail.com", heartList: ["username"]),
        Sublease(creatorUsername: "user123", name: "Shared House", address: "789 Maple Ave", price: 950, distance: 1.2, propertyType: .house, contactEmail: "example@gmail.com", heartList: ["username"])
        ]
        
    @Published var newSubleaseName: String = ""
    @Published var newSubleaseAddress: String = ""
    @Published var newSubleasePrice: Double = 0.0
    @Published var newSubleaseDistance:Double = 0.0
    @Published var newSubleasePropertyType = PropertyType.apartment

    func add() {
        let newSublease = Sublease(creatorUsername: "ADD PROPER FUNCTIONALITY TO THIS SHOULDNT BE TOO DIFFICULT", name: newSubleaseName, address: newSubleaseAddress, price: newSubleasePrice, distance: newSubleaseDistance, propertyType: newSubleasePropertyType, contactEmail: "CHANGE THIS TO TEXTFIELD INPUT", heartList: [""])
        subleases.append(newSublease);
        
        resetSublease()
    }
    
    func resetSublease(){
        newSubleaseName = ""
        newSubleaseAddress = ""
        newSubleasePrice = 0.0
        newSubleaseDistance = 0.0
        newSubleasePropertyType = PropertyType.apartment
    }
       
}
