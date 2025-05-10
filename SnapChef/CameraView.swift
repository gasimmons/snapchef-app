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
