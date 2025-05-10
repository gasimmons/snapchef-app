//
//  CameraManager.swift
//  SnapChef
//
//  Created by Gavin Simmons on 5/10/25.
//

import AVFoundation
import Combine
import UIKit

class CameraManager: NSObject, ObservableObject {
    let session = AVCaptureSession()
    private let photoOutput = AVCapturePhotoOutput()
    @Published var capturedImage: UIImage?
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
        else {
            return
        }

        session.beginConfiguration()
        session.addInput(input)

        if session.canAddOutput(photoOutput) {
            session.addOutput(photoOutput)
        }

        session.commitConfiguration()
        
        DispatchQueue.global(qos: .userInitiated).async {
            print("Startin camera session")
            self.session.startRunning()
        }
    }

    func capturePhoto() {
        print("📸 capturePhoto() called")
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
}

extension CameraManager: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: Error?) {
        guard let data = photo.fileDataRepresentation(),
              let image = UIImage(data: data) else {
            print("❌ Failed to convert photo data")
            return
        }

        DispatchQueue.main.async {
            self.capturedImage = image
            print("📸 Photo captured")
        }
    }
}
