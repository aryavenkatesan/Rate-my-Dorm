//
//  SubleaseView.swift
//  Rate-my-Dorm
//
//  Created by Arya Venkatesan on 4/15/25.
//

import SwiftUI

struct SubleaseView: View {
    @ObservedObject var viewModel: SubleaseViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var name: String = ""
    @State private var address: String = ""
    @State private var price: String = ""
    @State private var distance: String = ""
    @State private var selectedType: PropertyType = .apartment

    // Debugging: Store the last action that was taken
    @State private var debugText: String = ""

    // Check if the form is valid
    var isFormValid: Bool {
        !name.isEmpty &&
        !address.isEmpty &&
        Double(price) != nil &&
        Double(distance) != nil
    }

    var body: some View {
        NavigationView {
            Form {
                // Sublease Info Section
                Section(header: Text("Sublease Info")) {
                    TextField("Name", text: $name)
                    TextField("Address", text: $address)
                    TextField("Price per month", text: $price)
                        .keyboardType(.decimalPad)
                    TextField("Distance (mi) to campus", text: $distance)
                        .keyboardType(.decimalPad)
                }

                // Property Type Section
                Section(header: Text("Property Type")) {
                    Picker("Type", selection: $selectedType) {
                        ForEach(PropertyType.allCases, id: \.self) { type in
                            Text(type.rawValue.capitalized).tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                // Add Sublease Button
                Section {
                    Button("Add Sublease") {
                        // Debugging: Print the form data to console
                        print("Adding Sublease with values - Name: \(name), Address: \(address), Price: \(price), Distance: \(distance), Type: \(selectedType)")
                        
                        // Try to add the sublease
                        if let priceVal = Double(price), let distanceVal = Double(distance) {
                            viewModel.addSublease(
                                name: name,
                                address: address,
                                price: priceVal,
                                distance: distanceVal,
                                propertyType: selectedType
                            )
                            debugText = "Sublease Added!" // Update debug message
                            print("Sublease successfully added!")
                            dismiss() // Dismiss the form after adding
                        } else {
                            // If the price or distance is invalid
                            debugText = "Invalid price or distance" // Show error if input is invalid
                            print("Failed to add sublease: Invalid price or distance") // Log failure message
                        }
                    }
                    .disabled(!isFormValid) // Disable button if the form is invalid
                }

                // Debugging: Show status
                Section {
                    Text(debugText) // Display the current debug text
                        .foregroundColor(debugText == "Sublease Added!" ? .green : .red)
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
