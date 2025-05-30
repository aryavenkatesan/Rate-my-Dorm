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
    @StateObject private var RentVM = RentViewModel()
    
    var body: some View {
        if OnboardingVM.isUserLoggedIn {
            BottomBarView(onboardingVM: OnboardingVM, rentVM: RentVM)
        } else {
            LoginView(vm: OnboardingVM)
            
        }
    }
}

/*
 Make colors on BottomBarView correspond to the current school
 Make BottomBarView screens not part of navigation so the app will work on iPad
 */


#Preview {
    ContentView()
}
