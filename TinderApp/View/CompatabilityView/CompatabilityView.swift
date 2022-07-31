//
//  CompatabilityView.swift
//  TinderApp
//
//  Created by Timofey on 12/6/22.
//

import Foundation
import UIKit


enum CompatabilityViewConstants {
  static var strokeWidth: CGFloat = 7
}

class CompatabilityView: UIView {

  public var compatability: Int! {
    didSet {
      updateScore()
    }
  }
  
  private var scoreLayer = CAShapeLayer()
  private var circleLayer = CAShapeLayer()
  private var scoreLabel: UILabel!
  private var viewCenter: CGPoint!
  
  override func layoutSubviews() {
    super.layoutSubviews()
    viewCenter = CGPoint(x: CGFloat(self.bounds.width / 2), y: CGFloat(self.bounds.height / 2))
    self.layer.cornerRadius = self.bounds.height / 2
  }
  
  init() {
    super.init(frame: .zero)
    self.setupElements()
  }
  
  private func updateScore() {
    var strokeColor: CGColor {
      switch compatability {
      case _ where compatability < 3:
        return UIColor.lowCompatabilityColor.cgColor
      case _ where compatability < 6:
        return UIColor.medCompatabilityColor.cgColor
      default:
        return UIColor.highCompatabilityColor.cgColor
      }
    }
    scoreLayer.strokeColor = strokeColor
    scoreLayer.lineCap = .round
    
    
    DispatchQueue.global().async {
      while self.viewCenter == nil {}
      DispatchQueue.main.async { [weak self] in
        guard let self = self else { return }
        self.circleLayer.path = self.configurePath(forBackground: true)
        self.scoreLayer.path = self.configurePath()
      }
    }
    
    scoreLabel.text = "\(Int(compatability))"
  }
  
  private func configurePath(forBackground: Bool = false) -> CGPath {
    let angle = CGFloat((360 * self.compatability / 10) + 270)
    let radius = self.bounds.height / 2 - CompatabilityViewConstants.strokeWidth
    return UIBezierPath(
      arcCenter: self.viewCenter,
      radius: radius,
      startAngle: CGFloat(270).degreesToRadians,
      endAngle: forBackground ? CGFloat(630).degreesToRadians : angle.degreesToRadians,
      clockwise: true).cgPath
  }
  
  func changeLabelColor(with color: UIColor) {
    self.scoreLabel.textColor = color
  }
  
  func lightenBackground() {
    self.scoreLabel.textColor = .black
    backgroundColor = .white
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

// MARK: - Setup Elements
extension CompatabilityView {
  private func setupElements() {
    setupLabel()
    setupScoreLayer()
  }
  
  private func setupScoreLayer() {
    scoreLayer.lineWidth = CompatabilityViewConstants.strokeWidth
    scoreLayer.fillColor = UIColor.clear.cgColor
    circleLayer.lineWidth = CompatabilityViewConstants.strokeWidth
    circleLayer.fillColor = UIColor.clear.cgColor
    circleLayer.strokeColor = UIColor.peopleViewControllerBackground.cgColor
    
    layer.insertSublayer(circleLayer, at: 0)
    layer.insertSublayer(scoreLayer, at: 1)
  }
  
  private func setupLabel() {
    scoreLabel = UILabel(text: "10", fontSize: 14, weight: .bold, textColor: .cardLabelTextColor)
    scoreLabel.textAlignment = .center
    
    addSubview(scoreLabel)
    
    scoreLabel.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
  }
}
