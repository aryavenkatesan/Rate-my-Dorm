//
//  RentViewModel.swift
//  Rate-my-Dorm
//
//  Created by Arya Venkatesan on 4/15/25.
//
// RentViewModel.swift

import Foundation
import SwiftUI

@Observable
class RentViewModel {
    var subleases: [Sublease] = []

    init() {
        loadDummyData() // Optional: for testing
    }

    func loadDummyData() {
        subleases = [
            Sublease(name: "Cozy Apt", address: "123 College St", price: 850, distance: 0.5, propertyType: .apartment),
            Sublease(name: "Dorm B12", address: "Dormitory Lane", price: 600, distance: 0.2, propertyType: .dorm),
            Sublease(name: "Shared House", address: "789 Maple Ave", price: 950, distance: 1.2, propertyType: .house)
        ]
    }

    func add(_ sublease: Sublease) {
        subleases.append(sublease)
    }
}

