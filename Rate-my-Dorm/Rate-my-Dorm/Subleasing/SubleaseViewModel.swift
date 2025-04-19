//
//  SubleaseViewModel.swift
//  Rate-my-Dorm
//
//  Created by Arya Venkatesan on 4/15/25.
//

import Foundation

@Observable class SubleaseViewModel: ObservableObject {
    var subleases: [Sublease] = []

    func addSublease(name: String, address: String, price: Double, distance: Double) {
        let new = Sublease(name: name, address: address, price: price, distance: distance)
        subleases.append(new)
    }
}

