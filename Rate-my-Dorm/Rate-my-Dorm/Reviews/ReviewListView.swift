//
//  ReviewListView.swift
//  Rate-my-Dorm
//
//  Created by Brenton on 4/21/25.
//


import SwiftUI

struct ReviewListView: View {
    var sublease: Sublease

    var body: some View {
        NavigationView {
            List {
                if sublease.reviews.isEmpty {
                    Text("No reviews yet.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ForEach(sublease.reviews) { review in
                        VStack(alignment: .leading, spacing: 4) {
                            HStack(spacing: 2) {
                                ForEach(1...5, id: \.self) { i in
                                    Image(systemName: i <= review.rating ? "star.fill" : "star")
                                        .foregroundColor(i <= review.rating ? .yellow : .gray)
                                }
                            }
                            .font(.caption)

                            if !review.comment.isEmpty {
                                Text("“\(review.comment)”")
                                    .italic()
                                    .foregroundColor(.secondary)
                            }

                            Text(review.date.formatted(date: .abbreviated, time: .omitted))
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Reviews")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                }
            }
        }
    }
}
