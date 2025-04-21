import SwiftUI

struct SubleaseView: View {
    @ObservedObject var vm: SubleaseViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var statusMessage: String = ""
    @State private var statusMessageColor: Color = .clear

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Name, Address, Rent per month, and Distance from campus
                    Group {
                        SubleaseTextField(label: "Name", text: $vm.newSubleaseName)
                        SubleaseTextField(label: "Address", text: $vm.newSubleaseAddress)
                        SubleaseNumberTextField(label: "Rent per month", value: $vm.newSubleasePrice)
                        SubleaseNumberTextField(label: "Miles from campus", value: $vm.newSubleaseDistance)
                    }

                    // Email (Mandatory)
                    SubleaseTextField(label: "Email", text: $vm.newSubleaseEmail, keyboardType: .emailAddress)

                    // Phone Number (Mandatory)
                    SubleaseTextField(label: "Phone Number", text: $vm.newSubleasePhoneNumber, keyboardType: .phonePad)

                    // Comments (Optional)
                    SubleaseTextField(label: "Comments (optional)", text: Binding(
                        get: { vm.newSubleaseComments ?? "" },
                        set: { vm.newSubleaseComments = $0.isEmpty ? nil : $0 }
                    ), axis: .vertical)


                    // Type Picker
                    PropertyTypePicker(selectedType: $vm.newSubleasePropertyType)

                    // Add Sublease Button
                    AddSubleaseButton(vm: vm, statusMessage: $statusMessage, statusMessageColor: $statusMessageColor)

                    // Status Message
                    StatusMessageView(statusMessage: $statusMessage, statusMessageColor: $statusMessageColor)
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

struct SubleaseTextField: View {
    var label: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var axis: Axis = .horizontal

    var body: some View {
        TextField(label, text: $text, axis: axis)
            .keyboardType(keyboardType)
            .padding()
            .background(Color.blue.opacity(0.05))
            .cornerRadius(10)
    }
}

struct SubleaseNumberTextField: View {
    var label: String
    @Binding var value: Double?
    var keyboardType: UIKeyboardType = .decimalPad

    var body: some View {
        TextField("", value: $value, format: .number, prompt: Text(label))
            .keyboardType(keyboardType)
            .padding()
            .background(Color.blue.opacity(0.05))
            .cornerRadius(10)
    }
}

struct PropertyTypePicker: View {
    @Binding var selectedType: PropertyType

    var body: some View {
        VStack(alignment: .leading) {
            Text("Type")
                .font(.headline)
            Picker("Type", selection: $selectedType) {
                ForEach(PropertyType.allCases, id: \.self) { type in
                    Text(type.rawValue.capitalized).tag(type)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }
}


struct AddSubleaseButton: View {
    @ObservedObject var vm: SubleaseViewModel
    @Binding var statusMessage: String
    @Binding var statusMessageColor: Color

    var body: some View {
        Button("Add Sublease", action: {
            vm.add()
            // Set status message or handle error here
        })
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
    }
}

struct StatusMessageView: View {
    @Binding var statusMessage: String
    @Binding var statusMessageColor: Color

    var body: some View {
        if !statusMessage.isEmpty {
            Text(statusMessage)
                .foregroundColor(statusMessageColor)
                .padding()
        }
    }
}


#Preview {
    let previewvm1 = OnboardingViewModel()
    let previewvm2 = SubleaseViewModel()

    BottomBarView(onboardingVM: previewvm1, rentVM: previewvm2)
}
