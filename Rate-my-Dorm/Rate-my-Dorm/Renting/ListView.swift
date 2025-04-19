//
//  ListView.swift
//  Rate-my-Dorm
//
//  Created by Arya Venkatesan on 4/15/25.
//
// RentModel.swift

// ListView.swift

import SwiftUI

struct ListView: View {
    @State private var rentViewModel = RentViewModel()

    var body: some View {
        NavigationView {
            List {
                ForEach(rentViewModel.subleases) { sublease in
                    VStack(alignment: .leading) {
                        Text(sublease.name)
                            .font(.headline)
                        Text(sublease.address)
                            .font(.subheadline)
                        HStack {
                            Text("$\(sublease.price, specifier: "%.2f") / month")
                            Spacer()
                            Text("\(sublease.distance, specifier: "%.1f") mi to campus")
                        }
                        .font(.caption)
                        .foregroundColor(.secondary)
                        Text("Type: \(sublease.propertyType.rawValue.capitalized)")
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Available Subleases")
        }
    }
}

#Preview {
    ListView()
}

