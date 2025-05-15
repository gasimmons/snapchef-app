//
//  RecipesView.swift
//  SnapChef
//
//  Created by Gavin Simmons on 5/9/25.
//

import SwiftUI

struct RecipesView: View {
    @State private var recipes: [Recipe] = []

    var body: some View {
        NavigationView {
            List(recipes) { recipe in
                VStack(alignment: .leading) {
                    Text(recipe.title)
                        .font(.headline)
                    Text(recipe.ingredients)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Saved Recipes")
            .onAppear {
                API.fetchRecipes { fetched in
                    self.recipes = fetched
                }
            }
        }
    }
}
