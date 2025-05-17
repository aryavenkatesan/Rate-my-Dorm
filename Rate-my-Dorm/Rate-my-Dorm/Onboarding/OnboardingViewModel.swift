//
//  OnboardingViewModel.swift
//  Rate-my-Dorm
//
//  Created by Arya Venkatesan on 4/16/25.
//

import Foundation
import SwiftUI

@MainActor
class OnboardingViewModel: ObservableObject {
    @Published var usernameInput: String = ""
    @Published var passwordInput: String = ""
    @Published var isUserLoggedIn = false
    @Published var errormsg: String = ""
    @Published var schoolInput: String = "UNC Chapel Hill"
    @Published var userID: String = ""
    @Published var AuthToken: String = ""
    @Published var usernameActual: String = "A"
    var schoolActual: String = "UNC Chapel Hill"
    var infoBus: profileInfoForApi = profileInfoForApi(username: "", school: "", jwt: "")
    
    let Schools: [String] = ["UNC Chapel Hill", "UNC Charlotte", "Duke", "NC State"]
    
    func signup() async {
        do {
            let response = try await OnboardingModel.signupAPIRequest(usernameInput: usernameInput, passwordInput: passwordInput, schoolInput: schoolInput)
            if response.stackTrace == nil {
                AuthToken = response.accessToken!
                userID = response._id!
                usernameActual = usernameInput
                infoBus = profileInfoForApi(username: usernameInput, school: schoolInput, jwt: AuthToken)
                isUserLoggedIn = true
            } else {
                errormsg = "Error: \(response.message!)"
            }
        } catch {
            errormsg = "Error: Something went wrong"
        }
    }
    
    func login() async {
        do {
            let response = try await OnboardingModel.loginAPIRequest(usernameInput: usernameInput, passwordInput: passwordInput)
            if response.stackTrace == nil {
                AuthToken = response.accessToken!
                userID = response._id!
                usernameActual = usernameInput
                schoolActual = response.school!
                infoBus = profileInfoForApi(username: usernameInput, school: schoolInput, jwt: AuthToken)
                isUserLoggedIn = true
            } else {
                errormsg = "Error: \(response.message!)"
            }
        } catch {
            errormsg = "Error: Something went wrong"
        }
        
        // resetFields()
        // should fields be reset after clicking the button?
        // instagram.com doesn't so ill leave it commented
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
    public func timedout() { //pass as closure to the rent ViewModel
        logout()
        errormsg = "Session timed out, please log in again"
    }
}
