//
//  ProfileView.swift
//  Rate-my-Dorm
//
//  Created by Arya Venkatesan on 4/15/25.
//

import SwiftUI
import Combine

struct ProfileView: View {
    var onboardingVM: OnboardingViewModel
    var vm: RentViewModel
    @State private var selectedTab = " "
    var selections = ["My Listings", "Hearted Listings"]
    var filteredSubleases: [Sublease] = []
    var hasAppeared = true
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 135/255, green: 180/255, blue: 235/255, opacity: 0.25)
                    .ignoresSafeArea()
                
                // This won't work on other screen sizes
                // me from the future: it actually does for whatever reason
                
                Circle()
                    .fill(.blue)
                    .frame(width: 1500, height: 1500)
                    .offset(x: 0, y: -870) // Adjust position as needed
                // .blendMode(.) // Blends with background
                    .opacity(0.8)
                
                Circle()
                    .fill(.blue)
                    .frame(width: 1500, height: 1500)
                    .offset(x: 0, y: -790) // Adjust position as needed
                // .blendMode(.) // Blends with background
                    .opacity(0.5)
                
                Circle()
                    .fill(.blue)
                    .frame(width: 1500, height: 1500)
                    .offset(x: 0, y: -710) // Adjust position as needed
                // .blendMode(.) // Blends with background
                    .opacity(0.3)
                
                Button {
                    print("logout")
                    onboardingVM.logout()
                } label: {
                    HStack {
                        Text("Logout:")
                            .fixedSize(horizontal: true, vertical: true)
                            .allowsTightening(false)
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                    }
                    .fontWeight(.black)
                    .font(.custom("AmericanTypewriter", size: 16))
                    .padding(32)
                    .foregroundColor(Color(.systemBlue))
                    .frame(height: 30) // Fixed height
                    .frame(maxWidth: 120)
                }
                .background(Color(.white)
                    .opacity(1))
                .clipShape(.capsule)
                .offset(x: 120, y: -370)
                
//                Button {
//                    print("logout")
//                } label: {
//                    HStack {
//                        Text("")
//                    }
//                    .frame(height: 9999) // Fixed height
//                    .frame(width: 9999)
//                }
//                .background(Color(.white)
//                    .opacity(1))
//                .clipShape(.rect)
//                .zIndex(0)
                
                
                
                VStack {
                    Spacer()
                    Spacer()
                    Spacer()
                    
                    VStack { //actual pfps? theres gotta be a way to click on it and select from camera roll, but then gotta make extra api to save it on db miss me with that shi
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                            .padding(.top, 100)
                        
                        Text("Username:  \(onboardingVM.usernameActual)")
                            .fontWeight(.black)
                            .font(.custom("HoeflerText-Regular", size: 32))
                            .opacity(0.75)
                            .multilineTextAlignment(.center)
                            .padding(.top, 32)
                            .padding(.bottom, 0)
                            .foregroundColor(.black)
                        
                        Text("School: \(onboardingVM.infoBus.school)")
                            .fontWeight(.black)
                            .font(.custom("HoeflerText-Regular", size: 26))
                            .opacity(0.75)
                            .multilineTextAlignment(.center)
                            .padding(42)
                            .foregroundColor(.black)
                            .offset(x: 0, y: -7)
                    }
                    .padding(.top, 25)
                    
                    Spacer()
                    Spacer() //you gotta trust i promise this works
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                }
                
                VStack {
                    // ZStack frame for the menu things
                    Picker("", selection: $selectedTab) {
                        ForEach(selections, id: \.self) { selection in
                            Text(selection).tag(selection)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(maxWidth: 240)
                    .padding(.horizontal, 20)
                    .onChange(of: selectedTab) { _ in
                        vm.allowProfileSubcardInit()
                    }
                    
                    VStack {
                        //theres def a way to make it more consise eg. showTrashButton takes "My Listings" or "HeartedListings" and figures out what button to show within the SubleaseListView, but this works and is lowk clearer
                        if selectedTab == "My Listings" {
                            SubleaseListView(
                                filteredSubleases: vm.subleases,
                                showTrashButton: true,
                                vm: vm,
                                username: onboardingVM.usernameActual
                            )
                            
                        } else if selectedTab == "Hearted Listings" {
                            SubleaseListView(
                                filteredSubleases: vm.subleases,
                                showTrashButton: false,
                                vm: vm,
                                username: onboardingVM.usernameActual
                            )
                        }
                    }
                    .frame(maxWidth: .infinity, minHeight: 225, maxHeight: 225)
                    
                }
                .offset(x: 0, y: 185)
                
                
            }
            .onAppear {
                Task {
                    await vm.getAllSubleases()
                }
            }
        }
    }
}

#Preview {
    let previewvm = OnboardingViewModel()
    let previewvm2 = RentViewModel()
    
    BottomBarView(onboardingVM: previewvm, rentVM: previewvm2)
}
