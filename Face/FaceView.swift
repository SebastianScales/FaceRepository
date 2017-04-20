//
//  FaceView.swift
//  Face
//
//  Created by Madison Heck on 3/20/17.
//  Copyright © 2017 SebastianScales. All rights reserved.
//

import UIKit

@IBDesignable

class FaceView: UIView {

    @IBInspectable
    var scale: CGFloat = 0.9 { didSet { setNeedsDisplay() } }
    @IBInspectable
    var eyesOpen: Bool = true { didSet { setNeedsDisplay() } }
    @IBInspectable
    var mouthCurvature: Double = -1.0 { didSet { setNeedsDisplay() } } //1.0 is full smile , -1.0 is full frown
    @IBInspectable
    var linewidth: CGFloat = 5.0 { didSet { setNeedsDisplay() } }
    @IBInspectable
    var color: UIColor = UIColor.blue { didSet { setNeedsDisplay() } }
    
    func changeScale(recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .changed, .ended:
            scale *= recognizer.scale
            recognizer.scale = 1.0
        default:
            break
        }
    }
    
    fileprivate var skullRadius: CGFloat{
        return min(bounds.size.width, bounds.size.height) / (2 * scale)
    }
    
    fileprivate var skullCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    fileprivate enum Eye {
        case left
        case right
    }
    
    fileprivate func pathForEye (_ eye: Eye) -> UIBezierPath {
        
        func centerOfEye (_ eye: Eye) -> CGPoint {
            let eyeOffset = skullRadius / Ratios.skullRadiusToEyeOffset
            var eyeCenter = skullCenter
            eyeCenter.y -= eyeOffset
            eyeCenter.x += ((eye == .left) ? -1 : 1) * eyeOffset
            return eyeCenter
            
        }
        
        
        let eyeRadius = skullRadius / Ratios.skullRadiusToEyeRadius
        let eyeCenter = centerOfEye(eye)
        
        
        let start = CGPoint(x: eyeCenter.x - eyeRadius, y: eyeCenter.y)
        let end = CGPoint(x: eyeCenter.x + eyeRadius, y: eyeCenter.y)
        
        let cp1 = CGPoint(x: start.x + eyeRadius/2, y: start.y - eyeRadius/2)
        let cp2 = CGPoint(x: end.x - eyeRadius/2, y: start.y - eyeRadius/2)
        
     //  let cp3 = CGPoint(x: start.x + eyeRadius/2, y: start.y + eyeRadius/2)
     //  let cp4 = CGPoint(x: end.x - eyeRadius/2, y: start.y + eyeRadius/2)
        
        let path:UIBezierPath
     //   let path2:UIBezierPath
        if eyesOpen {
            path = UIBezierPath(arcCenter: eyeCenter, radius: eyeRadius, startAngle: 0, endAngle: CGFloat(M_PI) * 2, clockwise: true)
       //    path2 = UIBezierPath()
        } else {
            path = UIBezierPath()
            path.move(to:start)
            path.addCurve(to:end, controlPoint1: cp1, controlPoint2: cp2)
            
    
       //     path2 = UIBezierPath()
       //     path2.move(to:start)
       //     path.addCurve(to:end, controlPoint1: cp3, controlPoint2: cp4)
            
            
       //     path2.move(to: CGPoint(x: eyeCenter.x - eyeRadius, y: eyeCenter.y))
       //     path2.addLine(to: CGPoint(x: eyeCenter.x + eyeRadius, y:eyeCenter.y))
        }
        
        path.lineWidth = linewidth
      //  path2.lineWidth = linewidth
        return path
    
    }
    
    fileprivate func pathForSkull() -> UIBezierPath {
        let path = UIBezierPath(arcCenter: skullCenter, radius: skullRadius, startAngle: 0, endAngle: 2 * CGFloat(M_PI), clockwise: false)
        path.lineWidth = linewidth
        return path
    }
    
    fileprivate func pathForMouth() -> UIBezierPath {
        let mouthWidth = skullRadius / Ratios.skullRadiusToMouthWidth
        let mouthHeight = skullRadius / Ratios.skullRadiusToMouthHeight
        let mouthOffset = skullRadius / Ratios.skullRadiusToMouthOffset
        
        let mouthRect = CGRect(x: skullCenter.x - mouthWidth / 2, y: skullCenter.y + mouthOffset, width: mouthWidth, height: mouthHeight)
        
        let smileOffset = CGFloat(max(-1, min(mouthCurvature, 1))) * mouthRect.height
    
        let start = CGPoint(x: mouthRect.minX, y: mouthRect.midY)
        let end = CGPoint(x: mouthRect.maxX, y: mouthRect.midY)
        
        let cp1 = CGPoint(x: start.x + mouthRect.width / 3, y: start.y + smileOffset)
        let cp2 = CGPoint(x: end.x - mouthRect.width / 3, y: start.y + smileOffset)

        let path = UIBezierPath()
        path.move(to: start)
        path.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
        
        path.lineWidth = linewidth
        
        return path
        print("hi")
    }
    

    override func draw(_ rect: CGRect) {
      
        let path = UIBezierPath(arcCenter: skullCenter, radius: skullRadius, startAngle: 0, endAngle: 2 * CGFloat(M_PI), clockwise: false)
        path.lineWidth = linewidth
        color.set()
        pathForSkull().stroke()
        pathForEye(.left).stroke()
        pathForEye(.right).stroke()
        pathForMouth().stroke()
    }

    fileprivate struct Ratios {
        static let skullRadiusToEyeOffset: CGFloat = 3
        static let skullRadiusToEyeRadius: CGFloat = 10
        static let skullRadiusToMouthWidth: CGFloat = 1
        static let skullRadiusToMouthHeight: CGFloat = 3
        static let skullRadiusToMouthOffset: CGFloat = 3
        static let skullRadiusToTeardrop: CGFloat = 15
    }

}
