// Asperi on StackOverflow
// https://stackoverflow.com/questions/59062886/how-to-using-realtime-camera-streaming-in-swiftui
import SwiftUI
import UIKit
import AVFoundation
import NotificationCenter

class PreviewView: UIView {
    private var captureSession: AVCaptureSession?
    private var photoOutput = AVCapturePhotoOutput()
    
    
    init() {
        super.init(frame: .zero)
        
        var allowedAccess = false
        let blocker = DispatchGroup()
        blocker.enter()
        AVCaptureDevice.requestAccess(for: .video) { flag in
            allowedAccess = flag
            blocker.leave()
        }
        blocker.wait()

        if !allowedAccess {
            print("!!! NO ACCESS TO CAMERA")
            return
        }

        // setup session
        let session = AVCaptureSession()
        session.beginConfiguration()

        let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
            for: .video, position: .front) //alternate AVCaptureDevice.default(for: .video)
        guard videoDevice != nil, let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!), session.canAddInput(videoDeviceInput) else {
            print("!!! NO CAMERA DETECTED")
            return
        }
        session.addInput(videoDeviceInput)
        session.commitConfiguration()
        self.captureSession = session
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.capture(notif:)), name: Notification.Name("CapturePhoto"), object: nil)
        
    }
    
    @objc func capture(notif: NSNotification){
        let image = self.takeScreenshot()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GotPhoto"), object: nil, userInfo: ["photo": image])
        
    }

    override class var layerClass: AnyClass {
        AVCaptureVideoPreviewLayer.self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()

        if nil != self.superview {
            self.videoPreviewLayer.session = self.captureSession
            self.videoPreviewLayer.videoGravity = .resizeAspect
            self.captureSession?.startRunning()
        } else {
            self.captureSession?.stopRunning()
        }
    }
}

struct PreviewHolder: UIViewRepresentable {
    @Binding var shouldTakePic : Bool
    func makeUIView(context: UIViewRepresentableContext<PreviewHolder>) -> PreviewView {
        return PreviewView()
    }

    func updateUIView(_ uiView: PreviewView, context: UIViewRepresentableContext<PreviewHolder>) {
    }

    typealias UIViewType = PreviewView
    
    class Coordinator : NSObject {

    }
    
    func makeCoordinator() -> PreviewHolder.Coordinator {
        Coordinator()
    }
}
