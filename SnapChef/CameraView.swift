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
            } else {
                Color.black
                Text("Camera Access Needed")
                    .foregroundColor(.white)
            }

        }
        .onAppear {
            cameraManager.checkPermissionAndSetup()
        }
    }
}
