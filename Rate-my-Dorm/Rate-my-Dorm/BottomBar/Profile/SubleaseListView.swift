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
        
        if vm.initializeProfileSubcards {
            
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
            
            vm.initializeProfileSubcards = false 
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
