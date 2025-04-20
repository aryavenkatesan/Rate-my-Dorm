//
//  SubleaseView.swift
//  Rate-my-Dorm
//
//  Created by Arya Venkatesan on 4/15/25.
//

import SwiftUI

struct SubleaseView: View {
    @StateObject private var viewModel = SubleaseViewModel()

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("New Sublease")) {
                    TextField("Name", text: $viewModel.name)
                    TextField("Address", text: $viewModel.address)
                    TextField("Price", text: $viewModel.price)
                        .keyboardType(.decimalPad)
                    TextField("Distance (mi)", text: $viewModel.distance)
                        .keyboardType(.decimalPad)
                    
                    Button("Add Sublease") {
                        viewModel.addSublease()
                    }
                }

                Section(header: Text("Subleases")) {
                    ForEach(viewModel.subleases) { sublease in
                        VStack(alignment: .leading) {
                            Text(sublease.name)
                                .font(.headline)
                            Text(sublease.address)
                            Text("$\(Int(sublease.price)) · \(Int(sublease.distance)) mi")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Subleases")
        }
    }
}


#Preview {
    let previewvm = OnboardingViewModel()

    BottomBarView(onboardingVM: previewvm)
    
}
