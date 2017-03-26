//
//  ViewController.swift
//  Unify3dCodeChallenge
//
//  Created by Forrest Zhao on 3/26/17.
//  Copyright © 2017 Forrest Zhao. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    
    var session: AVCaptureSession!
    var output: AVCapturePhotoOutput!
    
    var cameraTimer = Timer()
    var timeCounter = 5.0 // 5 seconds
    var repeatInterval = 0.5
    var timerRepeat = true
    var cameraImages: [UIImage] = [UIImage]()
    
    @IBOutlet weak var cameraView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSession()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func takePicPressed(_ sender: UIButton) {
        startCapture()
    }
    
    func setupSession() {
        session = AVCaptureSession()
        session.sessionPreset = AVCaptureSessionPreset1920x1080
        output = AVCapturePhotoOutput()
        
        let frontCameraDevice = AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .front)
        do {
            let input = try AVCaptureDeviceInput(device: frontCameraDevice)
            if (session.canAddInput(input)) {
                session.addInput(input)
                if (session.canAddOutput(output)) {
                    session.addOutput(output)
                    session.startRunning()
                    let captureVideoLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer.init(session: session)
                    captureVideoLayer.frame = cameraView.bounds
                    captureVideoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
                    cameraView.layer.addSublayer(captureVideoLayer)
                }
            }
        }
        catch {
            print(error)
        }
    }
    
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        if timeCounter == 0 {
            cameraTimer.invalidate()
            return
        } else {
            timeCounter -= repeatInterval
        }
        if let photoSampleBuffer = photoSampleBuffer {
            print("Capture called")
            let photoData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer)
            let image = UIImage(data: photoData!)
            guard let unwrapped = image else {
                fatalError("Error unwrapping taken image")
            }
            cameraImages.append(unwrapped)
        }
        
    }
    
    func takePhoto() {
        let settingsForMonitoring = AVCapturePhotoSettings()
        settingsForMonitoring.flashMode = .auto
        settingsForMonitoring.isAutoStillImageStabilizationEnabled = true
        settingsForMonitoring.isHighResolutionPhotoEnabled = false
        output?.capturePhoto(with: settingsForMonitoring, delegate: self)
    }
    
    func startCapture() {
        cameraTimer = Timer.scheduledTimer(timeInterval: repeatInterval, target: self, selector: #selector(takePhoto), userInfo: nil, repeats: timerRepeat)
    }

}
