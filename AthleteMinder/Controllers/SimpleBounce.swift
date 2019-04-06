//
//  SimpleBounce.swift
//  AthleteMinder
//
//  Created by Azhar Anwar on 4/6/19.
//  Copyright © 2019 Azhar Anwar. All rights reserved.
//

import UIKit
import AthleteMinderUI

class SimpleBounce: UIViewController {
    private let minimalHeight: CGFloat = 100
    
    private let maxWaveHeight: CGFloat = 50.0
    
    private let shapeLayer = CAShapeLayer()
    
    private var displayLink: CADisplayLink!
    
    private var isAnimating = false {
        didSet {
            view.isUserInteractionEnabled = !isAnimating
            displayLink.isPaused = !isAnimating
        }
    }
    
    private let l3ControlPointView = UIView()
    private let l2ControlPointView = UIView()
    private let l1ControlPointView = UIView()
    private let cControlPointView = UIView()
    private let r1ControlPointView = UIView()
    private let r2ControlPointView = UIView()
    private let r3ControlPointView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        shapeLayer.frame = CGRect(x: 0.0, y: view.bounds.height - minimalHeight, width: view.bounds.width, height: minimalHeight)
        shapeLayer.fillColor = UIColor.blue.cgColor
        shapeLayer.actions = ["position": NSNull(), "bounds": NSNull(), "path": NSNull()]
//        shapeLayer.transform = CATransform3DMakeRotation(.pi, 0.0, 0.0, 1.0)
        
        
        let mirrorUpsideDown = CGAffineTransform(scaleX: 1,
                                                 y: -1)
        shapeLayer.setAffineTransform(mirrorUpsideDown)
        
        view.layer.addSublayer(shapeLayer)
        
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panGestureDidMove)))
        
        l3ControlPointView.frame = CGRect(x: 0.0, y: 0.0, width: 3.0, height: 3.0)
        l2ControlPointView.frame = CGRect(x: 0.0, y: 0.0, width: 3.0, height: 3.0)
        l1ControlPointView.frame = CGRect(x: 0.0, y: 0.0, width: 3.0, height: 3.0)
        cControlPointView.frame = CGRect(x: 0.0, y: 0.0, width: 3.0, height: 3.0)
        r1ControlPointView.frame = CGRect(x: 0.0, y: 0.0, width: 3.0, height: 3.0)
        r2ControlPointView.frame = CGRect(x: 0.0, y: 0.0, width: 3.0, height: 3.0)
        r3ControlPointView.frame = CGRect(x: 0.0, y: 0.0, width: 3.0, height: 3.0)
        
//        l3ControlPointView.backgroundColor = .red
//        l2ControlPointView.backgroundColor = .red
//        l1ControlPointView.backgroundColor = .red
//        cControlPointView.backgroundColor = .red
//        r1ControlPointView.backgroundColor = .red
//        r2ControlPointView.backgroundColor = .red
//        r3ControlPointView.backgroundColor = .red
        
        view.addSubview(l3ControlPointView)
        view.addSubview(l2ControlPointView)
        view.addSubview(l1ControlPointView)
        view.addSubview(cControlPointView)
        view.addSubview(r1ControlPointView)
        view.addSubview(r2ControlPointView)
        view.addSubview(r3ControlPointView)
        
        displayLink = CADisplayLink(target: self, selector: #selector(updateShapeLayer))
        displayLink.add(to: .main, forMode: .default)
        displayLink.isPaused = true
    }
    
    @objc func panGestureDidMove(gesture: UIPanGestureRecognizer) {
        
        let location = gesture.location(in: view)
        let translation = gesture.translation(in: view)
        
        switch gesture.state {

        case .began, .changed:
            print("LOCATION",location)
            print("TRANSLATION", translation)
            print("SHAPE LAYER", shapeLayer.frame.origin)
    
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.3, options: [], animations: {
                self.shapeLayer.frame = CGRect(x: 0, y: location.y, width: self.view.bounds.width, height: self.view.bounds.height - location.y)
            }) { (_) in
                let additionalHeight = -(translation.y)
                let waveHeight = additionalHeight * 0.20
                let baseHeight = (self.view.bounds.height - location.y) - waveHeight
                let locationX = location.x
                
                self.layoutControlPoints(baseHeight: baseHeight, waveHeight: waveHeight, locationX: locationX)
                self.updateShapeLayer()
            }
            
//            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [], animations: {
//                self.shapeLayer.frame = CGRect(x: 0, y: location.y, width: self.view.bounds.width, height: max(self.view.bounds.height - location.y, self.minimalHeight))
//            }) { (_) in
//                //
//            }
//        case .ended:
//            shapeLayer.frame = CGRect(x: 0, y: location.y, width: view.bounds.width, height: max(view.bounds.height - location.y, minimalHeight))
        default:
            let centerY = view.bounds.height - location.y
            isAnimating = true
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.3, options: [], animations: {
                self.l3ControlPointView.center.y = centerY
                self.l2ControlPointView.center.y = centerY
                self.l1ControlPointView.center.y = centerY
                self.cControlPointView.center.y = centerY
                self.r1ControlPointView.center.y = centerY
                self.r2ControlPointView.center.y = centerY
                self.r3ControlPointView.center.y = centerY
            }) { (_) in
                self.shapeLayer.frame = CGRect(x: 0, y: location.y, width: self.view.bounds.width, height: centerY)
                self.isAnimating = false
            }
        }
    }
}

// Bezier code
extension SimpleBounce {
    
    private func currentPath() -> CGPath {
        let width = view.bounds.width
        let bezierPath = UIBezierPath()
        
        bezierPath.move(to: .zero)
        
        bezierPath.addLine(to: CGPoint(x: 0, y: l3ControlPointView.dg_center(usePresentationLayerIfPossible: isAnimating).y))
        
        bezierPath.addCurve(to: l1ControlPointView.dg_center(usePresentationLayerIfPossible: isAnimating), controlPoint1: l3ControlPointView.dg_center(usePresentationLayerIfPossible: isAnimating), controlPoint2: l2ControlPointView.dg_center(usePresentationLayerIfPossible: isAnimating))
        
        bezierPath.addCurve(to: r1ControlPointView.dg_center(usePresentationLayerIfPossible: isAnimating), controlPoint1: cControlPointView.dg_center(usePresentationLayerIfPossible: isAnimating), controlPoint2: r1ControlPointView.dg_center(usePresentationLayerIfPossible: isAnimating))
        
        bezierPath.addCurve(to: r3ControlPointView.dg_center(usePresentationLayerIfPossible: isAnimating), controlPoint1: r1ControlPointView.dg_center(usePresentationLayerIfPossible: isAnimating), controlPoint2: r2ControlPointView.dg_center(usePresentationLayerIfPossible: isAnimating))
        
        bezierPath.addLine(to: CGPoint(x: width, y: 0))
        
        bezierPath.close()
        
        return bezierPath.cgPath
    }
    
    @objc func updateShapeLayer() {
        shapeLayer.path = currentPath()
    }
    
    private func layoutControlPoints(baseHeight: CGFloat, waveHeight: CGFloat, locationX: CGFloat) {
        let width = view.bounds.width
        let minLeftX = min((locationX - width / 2.0) * 1.0, 0)
        let maxRightX = max(width + (locationX - width / 2.0) * 1.0, width)
        
        let leftPartWidth = locationX - minLeftX
        let rightPartWidth = maxRightX - locationX
        
        l3ControlPointView.center = CGPoint(x: minLeftX, y: baseHeight)
        l2ControlPointView.center = CGPoint(x: minLeftX + leftPartWidth * 0.44, y: baseHeight)
        l1ControlPointView.center = CGPoint(x: minLeftX + leftPartWidth * 0.71, y: baseHeight + waveHeight * 0.64)
        cControlPointView.center = CGPoint(x: locationX, y: baseHeight + waveHeight * 1.36)
        r1ControlPointView.center = CGPoint(x: maxRightX - rightPartWidth * 0.71, y: baseHeight + waveHeight * 0.64)
        r2ControlPointView.center = CGPoint(x: maxRightX - (rightPartWidth * 0.44), y: baseHeight)
        r3ControlPointView.center  = CGPoint(x: maxRightX, y: baseHeight)
    }
}