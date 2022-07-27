//
//  SignUpViewController.swift
//  TinderApp
//
//  Created by Timofey on 27/7/22.
//

import Foundation
import UIKit

class SignUpViewController: UIViewController {
  
  private enum Constants {
    static let topLabelMarginMult: CGFloat = 0.157
    static let horizontalMarginMult: CGFloat = 0.065
  }
  
  private var logInLabel: UILabel!
  private var welcomebackLabel: UILabel!
  private var emailTextFieldView: SignUpTextField!
  private var passwordTextFieldView: SignUpTextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupElements()
  }
  
}

// MARK: - Setup elements & Constraints
extension SignUpViewController {
  
  private func setupElements() {
    setupBG()
    setupTextFields()
    setupLabels()
    setupConstraints()
  }
  
  private func setupTextFields() {
    emailTextFieldView = SignUpTextField(type: .email)
    passwordTextFieldView = SignUpTextField(type: .password)
  }
  
  private func setupBG() {
    let gradient = LayerFactory.shared.getGradientLayer()
    gradient.frame = view.bounds
    view.layer.insertSublayer(gradient, at: 0)
  }
  
  private func setupLabels() {
    welcomebackLabel = UILabel(
      text: "Create  Account",
      fontSize: 51,
      weight: .semibold,
      textColor: .logoColor)
    
    logInLabel = UILabel(
      text: "Sign up to get started!",
      fontSize: 30,
      weight: .semibold,
      textColor: .logoColor)
  }
  
  private func setupConstraints() {
    let height = view.bounds.height
    let width = view.bounds.width
    
    view.addSubview(logInLabel)
    
    logInLabel.snp.makeConstraints { make in
      make.top.equalToSuperview()
        .offset(height * Constants.topLabelMarginMult)
      make.leading.equalToSuperview()
        .offset(width * Constants.horizontalMarginMult)
    }
    
    view.addSubview(welcomebackLabel)
    
    welcomebackLabel.snp.makeConstraints { make in
      make.top
        .equalTo(logInLabel.snp.bottom)
        .offset(6)
      make.leading
        .equalToSuperview()
        .offset(width * Constants.horizontalMarginMult)
    }
    
    view.addSubview(emailTextFieldView)
    
    emailTextFieldView.snp.makeConstraints { make in
      make.horizontalEdges
        .equalToSuperview()
        .inset(width * Constants.horizontalMarginMult)
      make.top
        .equalTo(welcomebackLabel.snp.bottom)
        .offset(100)
      make.height.equalTo(80)
    }
    
//    view.addSubview(passwordTextFieldView)
  }
  
}
