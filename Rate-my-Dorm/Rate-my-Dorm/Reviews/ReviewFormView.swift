import SwiftUI

struct ReviewFormView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var vm: SubleaseViewModel
    var sublease: Sublease

    @State private var rating: Int = 0
    @State private var comment: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Rating")) {
                    HStack {
                        ForEach(1...5, id: \.self) { star in
                            Image(systemName: star <= rating ? "star.fill" : "star")
                                .foregroundColor(.yellow)
                                .onTapGesture {
                                    rating = star
                                }
                        }
                    }
                }

                Section(header: Text("Comment")) {
                    TextEditor(text: $comment)
                        .frame(height: 100)
                }
            }
            .navigationTitle("Add Review")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Submit") {
                        vm.addReview(for: sublease, rating: rating, comment: comment)
                        dismiss()
                    }
                    .disabled(rating == 0)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}
