//
//  SettingsView.swift
//  SnapChef
//
//  Created by Gavin Simmons on 5/9/25.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            Form {
                Toggle("Dark Mode", isOn: .constant(false))
                NavigationLink("About", destination: Text("SnapChef v1.0"))
            }
            .navigationTitle("Settings")
        }
    }
}
