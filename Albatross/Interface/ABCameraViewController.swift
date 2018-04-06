//
//  ABCameraViewController.swift
//  Albatross
//
//  Created by Daniel Hsu on 3/31/18.
//  Copyright © 2018 Albatross. All rights reserved.
//

import UIKit
import AVFoundation

class ABCameraViewController: UIViewController {

    @IBOutlet var zeroStateLabel: UILabel!
    @IBOutlet var previewView: UIView!
    @IBOutlet var captureButton: UIButton!
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var capturePhotoOutput: AVCapturePhotoOutput?
    var capturedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        zeroStateLabel.isHidden = true
        setupCamera()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! ABImageCaptureViewController
        controller.capturedImage = capturedImage
    }
    
    @IBAction func captureButtonTapped(_ sender: UIButton) {
        if let capturePhotoOutput = capturePhotoOutput {
            let photoSettings = AVCapturePhotoSettings()
            photoSettings.isAutoStillImageStabilizationEnabled = true
            photoSettings.isHighResolutionPhotoEnabled = true
            photoSettings.flashMode = .off
            
            capturePhotoOutput.capturePhoto(with: photoSettings, delegate: self)
        }
    }
    
    private func setupCamera() {
        if let captureDevice = AVCaptureDevice.default(for: .video) {
            do {
                let input = try AVCaptureDeviceInput(device: captureDevice)
                captureSession = AVCaptureSession()
                captureSession!.addInput(input)
                
                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
                videoPreviewLayer!.videoGravity = .resizeAspectFill
                videoPreviewLayer!.frame = view.layer.bounds
                previewView.layer.insertSublayer(videoPreviewLayer!, at: 0)
                
                capturePhotoOutput = AVCapturePhotoOutput()
                capturePhotoOutput!.isHighResolutionCaptureEnabled = true
                captureSession!.addOutput(capturePhotoOutput!)
                
                captureSession!.startRunning()
            } catch {
                print(error)
            }
        } else {
            zeroStateLabel.isHidden = false
        }
    }
}

extension ABCameraViewController: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        guard error == nil, let photoSampleBuffer = photoSampleBuffer else {
            print("Error capturing photo: \(error!)")
            return
        }
        
        guard let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer) else {
            return
        }
        
        if let image = UIImage.init(data: imageData) {
            capturedImage = image
        }
    }
    
}

