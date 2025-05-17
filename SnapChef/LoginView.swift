//
//  LoginView.swift
//  SnapChef
//
//  Created by Gavin Simmons on 5/16/25.
//

import SwiftUI

struct AuthView: View {
    @State private var isLoginMode = true
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    @State private var isLoading = false
    @State private var userId: Int?

    var body: some View {
        if let userId = userId {
            RootView(userId: userId)
        } else {
            VStack(spacing: 20) {
                Picker(selection: $isLoginMode, label: Text("Login or Signup")) {
                    Text("Login").tag(true)
                    Text("Sign Up").tag(false)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.bottom)

                if !isLoginMode {
                    TextField("First Name", text: $firstName)
                        .textFieldStyle(.roundedBorder)

                    TextField("Last Name", text: $lastName)
                        .textFieldStyle(.roundedBorder)
                }

                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .textFieldStyle(.roundedBorder)

                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)

                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }

                Button(action: {
                    isLoginMode ? login() : signup()
                }) {
                    if isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding()
                    } else {
                        Text(isLoginMode ? "Login" : "Sign Up")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isLoginMode ? Color.blue : Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .disabled(email.isEmpty || password.isEmpty || (!isLoginMode && (firstName.isEmpty || lastName.isEmpty)))
            }
            .padding()
        }
    }

    func login() {
        isLoading = true
        errorMessage = nil

        guard let url = URL(string: "http://192.168.1.161:8080/login") else {
            errorMessage = "Invalid server URL"
            isLoading = false
            return
        }

        let payload = ["email": email, "password": password]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: payload)

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false

                if let error = error {
                    errorMessage = "Network error: \(error.localizedDescription)"
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                      let data = data,
                      let result = try? JSONDecoder().decode(LoginResponse.self, from: data) else {
                    errorMessage = "Invalid login"
                    return
                }

                self.userId = result.userId
            }
        }.resume()
    }

    func signup() {
        isLoading = true
        errorMessage = nil

        guard let url = URL(string: "http://192.168.1.161:8080/users") else {
            errorMessage = "Invalid server URL"
            isLoading = false
            return
        }

        let payload = [
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "password": password
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: payload)

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false

                if let error = error {
                    errorMessage = "Network error: \(error.localizedDescription)"
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                      let data = data,
                      let result = try? JSONDecoder().decode(LoginResponse.self, from: data) else {
                    errorMessage = "Signup failed"
                    return
                }

                self.userId = result.userId
            }
        }.resume()
    }

    struct LoginResponse: Decodable {
        let userId: Int
        let email: String
        let firstName: String
    }
}
    
    
