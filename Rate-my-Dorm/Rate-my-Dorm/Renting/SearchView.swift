import SwiftUI
import CoreLocation
import MapKit

struct SearchView: View {
    @ObservedObject var vm: RentViewModel
    @State private var showFilterSheet = false
    let username: String

    @State private var searchText: String = ""
    @State private var maxPrice: Double = 5000
    @State private var maxDistance: Double = 50
    @State private var selectedType: PropertyType? = nil
    @State private var minRating: Int = 0

    @State private var showResults: Bool = false

    @State private var latitude: Double?
    @State private var longitude: Double?
    @State private var coordinatesFetched: Bool = false  // New state variable

    var filteredSubleases: [Sublease] {
        vm.subleases.filter { sublease in
            (searchText.isEmpty ||
             sublease.name.localizedCaseInsensitiveContains(searchText) ||
             sublease.address.localizedCaseInsensitiveContains(searchText)) &&
            sublease.price <= maxPrice &&
            sublease.distance <= maxDistance &&
            sublease.rating >= minRating &&
            (selectedType == nil || sublease.propertyType == selectedType!)
        }
    }

    func geocode(address: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            if let coordinate = placemarks?.first?.location?.coordinate {
                self.latitude = coordinate.latitude
                self.longitude = coordinate.longitude
                self.coordinatesFetched = true  // Coordinates are now fetched
            } else {
                self.latitude = nil
                self.longitude = nil
                self.coordinatesFetched = false  // No coordinates found
            }
        }
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 12) {
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
                        .sheet(isPresented: $showFilterSheet) {
                            FilterSheetView(
                                maxPrice: $maxPrice,
                                maxDistance: $maxDistance,
                                selectedType: $selectedType,
                                minRating: $minRating
                            )
                        }

                        Spacer()

                        Button("Search") {
                            Task {
                                await vm.getAllSubleases()
                            }
                            showResults = true
                        }
                        .buttonStyle(.borderedProminent)
                        .font(.system(size: 17, weight:.bold))
                    }
                }
                .padding(.horizontal)

                if showResults {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            if filteredSubleases.isEmpty {
                                Text("No results found.")
                                    .foregroundColor(.gray)
                                    .padding()
                            } else {
                                ForEach(filteredSubleases) { sublease in
                                    VStack(alignment: .leading, spacing: 8) {
                                        HStack {
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(sublease.name)
                                                    .font(.headline)
                                                Text(sublease.address)
                                                Text("$\(Int(sublease.price)) · \(Int(sublease.distance)) mi")
                                                    .font(.subheadline)
                                                    .foregroundColor(.secondary)
                                                
                                                HStack(spacing: 2) {
                                                    ForEach(0..<5) { i in
                                                        Image(systemName: i < sublease.rating ? "star.fill" : "star")
                                                            .foregroundColor(i < sublease.rating ? .yellow : .gray)
                                                    }
                                                }
                                                .font(.caption)
                                                
                                                if !sublease.comments.isEmpty {
                                                    Text("“\(sublease.comments)”")
                                                        .font(.footnote)
                                                        .italic()
                                                        .foregroundColor(.gray)
                                                }
                                                
                                                Text(sublease.contactEmail)
                                                    .font(.subheadline)
                                                    .foregroundColor(.secondary)
                                                Text(sublease.phoneNumber)
                                                    .font(.subheadline)
                                                    .foregroundColor(.secondary)
                                                
                                                // Only display coordinates once they are fetched
                                                if coordinatesFetched {
                                                    Text("Latitude: \(latitude ?? 0), Longitude: \(longitude ?? 0)")
                                                        .font(.footnote)
                                                        .foregroundColor(.blue)
                                                    
                                                    // Map view showing location based on fetched coordinates
                                                    if let latitude = latitude, let longitude = longitude {
                                                        Map(coordinateRegion: .constant(
                                                            MKCoordinateRegion(
                                                                center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                                                                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                                                            )
                                                        ))
                                                        .frame(height: 200)  // Set a frame for the map
                                                        .cornerRadius(10)
                                                        .padding(.top, 8)
                                                    }
                                                } else {
                                                    Text("Fetching coordinates...")
                                                        .font(.footnote)
                                                        .foregroundColor(.gray)
                                                        .onAppear {
                                                            geocode(address: sublease.address)
                                                        }
                                                }
                                            }
                                            
                                            Spacer()
                                            Button {
                                                Task {
                                                    await vm.toggleLike(sublease: sublease, username: username)
                                                }
                                            } label: {
                                                Image(systemName: sublease.heartList.contains(username) ? "heart.fill" : "heart")
                                                    .foregroundColor(sublease.heartList.contains(username) ? .red : .gray)
                                                    .imageScale(.large)
                                            }
                                        }
                                        .padding()
                                        .background(Color.gray.opacity(0.1))
                                        .cornerRadius(12)
                                        .padding(.horizontal)
                                    }
                                }
                            }
                        }
                        .padding(.top)
                        .padding(.bottom, 60)
                    }
                }
                Spacer()
            }
            .navigationTitle("Search")
            .background(Color(red: 0.9, green: 0.95, blue: 1.0))
        }
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
    let previewvm2 = RentViewModel()

    BottomBarView(onboardingVM: previewvm1, rentVM: previewvm2)
}
