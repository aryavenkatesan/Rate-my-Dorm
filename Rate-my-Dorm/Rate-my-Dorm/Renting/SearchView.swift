//
//  SearchView.swift
//  Rate-my-Dorm
//
//  Created by Arya Venkatesan on 4/15/25.
//

// I think you should implement the filters as a sheet and not a seperate view
// its up to you tho

import SwiftUI
import Observation

struct SearchView: View {
    @State private var viewModel = SubleaseViewModel()
    @State private var showAddSheet = false

    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section(header: Text("Available Subleases")) {
                        ForEach(viewModel.subleases) { sublease in
                            VStack(alignment: .leading) {
                                Text(sublease.name)
                                    .font(.headline)
                                Text(sublease.address)
                                Text("$\(Int(sublease.price)) · \(Int(sublease.distance)) mi")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                
                Button("Add New Sublease") {
                    showAddSheet = true
                }
                .padding()
                .sheet(isPresented: $showAddSheet) {
                    SubleaseView(viewModel: viewModel)
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
    BottomBarView()
}

