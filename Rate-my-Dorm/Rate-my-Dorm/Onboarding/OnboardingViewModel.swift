//
//  OnboardingViewModel.swift
//  Rate-my-Dorm
//
//  Created by Arya Venkatesan on 4/16/25.
//

import SwiftUI
import Foundation

@MainActor
class OnboardingViewModel: ObservableObject {
    @Published var usernameInput: String = ""
    @Published var passwordInput: String = ""
    @Published var isUserLoggedIn = false
    @Published var errormsg: String = ""
    @Published var schoolInput: String = "UNC Chapel Hill"
    @Published var userID: String = ""
    @Published var AuthToken: String = ""
    
    let Schools: [String] = ["UNC Chapel Hill", "UNC Charlotte", "Duke", "NC State"]
    
    func signup() async {
//        //add API functionality
//        print("---------------------------")
//        print("Attempted Signup")
//        print("Username: \(usernameInput)")
//        print("Password: \(passwordInput)")
//        print("School:")
//        print("---------------------------")
//        
//        
        do {
            let response = try await OnboardingModel.signupAPIRequest(usernameInput: usernameInput, passwordInput: passwordInput, schoolInput: schoolInput)
            if response.stackTrace == nil {
                AuthToken = response.accessToken!
                userID = response._id!
                isUserLoggedIn = true
            } else {
                errormsg = "Error: \(response.message!)"
            }
        } catch {
            errormsg = "Error: Something went wrong"
        }
        
        //resetFields()
    }
    
    func login() async {
        //add API functionality
//        print("---------------------------")
//        print("Attempted Login")
//        print("Username: \(usernameInput)")
//        print("Password: \(passwordInput)")
//        print("---------------------------")
        
        do {
            let response = try await OnboardingModel.loginAPIRequest(usernameInput: usernameInput, passwordInput: passwordInput)
            if response.stackTrace == nil {
                AuthToken = response.accessToken!
                userID = response._id!
                isUserLoggedIn = true
            } else {
                errormsg = "Error: \(response.message!)"
            }
        } catch {
            errormsg = "Error: Something went wrong"
        }
        
        //resetFields()
        //should fields be reset after clicking the button?
        //instagram.com doesn't so ill leave it commented
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
    
    public func resetAll() {
        resetError()
        resetFields()
    }
    
    public func resetError() {
        errormsg = ""
    }
    
    public func logout() {
        isUserLoggedIn = false
        userID = ""
        AuthToken = ""
        resetAll()
    }
}
