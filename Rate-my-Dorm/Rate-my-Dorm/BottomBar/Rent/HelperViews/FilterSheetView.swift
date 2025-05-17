//
//  FilterSheetView.swift
//  Rate-my-Dorm
//
//  Created by Arya Venkatesan on 5/16/25.
//

import SwiftUI

struct FilterSheetView: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var maxPrice: Double
    @Binding var maxDistance: Double
    @Binding var selectedType: PropertyType?
    @Binding var minRating: Int // Added for rating filter
    
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
                
                Section(header: Text("Minimum Rating")) {
                    HStack {
                        ForEach(1...5, id: \.self) { star in
                            Image(systemName: minRating >= star ? "star.fill" : "star")
                                .foregroundColor(.yellow)
                                .onTapGesture {
                                    if minRating == star {
                                        minRating = 0
                                    } else {
                                        minRating = star
                                    }
                                }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
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
