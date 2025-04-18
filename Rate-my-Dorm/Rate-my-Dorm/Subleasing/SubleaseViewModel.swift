//
//  SubleaseViewModel.swift
//  Rate-my-Dorm
//
//  Created by Arya Venkatesan on 4/15/25.
//

import Foundation

class SubleaseViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var address: String = ""
    @Published var price: String = ""
    @Published var distance: String = ""
    
    @Published var subleases: [Sublease] = []

    func addSublease() {
        guard let priceVal = Double(price),
              let distanceVal = Double(distance),
              !name.isEmpty,
              !address.isEmpty else {
            return // Handle validation errors as needed
        }

        let newSublease = Sublease(name: name, address: address, price: priceVal, distance: distanceVal)
        subleases.append(newSublease)
        
        // Reset fields after adding
        name = ""
        address = ""
        price = ""
        distance = ""
    }
}
