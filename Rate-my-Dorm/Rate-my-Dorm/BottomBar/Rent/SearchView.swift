import CoreLocation
import MapKit
import SwiftUI

struct SearchView: View {
    @ObservedObject var vm: RentViewModel
    @State private var showFilterSheet = false
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
                                    SubleaseCardView(sublease: sublease, username: vm.APIInfoBus.username, vm: vm)
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

#Preview {
    let previewvm1 = OnboardingViewModel()
    let previewvm2 = RentViewModel()
    
    BottomBarView(onboardingVM: previewvm1, rentVM: previewvm2)
}
