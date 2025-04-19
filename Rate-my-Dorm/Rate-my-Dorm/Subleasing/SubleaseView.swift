//
//  SubleaseView.swift
//  Rate-my-Dorm
//
//  Created by Arya Venkatesan on 4/15/25.
//

import SwiftUI

struct SubleaseView: View {
    @State var viewModel: SubleaseViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String = ""
    @State private var address: String = ""
    @State private var price: String = ""
    @State private var distance: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Sublease Info")) {
                    TextField("Name", text: $name)
                    TextField("Address", text: $address)
                    TextField("Price", text: $price)
                        .keyboardType(.decimalPad)
                    TextField("Distance (mi)", text: $distance)
                        .keyboardType(.decimalPad)
                }

                Button("Add Sublease") {
                    if let priceVal = Double(price), let distanceVal = Double(distance) {
                        viewModel.addSublease(
                            name: name,
                            address: address,
                            price: priceVal,
                            distance: distanceVal
                        )
                        dismiss()
                    }
                }
            }
            .navigationTitle("New Sublease")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}



#Preview {
    SubleaseView(viewModel: SubleaseViewModel())
}
