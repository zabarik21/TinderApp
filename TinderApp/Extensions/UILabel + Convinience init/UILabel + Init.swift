//
//  UILabel + Init.swift
//  TinderApp
//
//  Created by Timofey on 13/7/22.
//

import UIKit

extension UILabel {
  
  convenience init(text: String, fontSize: CGFloat, weight: UIFont.Weight, textColor: UIColor) {
    self.init()
    self.text = text
    self.font = .systemFont(ofSize: fontSize, weight: weight)
    self.textColor = textColor
  }
  
}
