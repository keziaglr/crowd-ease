//
//  CameraViewModel.swift
//  NC3Trial
//
//  Created by Kezia Gloria on 21/07/23.
//

import Cocoa
import AVKit
import CoreImage
import CoreVideo
import CoreML

class CameraViewModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    private let crowdClassifierModel = CrowdClassifier()
    
    @Published var personCount: Int = 0
    @Published var capturedImage: NSImage?
    @Published var selectedImage: NSImage?
    @Published var crowdSizeLabel: String? = "Unknown" // Add crowdSizeLabel property


    private var captureSession: AVCaptureSession?
    private var photoOutput: AVCapturePhotoOutput?

    override init() {
        super.init()
        checkForPermissions()
    }

    func checkForPermissions() {
        let authorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch authorizationStatus {
        case .authorized:
            setupCaptureSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                if granted {
                    self?.setupCaptureSession()
                } else {
                    print("Camera access denied.")
                }
            }
        default:
            print("Camera access denied.")
        }
    }
    
    private func setupCaptureSession() {
        guard let camera = AVCaptureDevice.default(for: .video) else {
            print("Camera not available.")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: camera)
            let session = AVCaptureSession()
            session.addInput(input)
            
            let photoOutput = AVCapturePhotoOutput()
            session.addOutput(photoOutput)
            self.photoOutput = photoOutput
            
            let previewLayer = AVCaptureVideoPreviewLayer(session: session)
            previewLayer.videoGravity = .resizeAspectFill
            DispatchQueue.main.async {
                self.previewLayer = previewLayer
            }
            
            session.startRunning()
            self.captureSession = session
        } catch {
            print("Error setting up the capture session: \(error.localizedDescription)")
        }
    }
    
    // AVCaptureVideoPreviewLayer to be used in CameraPreview
    @Published var previewLayer: AVCaptureVideoPreviewLayer?
    
    // Method to capture an image
    func captureImage() {
        guard let photoOutput = photoOutput else {
            print("Photo output is not available.")
            return
        }
        
        let photoSettings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: photoSettings, delegate: self)
    }
    
    // Method to select an image from the gallery
    func selectImage() {
        let openPanel = NSOpenPanel()
        openPanel.allowedFileTypes = ["public.image"]
        openPanel.allowsMultipleSelection = false
        
        if openPanel.runModal() == NSApplication.ModalResponse.OK {
            guard let imageURL = openPanel.urls.first, let image = NSImage(contentsOf: imageURL) else {
                print("Error loading image.")
                return
            }
            
            selectedImage = image
            
            // Convert NSImage to CIImage
            if let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) {
                let ciImage = CIImage(cgImage: cgImage)
                
                // Convert CIImage back to NSImage to use it for crowd size detection
                if let nsImage = self.nsImage(from: ciImage) {
                    // Perform crowd size detection using the CrowdClassifier model on the selected image
                    detectCrowdSize(in: nsImage) { [weak self] crowdSize in
                        DispatchQueue.main.async {
                            self?.crowdSizeLabel = crowdSize
                        }
                    }
                }
            }
        }
    }
    
    // Computed property to return the appropriate image for preview
        var previewImage: NSImage? {
            return selectedImage ?? capturedImage
        }

    // Method to convert CIImage to NSImage
    private func nsImage(from ciImage: CIImage) -> NSImage? {
        let rep = NSCIImageRep(ciImage: ciImage)
        let nsImage = NSImage(size: rep.size)
        nsImage.addRepresentation(rep)
        return nsImage
    }


    
    // AVCapturePhotoCaptureDelegate method
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            print("Error capturing photo: \(error.localizedDescription)")
            return
        }
        
        guard let imageData = photo.fileDataRepresentation(), let image = NSImage(data: imageData) else {
            print("Error converting photo data to NSImage.")
            return
        }
        
        capturedImage = image
        
        // Convert NSImage to CIImage
        if let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) {
            let ciImage = CIImage(cgImage: cgImage)
            
            // Convert CIImage back to NSImage to use it for crowd size detection
            if let nsImage = self.nsImage(from: ciImage) {
                // Perform crowd size detection using the CrowdClassifier model on the selected image
                detectCrowdSize(in: nsImage) { [weak self] crowdSize in
                    DispatchQueue.main.async {
                        self?.crowdSizeLabel = crowdSize
                    }
                }
            }
        }
    }
    
    // Method to convert NSImage to CVPixelBuffer
    private func pixelBuffer(from image: NSImage) -> CVPixelBuffer? {
        guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            print("Error converting NSImage to CGImage.")
            return nil
        }
        
        let options: [CIImageOption: Any] = [CIImageOption.applyOrientationProperty: false]
        let ciImage = CIImage(cgImage: cgImage, options: options)
        
        var pixelBuffer: CVPixelBuffer?
        CVPixelBufferCreate(kCFAllocatorDefault,
                            Int(ciImage.extent.width),
                            Int(ciImage.extent.height),
                            kCVPixelFormatType_32ARGB,
                            nil,
                            &pixelBuffer)
        
        let context = CIContext()
        context.render(ciImage, to: pixelBuffer!)
        
        return pixelBuffer
    }
    
    // Method to detect crowd size using the CrowdClassifier model
    func detectCrowdSize(in image: NSImage, completion: @escaping (String?) -> Void) {
        guard let pixelBuffer = pixelBuffer(from: image) else {
            completion(nil)
            return
        }
        
        do {
            // Make predictions using the CrowdClassifier model
            let crowdClassifierInput = CrowdClassifierInput(image: pixelBuffer)
            let crowdClassifierOutput = try crowdClassifierModel.prediction(input: crowdClassifierInput)
            
            // Check if "hundreds" exists in the predicted crowd size labels
            if crowdClassifierOutput.classLabelProbs["Hundreds"]! > 0.01 {
                crowdSizeLabel = "Penuh" // Set crowdSizeLabel to "Hundreds"
            } else {
                // Get the predicted crowd size label with the highest probability
                var highestProbability: Double = 0
                var crowdSize: String?
                for (label, probability) in crowdClassifierOutput.classLabelProbs {
                    if probability > highestProbability {
                        highestProbability = probability
                        crowdSize = label
                    }
                }
                
                crowdSizeLabel = "Tersedia" // Update crowdSizeLabel property
            }
            
            completion(crowdSizeLabel)
        } catch {
            print("Error making predictions with CrowdClassifier model: \(error.localizedDescription)")
            completion(nil)
        }
    }


}
