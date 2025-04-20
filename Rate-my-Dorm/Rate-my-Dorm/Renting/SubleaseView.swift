import SwiftUI

struct SubleaseView: View {
    @ObservedObject var vm: RentViewModel
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
                Section(header: Text("Sublease Info")) {
                    TextField("Name", text: $vm.newSubleaseName)
                        .padding(6)
                        .background(Color.blue.opacity(0.05))
                        .cornerRadius(8)

                    TextField("Address", text: $vm.newSubleaseAddress)
                        .padding(6)
                        .background(Color.blue.opacity(0.05))
                        .cornerRadius(8)

                    TextField("",
                              value: $vm.newSubleasePrice,
                              format: .number,
                              prompt: Text("Rent per month"))
                        .keyboardType(.decimalPad)
                        .padding(6)
                        .background(Color.blue.opacity(0.05))
                        .cornerRadius(8)

                    TextField("",
                              value: $vm.newSubleaseDistance,
                              format: .number,
                              prompt: Text("Miles from campus"))
                        .keyboardType(.decimalPad)
                        .padding(6)
                        .background(Color.blue.opacity(0.05))
                        .cornerRadius(8)

                    Picker("Type", selection: $vm.newSubleasePropertyType) {
                        ForEach(PropertyType.allCases, id: \.self) {
                            Text($0.rawValue.capitalized)
                        }
                    }
                }
                

                Section {
                    Button("Add Sublease", action: vm.add)
                        .disabled(vm.newSubleaseName.isEmpty || vm.newSubleaseAddress.isEmpty)
                }

                Section {
                    Text(statusMessage)
                        .foregroundColor(statusMessageColor)
                        .padding()
                }
            }
            .scrollContentBackground(.hidden)
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

    BottomBarView(onboardingVM: previewvm1, rentVM: RentViewModel())
}
