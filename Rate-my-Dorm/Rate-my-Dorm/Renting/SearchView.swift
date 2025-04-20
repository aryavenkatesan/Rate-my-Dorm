//
//  SearchView.swift
//  Rate-my-Dorm
//
//  Created by Arya Venkatesan on 4/15/25.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var vm: RentViewModel
    @State private var showFilterSheet = false

    @State private var searchText: String = ""
    @State private var maxPrice: Double = 5000
    @State private var maxDistance: Double = 50
    @State private var selectedType: PropertyType? = nil

    @State private var showResults: Bool = false

    var filteredSubleases: [Sublease] {
        vm.subleases.filter { sublease in
            (searchText.isEmpty ||
             sublease.name.localizedCaseInsensitiveContains(searchText) ||
             sublease.address.localizedCaseInsensitiveContains(searchText)) &&
            sublease.price <= maxPrice &&
            sublease.distance <= maxDistance &&
            (selectedType == nil || sublease.propertyType == selectedType!)
        }
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 12) {
                VStack(spacing: 8) {
                    // Search field
                    TextField("Search by name or address", text: $searchText)
                        .padding(8)
                        .background(Color.blue.opacity(0.05))
                        .cornerRadius(10)

                    // Filter + Search buttons
                    HStack {
                        Button("Filters") {
                            showFilterSheet = true
                        }
                        .font(.system(size:17))
                        .sheet(isPresented: $showFilterSheet) {
                            FilterSheetView(
                                maxPrice: $maxPrice,
                                maxDistance: $maxDistance,
                                selectedType: $selectedType
                            )
                        }

                        Spacer()

                        Button("Search") {
                            showResults = true
                        }
                        .buttonStyle(.borderedProminent)
                        .font(.system(size: 17, weight:.bold))
                    }
                }
                .padding(.horizontal) // Shared padding aligns everything

                // Search results
                if showResults {
                    List {
                        if filteredSubleases.isEmpty {
                            Text("No results found.")
                                .foregroundColor(.gray)
                        } else {
                            ForEach(filteredSubleases) { sublease in
                                VStack(alignment: .leading) {
                                    Text(sublease.name).font(.headline)
                                    Text(sublease.address)
                                    Text("$\(Int(sublease.price)) · \(Int(sublease.distance)) mi")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                }

                Spacer()
            }
            .navigationTitle("Search")
        }
    }
}

private struct FilterSheetView: View {
    @Environment(\.dismiss) var dismiss

    @Binding var maxPrice: Double
    @Binding var maxDistance: Double
    @Binding var selectedType: PropertyType?

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Max Price ($/mo)")) {
                    Slider(value: $maxPrice, in: 200...5000, step: 50)
                    Text("$\(Int(maxPrice))")
                }

                Section(header: Text("Max Distance (mi)")) {
                    Slider(value: $maxDistance, in: 1...50, step: 1)
                    Text("\(Int(maxDistance)) miles")
                }

                Section(header: Text("Property Type")) {
                    Picker("Type", selection: $selectedType) {
                        Text("Any").tag(PropertyType?.none)
                        ForEach(PropertyType.allCases, id: \.self) { type in
                            Text(type.rawValue.capitalized).tag(Optional(type))
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
            .navigationTitle("Filters")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
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

