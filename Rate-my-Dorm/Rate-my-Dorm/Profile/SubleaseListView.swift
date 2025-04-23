//
//  SubleaseListView.swift
//  Rate-my-Dorm
//
//  Created by Arya Venkatesan on 4/21/25.
//
import SwiftUI

struct SubleaseListView: View {
    @State private var filteredSubleases: [Sublease]
    let showTrashButton: Bool
    let vm: RentViewModel
    let username: String
    
    init(filteredSubleases: [Sublease], showTrashButton: Bool, vm: RentViewModel, username: String) {
        self._filteredSubleases = State(initialValue: filteredSubleases)
        self.showTrashButton = showTrashButton
        self.vm = vm
        self.username = username
        
        Task {
            await vm.getAllSubleases()
        }
        
        if showTrashButton {
            var output: [Sublease] = []
            for s in vm.subleases {
                if s.creatorUsername == username {
                    output.append(s)
                }
            }
            self._filteredSubleases = State(initialValue: output)
        } else {
            var output: [Sublease] = []
            for s in vm.subleases {
                if s.heartList.contains(username) {
                    output.append(s)
                }
            }
            self._filteredSubleases = State(initialValue: output)
        }
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                if filteredSubleases.isEmpty {
                    Text("No results found.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ForEach(filteredSubleases) { sublease in
                        SubleaseRow(
                            sublease: sublease,
                            showTrashButton: showTrashButton,
                            vm: vm,
                            username: username,
                            onDelete: {
                                Task {
                                    await vm.getAllSubleases()
                                    withAnimation {
                                        if showTrashButton {
                                            filteredSubleases = vm.subleases.filter { $0.creatorUsername == username }
                                        } else {
                                            filteredSubleases = vm.subleases.filter { $0.heartList.contains(username) }
                                        }
                                    }
                                }
                            }
                        )
                    }
                }
            }
            .padding(.top)
        }
        // Remove the .id modifier
    }
}

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
            .padding(.trailing, 80)
            
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
    }
}
