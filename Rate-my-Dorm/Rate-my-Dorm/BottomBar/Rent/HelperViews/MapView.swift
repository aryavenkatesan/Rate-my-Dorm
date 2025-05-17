//
//  MapView.swift
//  Rate-my-Dorm
//
//  Created by Arya Venkatesan on 5/16/25.
//

import SwiftUI
import CoreLocation
import MapKit

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
