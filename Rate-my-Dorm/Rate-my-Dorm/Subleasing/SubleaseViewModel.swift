import Foundation
import Observation
import SwiftUI
import MapKit
import CoreLocation

@MainActor
class SubleaseViewModel: ObservableObject {
    @Published var subleases: [Sublease] = [
        Sublease(
            name: "Union Apts",
            address: "425 Hillsborough Street, Chapel Hill, NC, 27514",
            price: 850,
            distance: 0.9,
            propertyType: .apartment,
            email: "contact@union.com",
            phoneNumber: "123-456-7890",
            reviews: [],
            latitude: 35.919418,   // Hardcoded latitude for Union Apts
            longitude: -79.052605 // Hardcoded longitude for Union Apts
            
        ),
        Sublease(
            name: "Ram Village 1",
            address: "560 Paul Hardin Dr, Chapel Hill, NC 27514",
            price: 950,
            distance: 0.6,
            propertyType: .dorm,
            email: "dorm@unc.edu",
            phoneNumber: "234-567-8901",
            reviews: [],
            latitude: 35.901882,   // Hardcoded latitude for Ram Village 1
            longitude: -79.046019 // Hardcoded longitude for Ram Village 1
            
        ),
        Sublease(
            name: "Horace Williams House",
            address: "610 E Rosemary St, Chapel Hill, NC, 27514",
            price: 950,
            distance: 0.7,
            propertyType: .house,
            email: "info@horacehouse.com",
            phoneNumber: "345-678-9012",
            reviews: [],
            latitude: 35.917837,   // Hardcoded latitude for Horace Williams House
            longitude: -79.045212 // Hardcoded longitude for Horace Williams House
            
        )
    ]

    
    private let geocoder = CLGeocoder()
    
    init() {
        geocodeAllSubleases()
    }


    @Published var newSubleaseName: String = ""
    @Published var newSubleaseAddress: String = ""
    @Published var newSubleasePrice: Double? = nil
    @Published var newSubleaseDistance: Double? = nil
    @Published var newSubleasePropertyType = PropertyType.apartment
    @Published var newSubleaseEmail: String = ""
    @Published var newSubleasePhoneNumber: String = ""
    @Published var newSubleaseReviews: [Review] = []
    
    // New comments property
    @Published var newSubleaseComments: String? = nil

    func add() {
            guard let price = newSubleasePrice, let distance = newSubleaseDistance else {
                print("Price or distance is nil. Cannot add sublease.")
                return
            }

            // Geocode address to get latitude and longitude
            geocodeAddress(address: newSubleaseAddress) { coordinate, error in
                if let coordinate = coordinate {
                    let newSublease = Sublease(
                        name: self.newSubleaseName,
                        address: self.newSubleaseAddress,
                        price: price,
                        distance: distance,
                        propertyType: self.newSubleasePropertyType,
                        email: self.newSubleaseEmail,
                        phoneNumber: self.newSubleasePhoneNumber,
                        reviews: self.newSubleaseReviews,
                        latitude: coordinate.latitude, // Set latitude
                        longitude: coordinate.longitude // Set longitude
                    )
                    self.subleases.append(newSublease)
                    self.resetSublease()
                } else if let error = error {
                    print("Error geocoding address: \(error.localizedDescription)")
                }
            }
        }

    func resetSublease() {
        newSubleaseName = ""
        newSubleaseAddress = ""
        newSubleasePrice = nil
        newSubleaseDistance = nil
        newSubleasePropertyType = PropertyType.apartment
        newSubleaseEmail = ""
        newSubleasePhoneNumber = ""
        newSubleaseReviews = []
        newSubleaseComments = nil
    }
    
    func geocodeAddress(address: String, completion: @escaping (CLLocationCoordinate2D?, Error?) -> Void) {
            geocoder.geocodeAddressString(address) { placemarks, error in
                if let error = error {
                    completion(nil, error)
                    return
                }

                if let location = placemarks?.first?.location {
                    completion(location.coordinate, nil)
                } else {
                    completion(nil, NSError(domain: "GeocodingError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to find coordinates for the address."]))
                }
            }
        }

    func toggleLike(for sublease: Sublease) {
        if let index = subleases.firstIndex(where: { $0.id == sublease.id }) {
            subleases[index].liked.toggle()
        }
    }
    
    func addReview(for sublease: Sublease, rating: Int, comment: String?) {
        guard let index = subleases.firstIndex(where: { $0.id == sublease.id }) else { return }

        let newReview = Review(rating: rating, comment: comment)
        subleases[index].reviews.append(newReview)
    }
    
    private func geocodeAllSubleases() {
        for index in subleases.indices {
            geocodeAddress(address: subleases[index].address) { coordinate, error in
                if let coordinate = coordinate {
                    self.subleases[index].latitude = coordinate.latitude
                    self.subleases[index].longitude = coordinate.longitude
                    print("Geocoded \(self.subleases[index].name): \(coordinate.latitude), \(coordinate.longitude)")
                } else {
                    print("Failed to geocode \(self.subleases[index].name): \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }
    }

    /*
    func geocodeAddress(for index: Int) async {
            guard index < subleases.count else { return }
            let address = subleases[index].address

            do {
                let placemarks = try await geocoder.geocodeAddressString(address)
                if let location = placemarks.first?.location {
                    subleases[index].latitude = location.coordinate.latitude
                    subleases[index].longitude = location.coordinate.longitude
                }
            } catch {
                print("Failed to geocode address for \(subleases[index].name): \(error)")
            }
        }
     */
}
