//
//  BottomBar.swift
//  Rate-my-Dorm
//
//  Created by Arya Venkatesan on 4/16/25.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case Sublease = "house"
    case Rent = "key"
    case Profile = "person"
    
    var tabName: String {
        switch self {
        case .Sublease:
            return "Sublease"
        case .Rent:
            return "Rent"
        case .Profile:
            return "Profile"
        }
    }
}
