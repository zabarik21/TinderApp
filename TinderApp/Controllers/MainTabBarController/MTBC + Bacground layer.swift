//
//  MTBC + Bacground layer.swift
//  TinderApp
//
//  Created by Timofey on 30/5/22.
//

import UIKit



extension MainTabBarController {
    
    func setupHeaderOvalLayer() {
        let width = view.bounds.width * 1.289
        let height = Constants.ovalHeight
        let path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: Int(width), height: height)).cgPath
        

        headerOvalLayerMask.path = path
        headerOvalLayerMask.frame.origin.x = self.view.center.x - width / 2
        headerOvalLayerMask.frame.origin.y = -82
        
        // Gradient layer setup
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(named: "firstGradientColor")!.cgColor,
            UIColor(named: "secondGradientColor")!.cgColor
        ]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        // visible gradient will be on this frame
        gradientLayer.frame = CGRect(x: 0, y: 0, width: Int(width), height: height)
        
        gradientLayer.mask = headerOvalLayerMask

        self.view.layer.addSublayer(gradientLayer)
    }
    
}
