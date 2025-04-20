//
//  SignupView.swift
//  Rate-my-Dorm
//
//  Created by Arya Venkatesan on 4/15/25.
//

import SwiftUI

struct SignupView: View {
    @ObservedObject var vm: OnboardingViewModel
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Image(systemName: "face.smiling.inverse")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(Color.blue)
                    .opacity(0.7)
                
                Spacer()
                
//                Image("AppLogo")
                Text("Signup!")
                //                    .font(.system(.title, design: .rounded, weight: .bold))
                    .font(.custom("BubbleShineRegular", size: 100))
                    .fontWeight(.bold)
                    .opacity(0.75)
                    .multilineTextAlignment(.center)
                    .padding(32)
                    .foregroundColor(.black)
                
                
//                Spacer()
                
//                Spacer()
                
                Spacer()
                
                //            Divider()
                TextField("Username", text: $vm.usernameInput)
                    .padding(16)
                    .background(Color.blue.opacity(0.05))
                    .cornerRadius(30)
                //            Divider()
                SecureField("Password", text: $vm.passwordInput)
                    .textContentType(.password)
                    .padding(16)
                    .background(Color.blue.opacity(0.05))
                    .cornerRadius(30)
                //            Divider()
                Picker ("School", selection: $vm.schoolInput) {
                    ForEach(vm.Schools, id: \.self) { school in
                        Text(school)
                    }
                }
                .padding(.vertical, 8)
                
                
                
                Spacer()
                
                
                Button {
                    if (vm.usernameInput.isEmpty || vm.passwordInput.isEmpty) {
                        vm.fieldError()
                    } else {
                        Task {
                            await vm.signup()
//                            vm.resetError()
                        }
                    }
                } label: {
                    Text("Signup")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .font(.system(size: 17, weight: .bold))
                }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity)
                .padding(16)
                
                Text("\(vm.errormsg)")
                    .foregroundColor(.red)
                    .padding(16)
                
                
                Spacer()
                
                Spacer()
                
                Spacer()
                
            }
            .padding()
            .onAppear(perform: vm.resetAll)
        }
    }
}

#Preview {
    @Previewable @StateObject var previewvm = OnboardingViewModel()
    SignupView(vm: previewvm)
}
