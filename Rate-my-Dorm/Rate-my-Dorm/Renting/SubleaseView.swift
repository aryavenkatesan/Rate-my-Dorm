import SwiftUI

struct SubleaseView: View {
    @ObservedObject var vm: RentViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var statusMessage: String = ""
    @State private var statusMessageColor: Color = .clear

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Name, Address, Rent per month, and Distance from campus
                    Group {
                        TextField("Name", text: $vm.newSubleaseName)
                        TextField("Address", text: $vm.newSubleaseAddress)
                        TextField("",
                                  value: $vm.newSubleasePrice,
                                  format: .number,
                                  prompt: Text("Rent per month"))
                            .keyboardType(.decimalPad)
                        TextField("",
                                  value: $vm.newSubleaseDistance,
                                  format: .number,
                                  prompt: Text("Miles from campus"))
                            .keyboardType(.decimalPad)
                    }
                    .padding()
                    .background(Color.blue.opacity(0.05))
                    .cornerRadius(10)
                    
                    // Email (Mandatory)
                    TextField("Email", text: $vm.newSubleaseEmail)
                        .keyboardType(.emailAddress)
                        .padding()
                        .background(Color.blue.opacity(0.05))
                        .cornerRadius(10)

                    // Phone Number (Mandatory)
                    TextField("Phone Number", text: $vm.newSubleasePhoneNumber)
                        .keyboardType(.phonePad)
                        .padding()
                        .background(Color.blue.opacity(0.05))
                        .cornerRadius(10)

                    // Comments (Optional)
                    TextField("Comments (optional)", text: $vm.newSubleaseComments, axis: .vertical)
                        .padding()
                        .background(Color.blue.opacity(0.05))
                        .cornerRadius(10)

                    // Type Picker
                    Text("Type")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Picker("Type", selection: $vm.newSubleasePropertyType) {
                        ForEach(PropertyType.allCases, id: \.self) { type in
                            Text(type.rawValue.capitalized).tag(type)
                        }
                    }
                    .pickerStyle(.segmented)

                    // Rating Picker (Optional)
                    Text("Rating")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    HStack {
                        ForEach(1...5, id: \.self) { star in
                            Image(systemName: vm.newSubleaseRating >= star ? "star.fill" : "star")
                                .foregroundColor(.yellow)
                                .onTapGesture {
                                    if vm.newSubleaseRating == star {
                                        vm.newSubleaseRating = 0
                                    } else {
                                        vm.newSubleaseRating = star
                                    }
                                }
                        }
                    }

                    // Add Sublease Button
                    Button("Add Sublease", action: vm.add)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .disabled(
                            vm.newSubleaseName.isEmpty ||
                            vm.newSubleaseAddress.isEmpty ||
                            vm.newSubleaseEmail.isEmpty ||
                            vm.newSubleasePhoneNumber.isEmpty ||
                            vm.newSubleasePrice == nil ||
                            vm.newSubleaseDistance == nil
                        )

                    // Status Message
                    if !statusMessage.isEmpty {
                        Text(statusMessage)
                            .foregroundColor(statusMessageColor)
                            .padding()
                    }
                }
                .padding()
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
    let previewvm1 = OnboardingViewModel()
    let previewvm2 = RentViewModel()

    BottomBarView(onboardingVM: previewvm1, rentVM: previewvm2)
}
