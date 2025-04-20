//
//  SearchView.swift
//  Rate-my-Dorm
//
//  Created by Arya Venkatesan on 4/15/25.
//

// I think you should implement the filters as a sheet and not a seperate view
// its up to you tho

import SwiftUI

struct SearchView: View {
    @State private var name: String = ""
    @State private var location: String = ""
    @State private var showFilters: Bool = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Search Criteria")) {
                    TextField("Name", text: $name)
                    TextField("Location", text: $location)
                }

                Section {
                    Button("Filters") {
                        showFilters.toggle()
                    }
                    .sheet(isPresented: $showFilters) {
                        FilterSheetView()
                    }

                    Button("Search") {
                        // Perform search logic here
                        print("Searching for \(name) in \(location)")
                    }
                }
            }
            .navigationTitle("Search")
        }
    }
}

struct FilterSheetView: View {
    @Environment(\.dismiss) var dismiss

    @State private var maxDistance: Double = 10
    @State private var maxPrice: Double = 1500
    @State private var selectedType: PropertyType = .apartment

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Distance (mi)")) {
                    Slider(value: $maxDistance, in: 1...50, step: 1) {
                        Text("Max Distance")
                    }
                    Text("\(Int(maxDistance)) miles")
                }

                Section(header: Text("Max Price ($/mo)")) {
                    Slider(value: $maxPrice, in: 200...5000, step: 50) {
                        Text("Max Price")
                    }
                    Text("$\(Int(maxPrice))")
                }

                Section(header: Text("Type")) {
                    Picker("Property Type", selection: $selectedType) {
                        ForEach(PropertyType.allCases, id: \.self) { type in
                            Text(type.rawValue.capitalized).tag(type)
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

enum PropertyType: String, CaseIterable {
    case apartment
    case dorm
    case house
}


#Preview {
    let previewvm = OnboardingViewModel()

    BottomBarView(onboardingVM: previewvm)
    
}

