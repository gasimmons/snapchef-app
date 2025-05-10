//
//  RecipesView.swift
//  SnapChef
//
//  Created by Gavin Simmons on 5/9/25.
//

import SwiftUI

struct RecipesView: View {
    var body: some View {
        NavigationView {
            List {
                Text("🍕 Pizza")
                Text("🍣 Sushi")
            }
            .navigationTitle("Saved Recipes")
        }
    }
}
