//
//  ViewController.swift
//  Unify3dCodeChallenge
//
//  Created by Forrest Zhao on 3/26/17.
//  Copyright © 2017 Forrest Zhao. All rights reserved.
//

import UIKit
import AVFoundation
import KeychainSwift
import RNCryptor


class ViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    
    var session: AVCaptureSession!
    var output: AVCapturePhotoOutput!
    
    var cameraTimer = Timer()
    var timeCounter = 5.0 // 5 seconds
    var repeatInterval = 0.5
    var timerRepeat = true
    var cameraImages: [UIImage] = [UIImage]()
    fileprivate var password = "abc123#@$"
    
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
        setupKeyChain()
        startCapture()
    }
    
    // - MARK: photo capture
    
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
            encryptPhoto(image: unwrapped)
        }
        
    }
    
    func takePhoto() {
        let settingsForMonitoring = AVCapturePhotoSettings()
        settingsForMonitoring.flashMode = .off
        settingsForMonitoring.isAutoStillImageStabilizationEnabled = true
        settingsForMonitoring.isHighResolutionPhotoEnabled = false
        output?.capturePhoto(with: settingsForMonitoring, delegate: self)
    }
    
    func startCapture() {
        cameraTimer = Timer.scheduledTimer(timeInterval: repeatInterval, target: self, selector: #selector(takePhoto), userInfo: nil, repeats: timerRepeat)
    }

    // - MARK: keychain photo encryption
    
    func setupKeyChain() {
        let keychain = KeychainSwift()
        keychain.set(password, forKey: "photos")
    }
    
    func encryptPhoto(image: UIImage) {
        
        let imagePathUrl = getDocumentsDirectory().appendingPathComponent("image.jpeg")
        if let compressedImage = UIImageJPEGRepresentation(image, 0.7) {
            let encryptedData = RNCryptor.encrypt(data: compressedImage, withPassword: password)
            print("Encrypting photo")
            do {
                try encryptedData.write(to: imagePathUrl)
            } catch let error {
                fatalError("error writing to file during encrypt: \(error)")
            }
        } else {
            fatalError("Error compressing image")
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }


}
