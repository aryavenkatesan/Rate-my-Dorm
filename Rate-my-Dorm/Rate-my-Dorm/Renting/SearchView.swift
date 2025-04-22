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
    @State private var showMapView = false // State to control the map view sheet
    @State private var isMapAvailable = false // State to track if map coordinates are available

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
                                                if isMapAvailable {
                                                                // View on Map Button
                                                                Button("View on Map") {
                                                                    showMapView = true // Show the map view when tapped
                                                                }
                                                                .font(.subheadline)
                                                                .foregroundColor(.blue)
                                                                .sheet(isPresented: $showMapView) {
                                                                    // Present the MapView in a sheet
                                                                    MapView(subleases: [sublease]) // Only pass the current sublease
                                                                }
                                                            } else {
                                                                // Show a loading indicator or message while waiting for coordinates
                                                                Text("Loading map...")
                                                                    .font(.subheadline)
                                                                    .foregroundColor(.gray)
                                                                    .padding(.top, 4)
                                                                    .onAppear {
                                                                        // Try to load the coordinates for the map
                                                                        loadMapCoordinates()
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

struct MapView: View {
    @State private var region: MKCoordinateRegion
    var subleases: [Sublease]
    @Environment(\.dismiss) var dismiss
    
    @State private var latitude: Double?
    @State private var longitude: Double?
    
    func geocode(address: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            if let coordinate = placemarks?.first?.location?.coordinate {
                self.latitude = coordinate.latitude
                self.longitude = coordinate.longitude
            } else {
                self.latitude = nil
                self.longitude = nil
                self.coordinatesFetched = false  // No coordinates found
            }
        }
    }

    var body: some View {
        VStack {
            // White background for the Close button
            ZStack {
                RoundedRectangle(cornerRadius: 0)
                    .fill(Color.white)
                    .frame(height: 60) // White area height
                    .shadow(radius: 5)

                // Close button text inside the white area
                Text("Close")
                    .font(.headline)
                    .foregroundColor(.blue)
                    .padding()
                    .onTapGesture {
                        dismiss() // Dismiss the map view when tapped
                    }
            }
            
            // Map view
            Map(coordinateRegion: $region, annotationItems: subleases) { sublease in
                MapPin(coordinate: CLLocationCoordinate2D(latitude: sublease.latitude ?? 0.0, longitude: sublease.longitude ?? 0.0), tint: .blue)
            }
            .edgesIgnoringSafeArea(.all)
            
            // Overlay for zoom buttons
            .overlay(
                VStack {
                    Spacer()

                    HStack {
                        Spacer()

                        VStack {
                            // White background for zoom buttons
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white)
                                    .frame(width: 60, height: 120)
                                    .shadow(radius: 5) // Optional shadow to give a floating effect

                                VStack {
                                    // Zoom in button
                                    Button(action: {
                                        zoomIn()
                                    }) {
                                        Image(systemName: "plus.circle.fill")
                                            .font(.system(size: 30))
                                            .foregroundColor(.blue)
                                            .padding()
                                    }

                                    // Zoom out button
                                    Button(action: {
                                        zoomOut()
                                    }) {
                                        Image(systemName: "minus.circle.fill")
                                            .font(.system(size: 30))
                                            .foregroundColor(.blue)
                                            .padding()
                                    }
                                }
                            }
                            .padding(.top, 20) // Optional top padding for better spacing
                        }
                        .padding(.trailing, 20)
                    }
                }
            )
        }
    }

    private func zoomIn() {
        // Adjust zoom level for zooming in
        region.span.latitudeDelta *= 0.8
        region.span.longitudeDelta *= 0.8
    }

    private func zoomOut() {
        // Adjust zoom level for zooming out
        region.span.latitudeDelta *= 1.2
        region.span.longitudeDelta *= 1.2
    }

}

private func loadMapCoordinates() {
        // Check if coordinates are available and update the state
        if let latitude = $latitude, let longitude = $longitude {
            isMapAvailable = true
        } else {
            // Wait for coordinates to be available if they're missing
            // You can add a delay here if you want to simulate waiting or retrying
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                loadMapCoordinates() // Try again after a short delay
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
