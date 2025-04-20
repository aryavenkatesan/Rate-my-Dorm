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
            Sublease(name: "Cozy Apt", address: "123 College St", price: 850, distance: 0.5, propertyType: .apartment),
            Sublease(name: "Dorm B12", address: "Dormitory Lane", price: 600, distance: 0.2, propertyType: .dorm),
            Sublease(name: "Shared House", address: "789 Maple Ave", price: 950, distance: 1.2, propertyType: .house)
        ]
        
    @Published var newSubleaseName: String = ""
    @Published var newSubleaseAddress: String = ""
    @Published var newSubleasePrice: Double? = nil
    @Published var newSubleaseDistance:Double? = nil
    @Published var newSubleasePropertyType = PropertyType.apartment

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
            propertyType: newSubleasePropertyType
        )
        subleases.append(newSublease)
        
        resetSublease()
    }

    
    func resetSublease(){
        newSubleaseName = ""
        newSubleaseAddress = ""
        newSubleasePrice = nil
        newSubleaseDistance = nil
        newSubleasePropertyType = PropertyType.apartment
    }
       
    func toggleLike(for sublease: Sublease) {
        if let index = subleases.firstIndex(where: {$0.id == sublease.id}) {
            subleases[index].liked.toggle()
        }
    }
}
