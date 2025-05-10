//
//  CameraManager.swift
//  SnapChef
//
//  Created by Gavin Simmons on 5/10/25.
//

import AVFoundation
import Combine

class CameraManager: NSObject, ObservableObject {
    let session = AVCaptureSession()
    @Published var isAuthorized = false

    func checkPermissionAndSetup() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            self.isAuthorized = true
            setupSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    self.isAuthorized = granted
                    if granted {
                        self.setupSession()
                    }
                }
            }
        default:
            self.isAuthorized = false
        }
    }

    private func setupSession() {
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let input = try? AVCaptureDeviceInput(device: camera),
              session.canAddInput(input)
        else { return }

        session.beginConfiguration()
        session.addInput(input)

        let output = AVCaptureVideoDataOutput()
        if session.canAddOutput(output) {
            session.addOutput(output)
        }

        session.commitConfiguration()
        session.startRunning()
    }
}
