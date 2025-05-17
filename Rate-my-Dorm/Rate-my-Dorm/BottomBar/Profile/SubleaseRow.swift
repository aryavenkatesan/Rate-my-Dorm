//
//  SubleaseRow.swift
//  Rate-my-Dorm
//
//  Created by Arya Venkatesan on 5/15/25.
//
import SwiftUI

struct SubleaseRow: View {
    let sublease: Sublease
    let showTrashButton: Bool
    let vm: RentViewModel
    let username: String
    let onDelete: () -> Void
    
    var body: some View {
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
                    Text("\(sublease.comments)")
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
            }
            //.padding(.trailing, 80)
            
            Spacer()
            
            if showTrashButton {
                Button {
                    Task {
                        await vm.deleteListing(sublease: sublease)
                        onDelete()
                    }
                } label: {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                        .imageScale(.large)
                }
            } else {
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
        .frame(width: UIScreen.main.bounds.width)
    }
}
