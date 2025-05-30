//
//  OnboardingModel.swift
//  Rate-my-Dorm
//
//  Created by Arya Venkatesan on 4/18/25.
//
import SwiftUI

enum OnboardingModel {
    static let decoder = JSONDecoder()
    static let encoder = JSONEncoder()
    
    static let baseUrl = "https://rmd.aryav.systems:5001/"
    
    static func signupAPIRequest(usernameInput: String, passwordInput: String, schoolInput: String) async throws -> LoginResponseJSON {
        let workingUrl = baseUrl + "api/users/register"
        guard let url = URL(string: workingUrl) else {
            fatalError("Invalid URL")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let json: [String: String] = [
            "username": usernameInput,
            "school": schoolInput,
            "password": passwordInput
        ]
        let encoded: Data = try encoder.encode(json)
        request.httpBody = encoded
        
        let (data, response) = try await URLSession.shared.data(for: request)
        let signupData = try decoder.decode(LoginResponseJSON.self, from: data)
        
        let httpResponse = response as! HTTPURLResponse
        if httpResponse.statusCode <= 299 {
            return try await loginAPIRequest(usernameInput: usernameInput, passwordInput: passwordInput)
        }
        
        return signupData
    }
    
    static func loginAPIRequest(usernameInput: String, passwordInput: String) async throws -> LoginResponseJSON {
        print("here")
        let workingUrl = baseUrl + "api/users/login"
        guard let url = URL(string: workingUrl) else {
            fatalError("Invalid URL")
        }
        print("here")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        print("here")
        let json: [String: String] = [
            "username": usernameInput,
            "password": passwordInput
        ]
        let encoded: Data = try encoder.encode(json)
        request.httpBody = encoded
        print("here")
        let (data, response) = try await URLSession.shared.data(for: request)
        let loginData = try decoder.decode(LoginResponseJSON.self, from: data)
        print("here")
        let httpResponse = response as! HTTPURLResponse
        
        if httpResponse.statusCode <= 299 {
            // 200-299 is a success
            return loginData
        }
        print(loginData)
        
        return loginData
    }
}

struct LoginResponseJSON: Decodable {
    let accessToken: String?
    let _id: String?
    let school: String?
    let title: String?
    let message: String?
    let stackTrace: String?
}
