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

class API {
    static let baseURL = "http://192.168.1.161:8080"

    static func fetchRecipes(completion: @escaping ([Recipe]) -> Void) {
        print("📡 Requesting /recipes")
        guard let url = URL(string: "\(baseURL)/recipes") else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data,
               let decoded = try? JSONDecoder().decode([Recipe].self, from: data) {
                DispatchQueue.main.async {
                    completion(decoded)
                }
            }
        }.resume()
    }

    static func addRecipe(title: String, ingredients: String) {
        guard let url = URL(string: "\(baseURL)/recipes") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let body = "title=\(title)&ingredients=\(ingredients)"
        request.httpBody = body.data(using: .utf8)

        URLSession.shared.dataTask(with: request) { _, _, _ in
            print("✅ Recipe posted")
        }.resume()
    }
}
