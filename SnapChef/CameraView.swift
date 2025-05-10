//
//  CameraView.swift
//  SnapChef
//
//  Created by Gavin Simmons on 5/9/25.
//

import SwiftUI
import AVFoundation

struct CameraView: View {
    var body: some View {
        ZStack {
            Color.black
            Text("📷 Camera")
                .foregroundColor(.white)
                .font(.largeTitle)
        }
        .onAppear {
            requestCameraAuth()
        }
    }
    
    private func requestCameraAuth() {
        AVCaptureDevice.requestAccess(for: .video) {granted in
            if granted {
                print("Camera access granted")
            }
            else {
                print("Camera access denied")
            }
        }
    }
}
