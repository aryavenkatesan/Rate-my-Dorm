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
                
                // Large Circle Shape
                
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
                
                VStack {
                    Spacer()
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
                    
                    Spacer()
                    Spacer()
                    
                    
                    Button {
                        print("logout")
                        onboardingVM.logout()
                        
                    } label: {
                        HStack {
                            Text("Logout:")
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                        }
                        .fontWeight(.black)
                        .font(.custom("AmericanTypewriter", size: 24))
                        .padding(32)
                        .foregroundColor(.white) // Changed text color to white
                        .frame(height: 50) // Fixed height
                        .frame(maxWidth: 250)
                    }
                    .background(Color(.systemBlue).opacity(0.5)) // Light blue background
                    .clipShape(.capsule)
                    
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    
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
