//
//  SignUpViewController.swift
//  TinderApp
//
//  Created by Timofey on 27/7/22.
//

import Foundation
import UIKit
import RxSwift

class SignUpViewController: UIViewController {
  
  private enum Constants {
    static let topLabelMarginMult: CGFloat = 0.1284
    static let horizontalMarginMult: CGFloat = 0.065
    static let textFieldMargin: CGFloat = 30
    static let buttonHeight: CGFloat = 60
  }
  
  private var signUpLabel: UILabel!
  private var emailTextFieldView: SignUpTextField!
  private var passwordTextFieldView: SignUpTextField!
  private var confirmPasswordTextFieldView: SignUpTextField!
  private var setupProfileButton: StartScreenButton!
  private var scrollView: UIScrollView!
  private var textFieldsStackView: UIStackView!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupElements()
    setupButtonTargets()
  }
  
  private func setupButtonTargets() {
    setupProfileButton.addTarget(self, action: #selector(toSetupProfile), for: .touchUpInside)
  }
  
  @objc private func toSetupProfile() {
    let email = emailTextFieldView.text
    let password = passwordTextFieldView.text
    let confirmPassword = confirmPasswordTextFieldView.text
    
    let errors = Validator.isFilled(
      email: email,
      password: password,
      confirmPassword: confirmPassword)
    for error in errors {
      switch error {
      case .email:
        emailTextFieldView.twitch()
      case .password:
        passwordTextFieldView.twitch()
      case .confirmPassword:
        confirmPasswordTextFieldView.twitch()
      }
    }
    
    guard errors.isEmpty else { return }
    
    DispatchQueue.global().async { [weak self] in
      AuthenticationService.shared.registerUser(
        email: email,
        password: password) { result in
          switch result {
          case .success(let user):
            let setupProfileVC = SetupProfileViewController(user: user)
            self?.navigationController?.pushViewController(setupProfileVC, animated: true)
          case .failure(let error):
            self?.showAlert(title: "Error", message: error.localizedDescription)
            return
        }
      }
    }
  }
}

// MARK: - Setup elements & Constraints
extension SignUpViewController {
  
  private func setupElements() {
    setupBG()
    setupTextFields()
    setupLabels()
    setupScrollView()
    setupButton()
    setupConstraints()
  }
  
  
  private func setupScrollView() {
    scrollView = UIScrollView()
    scrollView.showsVerticalScrollIndicator = false
    scrollView.showsHorizontalScrollIndicator = false
  }
  
  private func setupButton() {
    setupProfileButton = StartScreenButton(
      with: .light,
      title: "Setup profile")
  }
  
  private func setupTextFields() {
    emailTextFieldView = SignUpTextField(type: .email)
    passwordTextFieldView = SignUpTextField(type: .password)
    confirmPasswordTextFieldView = SignUpTextField(type: .confirmPassword)
    
    textFieldsStackView = UIStackView(arrangedSubviews: [
      emailTextFieldView,
      passwordTextFieldView,
      confirmPasswordTextFieldView
    ])
    textFieldsStackView.distribution = .fillEqually
    textFieldsStackView.axis = .vertical
    textFieldsStackView.spacing = 30
  }
  
  private func setupBG() {
    let gradient = LayerFactory.shared.getGradientLayer()
    gradient.frame = view.bounds
    view.layer.insertSublayer(gradient, at: 0)
  }
  
  private func setupLabels() {
    signUpLabel = UILabel(
      text: "Sign up to get started!",
      fontSize: 51,
      weight: .semibold,
      textColor: .logoColor)
    signUpLabel.numberOfLines = 0
  }
  
  private func setupConstraints() {
    let height = view.bounds.height
    let width = view.bounds.width
    
    view.addSubview(scrollView)
    
    scrollView.addSubview(signUpLabel)
    
    scrollView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    signUpLabel.snp.makeConstraints { make in
      make.top
        .equalToSuperview()
        .offset(height * Constants.topLabelMarginMult)
      make.width.equalToSuperview()
        .offset(width * Constants.horizontalMarginMult * 2)
      make.horizontalEdges.equalTo(view)
        .inset(width * Constants.horizontalMarginMult)
    }
    
    scrollView.addSubview(textFieldsStackView)
    
    textFieldsStackView.snp.makeConstraints { make in
      make.top
        .equalTo(signUpLabel.snp.bottom)
        .offset(40)
      make.width.equalTo(signUpLabel)
      make.centerX.equalToSuperview()
    }
    
    scrollView.addSubview(setupProfileButton)
    
    setupProfileButton.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.width
        .equalToSuperview()
        .offset(width * Constants.horizontalMarginMult * 2)
      make.height.equalTo(Constants.buttonHeight)
      make.top
        .equalTo(textFieldsStackView.snp.bottom)
        .offset(Constants.buttonHeight / 2)
      make.horizontalEdges.equalTo(view)
        .inset(width * Constants.horizontalMarginMult)
      make.bottom.equalToSuperview().inset(Constants.buttonHeight / 2)
    }
    
  }
  
}
