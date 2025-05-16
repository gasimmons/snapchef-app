//
//  API.swift
//  SnapChef
//
//  Created by Gavin Simmons on 5/14/25.
//

import Foundation

struct Recipe: Codable, Identifiable {
    let id: Int
    let title: String
    let ingredients: String
}

struct NewRecipe: Codable {
    let title: String
    let ingredients: String
    let userId: Int
}

class API {
    static let baseURL = "http://192.168.1.161:8080"

    static func fetchRecipes(for userId: Int, completion: @escaping ([Recipe]) -> Void) {
        guard let url = URL(string: "\(baseURL)/recipes?userId=\(userId)") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Fetch error: \(error)")
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            do {
                let decoded = try JSONDecoder().decode([Recipe].self, from: data)
                DispatchQueue.main.async {
                    completion(decoded)
                }
            } catch {
                print("JSON decode error: \(error)")
                if let raw = String(data: data, encoding: .utf8) {
                    print("Raw response: \(raw)")
                }
            }
        }.resume()
    }

    static func addRecipe(title: String, ingredients: String, userId: Int) {
        guard let url = URL(string: "\(baseURL)/recipes") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let newRecipe = NewRecipe(title: title, ingredients: ingredients, userId: userId)

        guard let jsonData = try? JSONEncoder().encode(newRecipe) else {
            print("Failed to encode JSON")
            return
        }

        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Add recipe error: \(error)")
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("Status: \(httpResponse.statusCode)")
            }

            if let data = data, let str = String(data: data, encoding: .utf8) {
                print("Response: \(str)")
            }
        }.resume()
    }
}
