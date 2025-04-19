import SwiftUI

struct SubleaseView: View {
    @State private var viewModel = RentViewModel()
    @Environment(\.dismiss) private var dismiss

    @State private var name: String = ""
    @State private var address: String = ""
    @State private var price: String = ""
    @State private var distance: String = ""
    @State private var selectedType: PropertyType = .apartment
    @State private var statusMessage: String = ""
    @State private var statusMessageColor: Color = .clear

    var isFormValid: Bool {
        !name.isEmpty && !address.isEmpty &&
        Double(price) != nil && Double(distance) != nil
    }

    var body: some View {
        NavigationView {
            Form {
                // Input sections here ...

                Section {
                    Button("Add Sublease") {
                        if let priceVal = Double(price), let distanceVal = Double(distance) {
                            let sublease = Rent(
                                name: name,
                                address: address,
                                price: priceVal,
                                distance: distanceVal,
                                propertyType: selectedType
                            )

                            viewModel.add(sublease)
                            statusMessage = "Sublease Added Successfully!"
                            statusMessageColor = .green
                            dismiss()
                        } else {
                            statusMessage = "Invalid price or distance."
                            statusMessageColor = .red
                        }
                    }
                    .disabled(!isFormValid)
                }

                Section {
                    Text(statusMessage)
                        .foregroundColor(statusMessageColor)
                        .padding()
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
