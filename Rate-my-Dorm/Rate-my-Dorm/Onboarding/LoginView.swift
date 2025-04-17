//
//  LoginView.swift
//  Rate-my-Dorm
//
//  Created by Arya Venkatesan on 4/15/25.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var vm: OnboardingViewModel
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Spacer()
                Text("Welcome!")
                    .font(.system(size:34, weight: .bold))
                    .multilineTextAlignment(.center)
                    .padding(32)
                    .foregroundColor(.black)
                Spacer()
                
                Text("Logo here or something")
                
                Spacer()
                
                Spacer()
                
                Spacer()
                
                TextField("Username", text: $vm.usernameInput)
                    .padding(16)
                Divider()
                SecureField("Password", text: $vm.passwordInput)
                    .textContentType(.password)
                    .padding(16)
                
                Spacer()
                
                VStack {
                    
                    Button {
                        if (vm.usernameInput.isEmpty || vm.passwordInput.isEmpty) {
                            vm.fieldError()
                        } else {
                            vm.login()
                            vm.resetError()
                        }
                    } label: {
                        Text("Login")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .font(.system(size: 17, weight: .bold))
                    }
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)
                    .padding(16)
                    
                   
                    NavigationLink("Signup", destination: SignupView(vm: vm))
                    
                    
                    Text("\(vm.errormsg)")
                        .foregroundColor(.red)
                        .padding(16)
                }
                
                Spacer()
                
                Spacer()
                
                Spacer()
                
            }
            .padding()
            .onAppear(perform: vm.resetError)
        }
    }
}
    

#Preview {
    @Previewable @StateObject var previewvm = OnboardingViewModel()
    LoginView(vm: previewvm)
}

