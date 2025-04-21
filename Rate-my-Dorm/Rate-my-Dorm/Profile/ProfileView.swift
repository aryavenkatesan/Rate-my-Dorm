//
//  ProfileView.swift
//  Rate-my-Dorm
//
//  Created by Arya Venkatesan on 4/15/25.
//

import SwiftUI

struct ProfileView: View {
    var onboardingVM: OnboardingViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.blue)
                    .ignoresSafeArea()
                    .opacity(0.15)
                
                // This won't work on other screen sizes
                
                Circle()
                    .fill(.blue)
                    .frame(width: 1500, height: 1500)
                    .offset(x: 0, y: -870) // Adjust position as needed
                    //.blendMode(.) // Blends with background
                    .opacity(0.8)
                
                Circle()
                    .fill(.blue)
                    .frame(width: 1500, height: 1500)
                    .offset(x: 0, y: -790) // Adjust position as needed
                    //.blendMode(.) // Blends with background
                    .opacity(0.5)
                
                Circle()
                    .fill(.blue)
                    .frame(width: 1500, height: 1500)
                    .offset(x: 0, y: -710) // Adjust position as needed
                    //.blendMode(.) // Blends with background
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
                        .foregroundColor(Color(.systemBlue)) // Changed text color to white
                        .frame(height: 30) // Fixed height
                        .frame(maxWidth: 120)
                    }
                    .background(Color(.white)
                        .opacity(1)) // Light blue background
                    .clipShape(.capsule)
                    .offset(x: 120, y: -370)
                        

                
                VStack {
                    //ZStack frame for profile stuff
                    Spacer()
                    Spacer()
                    Spacer()
                    
                    
                    VStack {
                        
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
                        
                        Text("School: \(onboardingVM.schoolInput)")
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
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    
                }
                
                VStack {
                    //ZStack frame for the menu things
                    Text("Here")
                        .padding(.top, 140)
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
