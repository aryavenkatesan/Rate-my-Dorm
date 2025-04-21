import SwiftUI

struct SearchView: View {
    @ObservedObject var vm: SubleaseViewModel
    @State private var showFilterSheet = false
    @State private var searchText: String = ""
    @State private var maxPrice: Double = 5000
    @State private var maxDistance: Double = 50
    @State private var selectedType: PropertyType? = nil
    @State private var minRating: Int = 0
    @State private var showResults: Bool = false

    var filteredSubleases: [Sublease] {
        let filteredBySearchText = vm.subleases.filter { sublease in
            searchText.isEmpty ||
            sublease.name.localizedCaseInsensitiveContains(searchText) ||
            sublease.address.localizedCaseInsensitiveContains(searchText)
        }

        let filteredByPrice = filteredBySearchText.filter { sublease in
            sublease.price <= maxPrice
        }

        let filteredByDistance = filteredByPrice.filter { sublease in
            sublease.distance <= maxDistance
        }

        let filteredByRating = filteredByDistance.filter { sublease in
            sublease.averageRating >= minRating
        }

        let filteredByType = filteredByRating.filter { sublease in
            selectedType == nil || sublease.propertyType == selectedType!
        }

        return filteredByType
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 12) {
                SearchBar(searchText: $searchText, showFilterSheet: $showFilterSheet, showResults: $showResults) // Pass showResults as a binding

                if showResults {
                    SearchResultsView(filteredSubleases: filteredSubleases, showResults: $showResults, vm: vm)
                }

                Spacer()
            }
            .navigationTitle("Search")
            .sheet(isPresented: $showFilterSheet) {
                FilterSheetView(
                    maxPrice: $maxPrice,
                    maxDistance: $maxDistance,
                    selectedType: $selectedType,
                    minRating: $minRating
                )
            }
        }
    }
}


struct SearchBar: View {
    @Binding var searchText: String
    @Binding var showFilterSheet: Bool
    @Binding var showResults: Bool // Add this binding

    var body: some View {
        VStack(spacing: 8) {
            TextField("Search by name or address", text: $searchText)
                .padding(8)
                .background(Color.blue.opacity(0.05))
                .cornerRadius(10)

            HStack {
                Button("Filters") {
                    showFilterSheet = true
                }
                .font(.system(size:17))

                Spacer()

                Button("Search") {
                    // Trigger search action here
                    showResults = true // Now you can access and modify showResults
                }
                .buttonStyle(.borderedProminent)
                .font(.system(size: 17, weight:.bold))
            }
        }
        .padding(.horizontal)
    }
}

struct SearchResultsView: View {
    var filteredSubleases: [Sublease]
    @Binding var showResults: Bool
    @ObservedObject var vm: SubleaseViewModel

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                if filteredSubleases.isEmpty {
                    Text("No results found.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ForEach(filteredSubleases) { sublease in
                        SubleaseRow(sublease: sublease, vm: vm)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(12)
                            .padding(.horizontal)
                    }
                }
            }
            .padding(.top)
        }
    }
}


struct SubleaseRow: View {
    var sublease: Sublease
    @ObservedObject var vm: SubleaseViewModel // Inject the view model
    @State private var showReviewSheet = false
    @State private var showReadReviewsSheet = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(sublease.name)
                        .font(.headline)
                    Text(sublease.address)
                    Text("$\(Int(sublease.price)) · \(Int(sublease.distance)) mi")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    RatingView(averageRating: sublease.averageRating)

                    if !sublease.topComment.isEmpty {
                        Text("“\(sublease.topComment)”")
                            .font(.footnote)
                            .italic()
                            .foregroundColor(.gray)
                    }

                    Text(sublease.email)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(sublease.phoneNumber)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Spacer()

                Button(action: {
                    // Like/unlike logic
                }) {
                    Image(systemName: sublease.liked ? "heart.fill" : "heart")
                        .foregroundColor(sublease.liked ? .red : .gray)
                        .imageScale(.large)
                }
            }

            // ⭐️ Add Review Button
            Button("Add Review") {
                showReviewSheet = true
            }
            .font(.subheadline)
            .padding(.top, 4)
            .sheet(isPresented: $showReviewSheet) {
                ReviewFormView(vm: vm, sublease: sublease)
            }
            Button("Read Reviews") {
                showReadReviewsSheet = true
            }
            .font(.subheadline)
            .foregroundColor(.blue)
            .sheet(isPresented: $showReadReviewsSheet) {
                ReviewListView(sublease: sublease)
            }
        }
    }
}


struct RatingView: View {
    var averageRating: Int

    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<5) { i in
                Image(systemName: i < averageRating ? "star.fill" : "star")
                    .foregroundColor(i < averageRating ? .yellow : .gray)
            }
        }
        .font(.caption)
    }
}


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





#Preview {
    let previewvm1 = OnboardingViewModel()
    let previewvm2 = SubleaseViewModel()

    BottomBarView(onboardingVM: previewvm1, rentVM: previewvm2)
}
