//
//  PeekabooViewController.swift
//  TriggertrapSLR
//
//  Created by Ross Gibson on 19/08/2014.
//  Copyright (c) 2014 Triggertrap Ltd. All rights reserved.
//

import UIKit

class PeekabooViewController: SensorViewController, FaceDetectorDelegate {
    
    // MARK: - Properties
    
    private var faceDetectionViewController: FaceDetectionViewController!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        faceDetectionViewController = self.childViewControllers.last as! FaceDetectionViewController
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        WearablesManager.sharedInstance.delegate = self
    }
    
    override func willMoveToParentViewController(parent: UIViewController?) {
        super.willMoveToParentViewController(parent)
        WearablesManager.sharedInstance.delegate = nil
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        faceDetectionViewController.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    @IBAction func shutterButtonTouchUpInside(sender : UIButton) {
        
        if sequenceManager.activeViewController == nil {
            if cameraPermissionAuthorized() {
                startCameraSensorMode()
            }
            
        } else {
            sequenceManager.cancel()
        }
    }
    
    override func startCameraSensorMode() { 
        if sufficientVolumeToTrigger() {
            self.prepareForSequence() 
            waitingForSensorResetDelay = false
            faceDetectionViewController.delegate = self
            sequenceManager.activeViewController = self
            startShutterButtonAnimation()
        }
    }
    
    // MARK: - Face Detector Delegate
    
     func facesDetected(faces: UInt) {
        // Start the sequence with the stored pulse length from the settings manager
        self.triggerNow()
    }
    
    // MARK: - Activity Manager Delegates
    override func didCancelSequence() {
        super.didCancelSequence()
        faceDetectionViewController.delegate = nil
    }
    
    override func performThemeUpdate() {
        super.performThemeUpdate()
        
        faceDetectionViewController.rotationButton?.setImage(ImageWithColor(UIImage(named: "Camera-Rotate")!, color: UIColor.triggertrap_fillColor()), forState: .Normal)
        
        applyThemeUpdateToPicker(faceDetectionViewController.picker)
    }
}

extension PeekabooViewController: WearableManagerDelegate {
    func watchDidTrigger() {
        self.shutterButtonTouchUpInside(UIButton())
    }
}
