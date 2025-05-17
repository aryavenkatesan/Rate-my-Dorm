//
//  TabView.swift
//  Rate-my-Dorm
//
//  Created by Arya Venkatesan on 4/16/25.
//

import SwiftUI

struct BottomBarView: View {
    // tab components
    @State var currentTab: Tab = .Rent
    @Namespace var animation
    @ObservedObject var Onboardingvm: OnboardingViewModel
    @ObservedObject var Rentvm: RentViewModel
    
    init(onboardingVM: OnboardingViewModel, rentVM: RentViewModel) {
        UITabBar.appearance().isHidden = true
        self.Onboardingvm = onboardingVM
        self.Rentvm = rentVM
        self.Rentvm.APIInfoBus = self.Onboardingvm.infoBus
        
        self.Rentvm.timeoutCallback = {
            Task { @MainActor in
                onboardingVM.timedout()
            }
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Show the current view full screen.
            Group {
                switch self.currentTab {
                case .Sublease:
                    SubleaseView(vm: self.Rentvm)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    //                        .background(Color.yellow.opacity(0.2))
                case .Rent:
                    SearchView(vm: self.Rentvm)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    //                        .background(Color.blue.opacity(0.2))
                case .Profile:
                    ProfileView(onboardingVM: self.Onboardingvm, vm: self.Rentvm)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    //                        .background(Color.green.opacity(0.2))
                }
            }
            .ignoresSafeArea() // Make sure the content goes full screen
            
            // Custom bottom bar
            HStack {
                ForEach(Tab.allCases, id: \.rawValue) { tab in
                    Spacer()
                    VStack {
                        TabButton(tab: tab, currentTab: self.$currentTab, animation: self.animation)
                        LabelImpl(tab: tab, currentTab: self.$currentTab, animation: self.animation)
                            .frame(width: 50)
                    }
                    Spacer()
                }
            }
            .padding(.vertical, 10)
            .padding(.bottom, self.getSafeArea().bottom == 0 ? 10 : self.getSafeArea().bottom)
            .background(Color.white.shadow(radius: 2))
        }
        .ignoresSafeArea(edges: .bottom)
    }
    
    // Helper function for safe area insets
    func getSafeArea() -> UIEdgeInsets {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let safeArea = screen.windows.first?.safeAreaInsets
        else {
            return .zero
        }
        return safeArea
    }
}

struct TabButton: View {
    var tab: Tab
    @Binding var currentTab: Tab
    var animation: Namespace.ID
    var body: some View {
        Button(action: {
            //this is super finicky, know that it could be done better but its not really worth the headache
            withAnimation(.smooth(duration: 0.3, extraBounce: 0.25)) {
                self.currentTab = self.tab
            }
        }) {
            Image(systemName: self.currentTab == self.tab ? "\(self.tab.rawValue).fill" : self.tab.rawValue)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 25, height: 25)
                .foregroundColor(self.currentTab == self.tab ? .primary : .gray)
        }
        .contentShape(Rectangle())
    }
}

struct LabelImpl: View {
    var tab: Tab
    @Binding var currentTab: Tab
    var animation: Namespace.ID
    var body: some View {
        Group {
            if self.currentTab == self.tab {
                // The label appears only for the selected tab.
                ZStack {
                    Text(self.tab.tabName)
                        .font(.footnote)
                        .foregroundColor(.primary)
                        .matchedGeometryEffect(id: "TAB_LABEL", in: self.animation)
                        .lineLimit(1)
                        .fixedSize(horizontal: true, vertical: true)
                        .allowsTightening(true)
                }.frame(width: 40)
            } else {
                EmptyView()
            }
        }
        // Reserve layout space (feel free to adjust the width).
        .frame(width: 50, alignment: .center)
    }
}

// MARK: - Preview

struct BottomBarView_Previews: PreviewProvider {
    static var previews: some View {
        let previewvm1 = OnboardingViewModel()
        let previewvm2 = RentViewModel()
        
        BottomBarView(onboardingVM: previewvm1, rentVM: previewvm2)
    }
}
