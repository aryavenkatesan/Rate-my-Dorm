//
//  RentViewModel.swift
//  Rate-my-Dorm
//
//  Created by Arya Venkatesan on 4/15/25.
//

import Foundation
import SwiftUI

@Observable
class RentViewModel {
    public var rents: [Rent] = []

    init() {
        loadDummyData() // Optional: for testing
    }

    func loadDummyData() {
        rents = [
            Rent(name: "Cozy Apt", address: "123 College St", price: 850, distance: 0.5, propertyType: .apartment),
            Rent(name: "Dorm B12", address: "Dormitory Lane", price: 600, distance: 0.2, propertyType: .dorm),
            Rent(name: "Shared House", address: "789 Maple Ave", price: 950, distance: 1.2, propertyType: .house)
        ]
        
        //add(Rent(name: "Dorm B12", address: "Dormitory Lane", price: 600, distance: 0.2, propertyType: .dorm))
        //Test code
    }

    func add(_ rent: Rent) {
        rents.append(rent)
    }
}
