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
        Text("Profile View")
        Button {
            print("logout")
            onboardingVM.logout()
            
        } label: {
            Text("Logout")
        }
    }
}

#Preview {
    let previewvm = OnboardingViewModel()

    BottomBarView(onboardingVM: previewvm)
}
