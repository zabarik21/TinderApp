//
//  MessagerViewController.swift
//  TinderApp
//
//  Created by Timofey on 27/5/22.
//

import UIKit



class MessagerViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    
    let arc = CAShapeLayer()
    
    arc.strokeColor = UIColor.black.cgColor
    arc.lineWidth = 10
    arc.fillColor = UIColor.clear.cgColor
    
    self.view.layer.addSublayer(arc)
    
    
    
    // try animating path
    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
      arc.path = UIBezierPath(arcCenter: self.view.center, radius: 100, startAngle: 0, endAngle: CGFloat(180).degreesToRadians, clockwise: true).cgPath
    }
  }
  
  
  
}
