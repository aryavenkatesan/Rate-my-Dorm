//
//  ContentView.swift
//  Rate-my-Dorm
//
//  Created by Arya Venkatesan on 4/15/25.
//

import SwiftUI

struct ContentView: View {
    //instantiate all of the ViewModels 
    @StateObject private var OnboardingVM = OnboardingViewModel()
    @StateObject private var RentVM = SubleaseViewModel()
    
    var body: some View {
        
        if OnboardingVM.isUserLoggedIn {
            BottomBarView(onboardingVM: OnboardingVM, rentVM: RentVM)
        } else {
            LoginView(vm: OnboardingVM)
            
        }
    }
}


#Preview {
    ContentView()
}
