import SwiftUI

struct SubleaseView: View {
    @State private var viewModel = SubleaseViewModel()
    @State private var rentViewModel = RentViewModel()
    @Environment(\.dismiss) private var dismiss

    @State private var name: String = ""
    @State private var address: String = ""
    @State private var price: String = ""
    @State private var distance: String = ""
    @State private var selectedType: PropertyType = .apartment

    // Store the status of the operation (success or error)
    @State private var statusMessage: String = ""
    @State private var statusMessageColor: Color = .clear

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
                        // Validate and add the sublease
                        if let priceVal = Double(price), let distanceVal = Double(distance) {
                            // Update the UI with success message
                            let sublease = Sublease(
                                name: name, address: address, price: priceVal, distance: distanceVal, propertyType: selectedType
                                                    )
                            viewModel.addSublease(
                                name: name,
                                address: address,
                                price: priceVal,
                                distance: distanceVal,
                                propertyType: selectedType
                            )
                            rentViewModel.add(sublease)
                            
                            statusMessage = "Sublease Added Successfully!" // Success message
                            statusMessageColor = .green // Green for success
                            dismiss() // Dismiss the form after adding
                        } else {
                            // Update the UI with error message
                            statusMessage = "Invalid price or distance. Please check your inputs."
                            statusMessageColor = .red // Red for error
                        }
                    }
                    .disabled(!isFormValid) // Disable the button if the form is invalid
                }

                // Status message Section
                Section {
                    Text(statusMessage) // Display the status message
                        .foregroundColor(statusMessageColor) // Show message in corresponding color
                        .padding()
                        .font(.body)
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
    SubleaseView()
}
