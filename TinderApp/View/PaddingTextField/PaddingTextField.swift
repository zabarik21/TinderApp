//
//  PaddingTextField.swift
//  TinderApp
//
//  Created by Timofey on 28/7/22.
//

import UIKit

class PaddingTextField: UITextField {

  private var insets: UIEdgeInsets
  
  init(
    insets: UIEdgeInsets,
    placeHolder: NSAttributedString?,
    textColor: UIColor?,
    keyboardType: UIKeyboardType?,
    font: UIFont?
  ) {
    self.insets = insets
    super.init(frame: .zero)
    self.attributedPlaceholder = placeHolder
    self.textColor = textColor
    self.keyboardType = keyboardType ?? .default
    self.font = font
  }
  
  override func textRect(forBounds bounds: CGRect) -> CGRect {
    let rect = super.textRect(forBounds: bounds)
    return rect.inset(by: insets)
  }
  
  override func editingRect(forBounds bounds: CGRect) -> CGRect {
    let rect = super.textRect(forBounds: bounds)
    return rect.inset(by: insets)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
