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
//                    .font(.system(.title, design: .rounded, weight: .bold))
                    .font(.custom("BubbleShineRegular", size: 100))
                    .fontWeight(.bold)
                    .opacity(0.75)
                    .multilineTextAlignment(.center)
                    .padding(32)
                    .foregroundColor(.black)
                Spacer()
                
//                Text("Logo here or something")
                Image("AppLogo")
                
                Spacer()
                
                Spacer()
//
                Spacer()
//
//                Form {
                    
                VStack {
                    TextField("Username", text: $vm.usernameInput)
                        .padding(16)
                        .background(Color.blue.opacity(0.05))
                        .cornerRadius(30)
                    
//                                        Divider()
                    Text("")
                    
                    SecureField("Password", text: $vm.passwordInput)
                        .textContentType(.password)
                        .padding(16)
                        .background(Color.blue.opacity(0.05))
                        .cornerRadius(30)
                    
                }
//                .background(Color.blue.opacity(0.05))
//                .cornerRadius(30)
                    
                    
                //}
//                .scrollContentBackground(.hidden)
//                .frame(maxWidth: .infinity)
                
                Spacer()
                Spacer()
                
                
                VStack {
                    
                    Button {
                        if (vm.usernameInput.isEmpty || vm.passwordInput.isEmpty) {
                            vm.fieldError()
                            /* ------------------------
                             This is for font debugging don't delete
                            for familyName in UIFont.familyNames {
                                print(familyName)
                                
                                for fontName in UIFont.fontNames(forFamilyName: familyName) {
                                    
                                    print("-- \(fontName)")
                                }
                            }
                             ------------------------ */
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
                
//                Spacer()
                
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
