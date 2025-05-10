//
//  SettingsView.swift
//  SnapChef
//
//  Created by Gavin Simmons on 5/9/25.
//

import SwiftUI

struct SettingsView: View {
    // Figure out other types of dietary restrictions to include
    @AppStorage("isVegetarian") private var isVegetarian = false
    @AppStorage("isGlutenFree") private var isGlutenFree = false
    @AppStorage("saveToLibrary") private var saveToLibrary = true
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Dietary Preferences")) {
                    Toggle("Vegetarian", isOn: $isVegetarian)
                    Toggle("Gluten-Free", isOn: $isGlutenFree)
                }
                
                Section(header: Text("Camera Settings")) {
                    Toggle("Save image to library", isOn: $saveToLibrary)
                }
                
                Section {
                    NavigationLink("About Snapchef") {
                        Text("Snapchef helps to reduce food waste by generating recipes using the food in your fridge.")
                            .padding()
                    }
                    Text("Version 1.0.0")
                        .foregroundColor(.secondary)
                }
            }
            navigationTitle("Settings")
        }
    }
}
