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
                  TextField("Address", text: $vm.newSubleaseAddress)

                  // use `format:` not `formatter:`
                  TextField("Price",
                            value: $vm.newSubleasePrice, format: .number)
                    .keyboardType(.decimalPad)

                  TextField("Distance (mi)",
                            value: $vm.newSubleaseDistance,
                            format: .number)
                    .keyboardType(.decimalPad)

                  Picker("Type", selection: $vm.newSubleasePropertyType) {
                    ForEach(PropertyType.allCases, id:\.self) {
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
            .navigationTitle("New Sublease")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                        for s in vm.subleases {
                            print(s.id)                        }
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
