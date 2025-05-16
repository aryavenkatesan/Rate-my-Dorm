import CoreLocation
import MapKit
import SwiftUI

struct SearchView: View {
    @ObservedObject var vm: RentViewModel
    @State private var showFilterSheet = false
    let username: String
    let school: String

    @State private var searchText: String = ""
    @State private var maxPrice: Double = 5000
    @State private var maxDistance: Double = 50
    @State private var selectedType: PropertyType? = nil
    @State private var minRating: Int = 0

    @State private var showResults: Bool = false

    @State private var latitude: Double?
    @State private var longitude: Double?
    @State private var coordinatesFetched: Bool = false // New state variable

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
        geocoder.geocodeAddressString(address) { placemarks, _ in
            if let coordinate = placemarks?.first?.location?.coordinate {
                self.latitude = coordinate.latitude
                self.longitude = coordinate.longitude
                self.coordinatesFetched = true // Coordinates are now fetched
            } else {
                self.latitude = nil
                self.longitude = nil
                self.coordinatesFetched = false // No coordinates found
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
                        .font(.system(size: 17))
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
                        .font(.system(size: 17, weight: .bold))
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
                                    SubleaseCardView(sublease: sublease, username: username, vm: vm)
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
            .onAppear(){
                vm.schoolName = school
            }
        }
    }
}

struct SubleaseCardView: View {
    let sublease: Sublease
    let username: String
    @ObservedObject var vm: RentViewModel

    @State private var latitude: Double?
    @State private var longitude: Double?
    @State private var coordinatesFetched = false
    @State private var showMapSheet = false

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

                    HStack(spacing: 2) {
                        ForEach(0 ..< 5) { i in
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
                    // Test Longitude pull code
                    if coordinatesFetched {
                        // Text("Latitude: \(latitude ?? 0), Longitude: \(longitude ?? 0)")
                        // .font(.footnote)
                        // .foregroundColor(.blue)

                        Button("Open Map") {
                            showMapSheet = true
                        }
                        .font(.footnote)
                        .foregroundColor(.blue)
                        .sheet(isPresented: $showMapSheet) {
                            if let lat = latitude, let lon = longitude {
                                SubleaseMapView(sublease: sublease, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon))
                            }
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
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
        .padding(.horizontal)
        .onAppear {
            if !coordinatesFetched {
                geocode(address: sublease.address)
            }
        }
    }

    private func geocode(address: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { placemarks, _ in
            if let coordinate = placemarks?.first?.location?.coordinate {
                latitude = coordinate.latitude
                longitude = coordinate.longitude
                coordinatesFetched = true
            } else {
                latitude = nil
                longitude = nil
                coordinatesFetched = false
            }
        }
    }
}

struct SubleaseMapView: View {
    let sublease: Sublease
    let coordinate: CLLocationCoordinate2D

    @Environment(\.dismiss) var dismiss

    @State private var region: MKCoordinateRegion

    init(sublease: Sublease, coordinate: CLLocationCoordinate2D) {
        self.sublease = sublease
        self.coordinate = coordinate
        _region = State(initialValue: MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        ))
    }

    var body: some View {
        Map(coordinateRegion: $region, annotationItems: [sublease]) { _ in
            MapMarker(coordinate: coordinate, tint: .blue)
        }
        .edgesIgnoringSafeArea(.all)
        .overlay(alignment: .top) {
            VStack(spacing: 12) {
                // Header bar
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .foregroundColor(.primary)
                    }

                    Spacer()

                    Text(sublease.name)
                        .font(.headline)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)

                    Spacer()

                    // Invisible to balance the HStack
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .opacity(0)
                }
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)
                .padding(.top, 16)

                Spacer()
            }
        }
        .overlay(alignment: .bottomTrailing) {
            VStack(spacing: 12) {
                Button(action: {
                    region.span.latitudeDelta /= 1.5
                    region.span.longitudeDelta /= 1.5
                }) {
                    Image(systemName: "plus.magnifyingglass")
                        .font(.title2)
                        .padding(10)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                }

                Button(action: {
                    region.span.latitudeDelta *= 1.5
                    region.span.longitudeDelta *= 1.5
                }) {
                    Image(systemName: "minus.magnifyingglass")
                        .font(.title2)
                        .padding(10)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                }
            }
            .padding(.top, 80) // Push below the header
            .padding(.trailing, 16)
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
