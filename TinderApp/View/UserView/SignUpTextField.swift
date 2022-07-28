//
//  SignUpTextField.swift
//  TinderApp
//
//  Created by Timofey on 27/7/22.
//

import UIKit
import SnapKit


enum SignUpTextFieldType {
  case email
  case password
  case confirmPassword
  
  func titleText() -> String {
    switch self {
    case .email:
      return "Email"
    case .password:
      return "Password"
    case .confirmPassword:
      return "Confirm password"
    }
  }
  
  func placeHolderText() -> String {
    switch self {
    case .email:
      return "example@mail.com"
    case .password, .confirmPassword:
      return "********"
    }
  }
  
  func keyboardType() -> UIKeyboardType {
    switch self {
    case .email:
      return .emailAddress
    case .password, .confirmPassword:
      return .default
    }
  }
}

class SignUpTextField: UIView {

  private enum Constants {
    static let textFieldHeight: CGFloat = 60
  }
  
  private var textField: UITextField!
  private var label: UILabel!
  
  private var type: SignUpTextFieldType
  
  init(type: SignUpTextFieldType) {
    self.type = type
    super.init(frame: .zero)
    setupElements()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

// MARK: - Setup Elements & Constraints
extension SignUpTextField {
  
  private func setupElements() {
    setupTextField()
    setupLabel()
    setupConstraints()
  }
  
  private func setupTextField() {
    let placeHolder = NSAttributedString(
      string: type.placeHolderText(),
      attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
    
    textField = PaddingTextField(
      insets: UIEdgeInsets(
        top: 0,
        left: 17,
        bottom: 0,
        right: 17),
      placeHolder: placeHolder,
      textColor: .black,
      keyboardType: type.keyboardType(),
      font: .systemFont(
        ofSize: 16,
        weight: .semibold))
    
    textField.layer.cornerRadius = 10
    textField.backgroundColor = .white
  }
  
  private func setupLabel() {
    label = UILabel(
      text: type.titleText(),
      fontSize: 16,
      weight: .semibold,
      textColor: .logoColor)
  }
  
  private func setupConstraints() {
    addSubview(label)
    addSubview(textField)
    
    label.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.leading.equalToSuperview()
    }
    
    textField.snp.makeConstraints { make in
      make.top.equalTo(label.snp.bottom).offset(7)
      make.horizontalEdges.equalToSuperview()
      make.bottom.equalToSuperview()
      make.height.equalTo(Constants.textFieldHeight)
    }
  }
}
