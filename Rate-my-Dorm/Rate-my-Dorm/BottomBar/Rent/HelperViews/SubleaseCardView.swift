//
//  SubleaseCardView.swift
//  Rate-my-Dorm
//
//  Created by Arya Venkatesan on 5/16/25.
//

import SwiftUI
import MapKit
import CoreLocation

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
                        await vm.toggleLike(sublease: sublease)
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
