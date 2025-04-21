struct ReviewListView: View {
    var sublease: Sublease

    var body: some View {
        NavigationView {
            List {
                if sublease.reviews.isEmpty {
                    Text("No reviews yet.")
                        .foregroundColor(.gray)
                } else {
                    ForEach(sublease.reviews) { review in
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                ForEach(0..<5) { i in
                                    Image(systemName: i < review.rating ? "star.fill" : "star")
                                        .foregroundColor(i < review.rating ? .yellow : .gray)
                                }
                            }
                            Text(review.comment)
                                .font(.body)
                        }
                        .padding(.vertical, 6)
                    }
                }
            }
            .navigationTitle("Reviews")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        // iOS 16+ auto-dismisses, or use @Environment(\.dismiss) if needed
                    }
                }
            }
        }
    }
}
