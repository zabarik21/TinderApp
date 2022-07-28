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
    let user = UserCardModel(
      name: Name(
        first: "Тимофей",
        last: "Резвых"),
      gender: .male,
      location: Location(
        city: "Perm",
        coordinates: Coordinates(
          latitude: "2",
          longitude: "3")),
      birthDate: BirthDate(
        date: "03.03.02",
        age: 19),
      picture: WebImage(
        large: "https://vgmsite.com/soundtracks/spongebob-battle-for-bikini-bottom-gc-xbox-ps2/coverart.jpg",
        thumbnail: "https://prodigits.co.uk/thumbs/android-games/thumbs/s/1396790468.jpg"),
      id: USERID.init(value: "3241145"),
      interests: Interest.getAllCases())
    DispatchQueue.main.async {
      let mainVC = MainTabBarController(user: user)
      if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
        sceneDelegate.changeRootViewController(mainVC, animated: true)
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
