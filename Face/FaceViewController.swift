//
//  ViewController.swift
//  Face
//
//  Created by Madison Heck on 3/20/17.
//  Copyright © 2017 SebastianScales. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var faceView: FaceView! {
        didSet{
            let handler = #selector(FaceView.changeScale(recognizer:))
            let pinchRecognizer = UIPinchGestureRecognizer(target: faceView, action:handler)
            faceView.addGestureRecognizer(pinchRecognizer)
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleEyes(byReactingTo:)))
            tapRecognizer.numberOfTapsRequired = 1
            faceView.addGestureRecognizer(tapRecognizer)
            
            updateUI()
        }
    }
   
    func toggleEyes(byReactingTo tapRecognizer: UITapGestureRecognizer) {
        if tapRecognizer.state == .ended {
            let eyes: FacialExpressions.Eyes = (expression.eyes == .closed) ? .open : .closed
            
            expression = FacialExpressions(eyes: eyes, mouth: expression.mouth)
        }
    }
    var expression = FacialExpressions(eyes: .closed, mouth: .smile) {
        didSet {
            updateUI()
        }
    }
    
    fileprivate func updateUI() {
        switch expression.eyes {
        case .open:
            faceView?.eyesOpen = true
        case .closed:
            faceView?.eyesOpen = false
        case .squinting:
            faceView?.eyesOpen = false
        
        faceView.mouthCurvature = mouthCurvatures[expression.mouth] ?? 0.0
        default: break
        }
    }
    
    fileprivate let mouthCurvatures = [FacialExpressions.Mouth.grin:0.5, .frown:-1.0, .smile:1.0,.smirk: -0.5]


}

