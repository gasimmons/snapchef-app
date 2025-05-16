//
//  CameraView.swift
//  SnapChef
//
//  Created by Gavin Simmons on 5/9/25.
//

import SwiftUI
import AVFoundation

struct CameraView: View {
    @StateObject private var cameraManager = CameraManager()

    var body: some View {
        ZStack {
            if cameraManager.isAuthorized {
                CameraPreview(session: cameraManager.session)
                    .ignoresSafeArea()

                VStack {
                    Spacer()
                    Button(action: {
                        cameraManager.capturePhoto()
                    }) {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 70, height: 70)
                            .overlay(
                                Circle()
                                    .stroke(Color.gray, lineWidth: 2)
                            )
                    }
                    .padding(.bottom, 40)
                }
                
                // Need to run the cv model on the image
                // Print a list of identified foods
                // Also provide a text entry to provide more foods not scene or not detected
                if let image = cameraManager.capturedImage {
                    Color.black.opacity(0.6)
                        .ignoresSafeArea()
                    VStack {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding()

                        Button("Dismiss") {
                            cameraManager.capturedImage = nil
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                    }
                    .transition(.opacity)
                }
            } else {
                Color.black
                Text("Camera Access Needed")
                    .foregroundColor(.white)
            }

        }
        .onAppear {
            cameraManager.checkPermissionAndSetup()
        }
        .animation(.easeInOut, value: cameraManager.capturedImage)
    }
}
