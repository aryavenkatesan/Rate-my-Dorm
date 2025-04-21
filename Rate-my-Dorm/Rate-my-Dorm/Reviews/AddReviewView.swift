//
//  AddRatingView.swift
//  Rate-my-Dorm
//
//  Created by Brenton on 4/21/25.
//


import SwiftUI

struct AddReviewView: View {
    @Environment(\.dismiss) var dismiss

    var sublease: Sublease
    @ObservedObject var vm: SubleaseViewModel

    @State private var selectedRating: Int = 0
    @State private var comment: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Rating")) {
                    HStack {
                        ForEach(1...5, id: \.self) { i in
                            Image(systemName: i <= selectedRating ? "star.fill" : "star")
                                .resizable()
                                .frame(width: 28, height: 28)
                                .foregroundColor(.yellow)
                                .onTapGesture {
                                    selectedRating = i
                                }
                        }
                    }
                }

                Section(header: Text("Comment (optional)")) {
                    TextField("Write a comment...", text: $comment)
                }

                Section {
                    Button("Submit") {
                        vm.addReview(for: sublease, rating: selectedRating, comment: comment)
                        dismiss()
                    }
                    .disabled(selectedRating == 0)
                }
            }
            .navigationTitle("Add Rating")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}
