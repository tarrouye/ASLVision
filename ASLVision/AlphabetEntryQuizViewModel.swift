//
//  AlphabetEntryQuizViewModel.swift
//  ASLVision
//
//  Created by Théo Arrouye on 2/21/21.
//

import Foundation
import CoreML
import Vision
import UIKit
import NotificationCenter

enum AlphabetEntryQuizState {
    case ready, withAid, matchedOne, noAid, finished
}

class AlphabetEntryQuizViewModel : ObservableObject {
    @Published var startTime : Date?
    
    @Published var currentTimer : String?
    
    @Published var state : AlphabetEntryQuizState = .ready
    
    @Published var shouldCapture : Bool = false

    
    var currentAlphabetIndex : Int
    
    var withAidResult : TimeInterval?
    var noAidResult : TimeInterval?
    var classifying : Bool = false
    
    var entry : AlphabetEntry {
        return ALPHABET[currentAlphabetIndex]
    }
    
    var imgTest : UIImage = UIImage()
    
    
    lazy var classificationRequest: VNCoreMLRequest = {
        do {
            /*
             Use the Swift class `MobileNet` Core ML generates from the model.
             To use a different Core ML classifier model, add it to the project
             and replace `MobileNet` with that model's generated Swift class.
             */
            let model = try VNCoreMLModel(for: ALSClassifier().model)
            
            let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
                self?.processClassifications(for: request, error: error)
            })
            request.imageCropAndScaleOption = .centerCrop
            return request
        } catch {
            fatalError("Failed to load Vision ML model: \(error)")
        }
    }()
    
    @objc func gotPhoto(notif: NSNotification){
        guard let photo = (notif.userInfo?["photo"]) as? UIImage else{
            return
        }
        imgTest = photo
        print(photo)
        updateClassifications(for: photo)
    }
    
    /// - Tag: PerformRequests
    func updateClassifications(for image: UIImage) {
        guard !classifying else {
            return
        }
        self.classifying = true
        print( "Classifying...")
        
        
        let orientation = CGImagePropertyOrientation(image.imageOrientation)
        guard let ciImage = CIImage(image: image) else { fatalError("Unable to create \(CIImage.self) from \(image).") }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation)
            do {
                try handler.perform([self.classificationRequest])
            } catch {
                /*
                 This handler catches general image processing errors. The `classificationRequest`'s
                 completion handler `processClassifications(_:error:)` catches errors specific
                 to processing that request.
                 */
                
                self.classifying = false
                print("Failed to perform classification.\n\(error.localizedDescription)")
            }
        }
    }
    
    /// Updates the UI with the results of the classification.
    /// - Tag: ProcessClassifications
    func processClassifications(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let results = request.results else {
                print("Unable to classify image.\n\(error!.localizedDescription)")
                self.classifying = false
                return
            }
            // The `results` will always be `VNClassificationObservation`s, as specified by the Core ML model in this project.
            let classifications = results as! [VNClassificationObservation]
        
            if classifications.isEmpty {
                print("Nothing recognized.")
                self.classifying = false
            } else {
                // Display top classifications ranked by confidence in the UI.
                let topClassification = classifications[0]
                print(topClassification.identifier)
                if (topClassification.identifier == self.entry.char.uppercased()){
                    
                    
                    self.matched()
                    
                }
                
                self.classifying = false
            }
        }
    }
    
    
    private var timer: Timer?
    
    init() {
        self.startTime = nil
        self.currentTimer = nil
        self.withAidResult = nil
        self.noAidResult = nil
        self.currentAlphabetIndex = 0
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) {
           _ in self.updateTimer()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.gotPhoto(notif:)), name: Notification.Name("GotPhoto"), object: nil)
    }
    
    func setIndex(_ ind: Int) {
        self.currentAlphabetIndex = ind
    }
    
    func reset(_ ind: Int) {
        self.startTime = nil
        self.currentTimer = nil
        self.withAidResult = nil
        self.noAidResult = nil
        self.currentAlphabetIndex = ind
        
        self.state = .ready
    }
    
    @objc func updateTimer() {
        if (self.startTime != nil) {
            self.currentTimer = timeToString(Date().timeIntervalSince(self.startTime!))
        } else {
            self.currentTimer = nil
        }
        
        
        
        // remove later, auto match for testing
        if ((state == .withAid || state == .noAid) && !self.classifying) {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CapturePhoto"), object: nil, userInfo: nil)
        }
    }
    
    func startTimer() {
        startTime = Date()
    }
    
    func startWithAid() {
        state = .withAid
        
        startTimer()
    }
    
    func startNoAid() {
        state = .noAid
        
        startTimer()
    }
    
    func timeToString(_ tmir: TimeInterval?) -> String {
        if let tmr = tmir {
            return String(format: "%.2f", tmr) + " s"
        }
        
        return "----"
    }
    
    func matched() {
        let time = Date().timeIntervalSince(startTime!)
        
        if (state == .withAid) {
            withAidResult = time
            state = .matchedOne
        } else if (state == .noAid) {
            noAidResult = time
            state = .finished
        }
    }
}
