//
//  LoginViewController.swift
//  TinderApp
//
//  Created by Timofey on 28/7/22.
//
import Foundation
import UIKit

class LoginViewController: UIViewController {
  
  private enum Constants {
    static let topLabelMarginMult: CGFloat = 0.1284
    static let horizontalMarginMult: CGFloat = 0.065
    static let textFieldMargin: CGFloat = 30
    static let buttonHeight: CGFloat = 60
  }
  
  private var loginLabel: UILabel!
  private var emailTextFieldView: SignUpTextField!
  private var passwordTextFieldView: SignUpTextField!
  private var toChatsButton: StartScreenButton!
  private var textFieldsStackView: UIStackView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupElements()
    setupButtonTargets()
  }
  
  private func setupButtonTargets() {
    toChatsButton.addTarget(self, action: #selector(toChats), for: .touchUpInside)
  }
  
  @objc private func toChats() {
    let email = emailTextFieldView.text
    let password = passwordTextFieldView.text
    let errors = Validator.isFilled(
      email: email,
      password: password,
      confirmPassword: password)
    
    for error in errors {
      switch error {
      case .email:
        emailTextFieldView.twitch()
      case .password, .confirmPassword:
        passwordTextFieldView.twitch()
      }
    }
    
    guard errors.isEmpty else { return }
    DispatchQueue.main.async {
      AuthenticationService.shared.loginUser(
        email: email,
        password: password) { result in
          switch result {
          case .success(let user):
            self.showAlert(
              title: "Youre successfuly logged in",
              message: "Please wait a couple of seconds")
            FirestoreService.shared.getUserData(user: user) { result in
              switch result {
              case .success(let userModel):
                
                let mainVC = MainTabBarController(user: userModel)
                if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                  sceneDelegate.changeRootViewController(mainVC, animated: true)
                  
                }
              case .failure(let error):
                AlertService.shared.alertPublisher.accept(
                  (title: "Error",
                  message: error.localizedDescription)
                )
                self.showAlert(title: "Error", message: error.localizedDescription)
              }
            }
          case .failure(let error):
            AlertService.shared.alertPublisher.accept(
              (title: "Error",
              message: error.localizedDescription)
            )
          }
      }
    }
  }
}

// MARK: - Setup elements & Constraints
extension LoginViewController {
  
  private func setupElements() {
    setupBG()
    setupTextFields()
    setupLabels()
    setupButton()
    setupConstraints()
  }
  
  
  private func setupButton() {
    toChatsButton = StartScreenButton(
      with: .light,
      title: "Log in")
  }
  
  private func setupTextFields() {
    emailTextFieldView = SignUpTextField(type: .email)
    passwordTextFieldView = SignUpTextField(type: .password)
    
    textFieldsStackView = UIStackView(arrangedSubviews: [
      emailTextFieldView,
      passwordTextFieldView,
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
    loginLabel = UILabel(
      text: "Welcome Back!",
      fontSize: 51,
      weight: .semibold,
      textColor: .logoColor)
    loginLabel.numberOfLines = 0
  }
  
  private func setupConstraints() {
    let height = view.bounds.height
    let width = view.bounds.width
    
    view.addSubview(loginLabel)
    
    loginLabel.snp.makeConstraints { make in
      make.top
        .equalToSuperview()
        .offset(height * Constants.topLabelMarginMult)
      make.horizontalEdges.equalTo(view)
        .inset(width * Constants.horizontalMarginMult)
    }
    
    view.addSubview(textFieldsStackView)
    
    textFieldsStackView.snp.makeConstraints { make in
      make.horizontalEdges.equalTo(view)
        .inset(width * Constants.horizontalMarginMult)
      make.centerY.equalToSuperview()
      make.centerX.equalToSuperview()
    }
    
    view.addSubview(toChatsButton)
    
    toChatsButton.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.height.equalTo(Constants.buttonHeight)
      make.horizontalEdges.equalTo(view)
        .inset(width * Constants.horizontalMarginMult)
      make.bottom.equalToSuperview().inset(Constants.buttonHeight / 2)
    }
    
  }
  
}
