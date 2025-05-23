//
//  RootView.swift
//  SnapChef
//
//  Created by Gavin Simmons on 5/9/25.
//

import SwiftUI

struct RootView: View {
    let userId: Int
    @State private var selectedTab = 1
    
    
    var body: some View {
        TabView(selection: $selectedTab) {
            RecipesView(userId: userId).tag(0)
            CameraView().tag(1)
            SettingsView().tag(2)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .ignoresSafeArea()
    }
}


