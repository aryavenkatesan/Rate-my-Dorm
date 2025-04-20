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

                    Text("Type")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Picker("Type", selection: $vm.newSubleasePropertyType) {
                        ForEach(PropertyType.allCases, id: \.self) { type in
                            Text(type.rawValue.capitalized).tag(type)
                        }
                    }
                    .pickerStyle(.segmented)

                    Button("Add Sublease", action: vm.add)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .disabled(
                            vm.newSubleaseName.isEmpty ||
                            vm.newSubleaseAddress.isEmpty ||
                            vm.newSubleasePrice == nil ||
                            vm.newSubleaseDistance == nil
                        )


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
