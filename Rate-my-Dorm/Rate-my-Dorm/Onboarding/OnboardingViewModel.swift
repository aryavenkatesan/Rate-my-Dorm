//
//  OnboardingViewModel.swift
//  Rate-my-Dorm
//
//  Created by Arya Venkatesan on 4/16/25.
//

import SwiftUI
import Foundation

class OnboardingViewModel: ObservableObject {
    @Published var usernameInput: String = ""
    @Published var passwordInput: String = ""
    @Published var isUserLoggedIn = false
    @Published var errormsg: String = ""
    @Published var schoolInput: String = "UNC Chapel Hill"
    
    let Schools: [String] = ["UNC Chapel Hill", "UNC Charlotte", "Duke", "NC State"]
    
    func signup() {
        //add API functionality
        print("---------------------------")
        print("Attempted Signup")
        print("Username: \(usernameInput)")
        print("Password: \(passwordInput)")
        print("School:")
        print("---------------------------")
        resetFields()
    }
    
    func login() {
        //add API functionality
        print("---------------------------")
        print("Attempted Login")
        print("Username: \(usernameInput)")
        print("Password: \(passwordInput)")
        print("---------------------------")
        resetFields()
        isUserLoggedIn = true
    }
    
    public func resetFields() {
        usernameInput = ""
        passwordInput = ""
    }
    
    public func fieldError() {
        errormsg = "Error: All fields must be filled"
    }
    
    public func loginError() {
        errormsg = "Error: Login failed. Incorrect Username or Password"
    }
    
    public func resetError() {
        errormsg = ""
    }
}
