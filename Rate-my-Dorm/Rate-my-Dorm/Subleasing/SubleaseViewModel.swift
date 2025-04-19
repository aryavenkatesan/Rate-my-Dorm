//
//  SubleaseViewModel.swift
//  Rate-my-Dorm
//
//  Created by Arya Venkatesan on 4/15/25.
//

import Foundation
import SwiftUI

@Observable
class SubleaseViewModel {
    @Binding var subleases: [Sublease]

    func addSublease(name: String, address: String, price: Double, distance: Double, propertyType: PropertyType) {
        let new = Sublease(name: name, address: address, price: price, distance: distance, propertyType: propertyType)
        subleases.append(new)
    }
}

