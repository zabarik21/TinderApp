//
//  SetupProfileTextField.swift
//  TinderApp
//
//  Created by Timofey on 11/7/22.
//

import Foundation
import UIKit


class SetupProfileTextField: UITextField {
  
  private var lineLayer: CAShapeLayer!
  
  override func layoutSubviews() {
    super.layoutSubviews()
    updatePath()
  }
  
  init() {
    super.init(frame: .zero)
    setupLayer()
    setupFont()
  }
  
  private func setupFont() {
    font = .systemFont(ofSize: 16, weight: .semibold)
    textColor = .logoColor
    attributedPlaceholder = NSAttributedString(
        string: "Name",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.logoColor.withAlphaComponent(0.5)]
    )
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func updatePath(){
    lineLayer.path = UIBezierPath(rect: CGRect(x: 0, y: self.bounds.maxY + 1, width: self.bounds.width, height: 1)).cgPath
  }
  
  private func setupLayer() {
    lineLayer = CAShapeLayer()
    lineLayer.strokeColor = UIColor.logoColor.cgColor
    lineLayer.lineWidth = 1
    layer.insertSublayer(lineLayer, at: 0)
  }
  
}
