//
//  StartScreenController.swift
//  TinderApp
//
//  Created by Timofey on 9/7/22.
//

import UIKit
import SnapKit
import AVFoundation

class AuthenticationViewController: UIViewController {
  
  private enum Constants {
    static let horizontalEdgeMarginMultiplier: CGFloat = 0.0555
    static let bottomEdgeMarginMultiplier: CGFloat = 0.0591
    static let topLogoMarginMultiplier: CGFloat = 0.239
    static let horizontalLogoPaddingMultiplier: CGFloat = 0.223
    static let heightLogoPaddingMultiplier: CGFloat = 0.355
  }
  
  private var loginButton: StartScreenButton!
  private var signUpButton: StartScreenButton!
  private var demoAppButton: StartScreenButton!

  private var logoImageView: UIImageView!
  private var logoLabel: UILabel!
  private var logoContainer: UIView!
  
  private var demoSetupProfileVC = SetupProfileViewController()
  private var signUpVC = SignUpViewController()
  private var loginVC = LoginViewController()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupElements()
    setupConstraints()
  }
 
  @objc func authenticationButtonTouched(_ sender: UIButton) {
    var viewController: UIViewController?
    if sender === loginButton {
      viewController = loginVC
      DemoModeService.shared.toggleDemo(to: false)
    } else if sender === signUpButton {
      viewController = signUpVC
      DemoModeService.shared.toggleDemo(to: false)
    } else {
      viewController = demoSetupProfileVC
      DemoModeService.shared.toggleDemo(to: true)
    }
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      self.navigationController?.pushViewController(
        viewController!,
        animated: true)
    }
  }
  
}


// MARK: - Setup UI & Constraints
extension AuthenticationViewController {
  private func setupElements() {
    setupBackground()
    setupLogo()
    setupButtons()
    setupButtonTargets()
  }
  
  private func setupButtonTargets() {
    demoAppButton.addTarget(self, action: #selector(authenticationButtonTouched), for: .touchUpInside)
    signUpButton.addTarget(self, action: #selector(authenticationButtonTouched), for: .touchUpInside)
    loginButton.addTarget(self, action: #selector(authenticationButtonTouched), for: .touchUpInside)
  }

  private func setupLogo() {
    logoImageView = UIImageView()
    logoImageView.image = UIImage(systemName: "lasso.and.sparkles")
    logoImageView.tintColor = .logoColor
    logoImageView.contentMode = .scaleAspectFit
    
    logoLabel = UILabel(text: "コミュニ", fontSize: 51, weight: .semibold, textColor: .logoColor)
    
    logoContainer = UIView()
  }

  private func setupButtons() {
    signUpButton = StartScreenButton(with: .dark, title: "Sign Up")
    loginButton = StartScreenButton(with: .light, title: "Log in")
    demoAppButton = StartScreenButton(with: .demoApp, title: "Try Demo App")
  }

  private func setupConstraints() {
    
    let width = self.view.bounds.width
    let height = self.view.bounds.height
    
    self.view.addSubview(demoAppButton)
    
    demoAppButton.snp.makeConstraints { make in
      make.height.equalTo(55)
      make.horizontalEdges.equalToSuperview().inset(Constants.horizontalEdgeMarginMultiplier * width)
      make.bottom.equalToSuperview().inset(Constants.bottomEdgeMarginMultiplier * height)
    }
    
    self.view.addSubview(signUpButton)
    
    signUpButton.snp.makeConstraints { make in
      make.height.equalTo(55)
      make.horizontalEdges.equalToSuperview().inset(Constants.horizontalEdgeMarginMultiplier * width)
      make.bottom.equalTo(demoAppButton.snp.top).offset(-11)
    }

    self.view.addSubview(loginButton)

    loginButton.snp.makeConstraints { make in
      make.bottom.equalTo(signUpButton.snp.top).offset(-11)
      make.height.equalTo(55)
      make.horizontalEdges.equalToSuperview().inset(Constants.horizontalEdgeMarginMultiplier * width)
    }
    
    self.view.addSubview(logoContainer)
    
    logoContainer.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(Constants.topLogoMarginMultiplier * height)
      make.horizontalEdges.equalToSuperview().inset(Constants.horizontalLogoPaddingMultiplier * width)
      make.height.equalTo(Constants.heightLogoPaddingMultiplier * height)
    }
    
    logoContainer.addSubview(logoLabel)
    
    logoLabel.snp.makeConstraints { make in
      make.bottom.equalToSuperview()
      make.centerX.equalToSuperview()
    }
    
    logoContainer.addSubview(logoImageView)
    
    logoImageView.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.width.equalTo(logoLabel)
      make.centerX.equalToSuperview()
      make.bottom.equalTo(logoLabel.snp.top)
    }
  }

  private func setupBackground() {
    let gradientLayer = LayerFactory.shared.getGradientLayer()
    gradientLayer.frame = self.view.bounds
    view.layer.insertSublayer(gradientLayer, at: 0)
    let backgroundImage = UIImageView()
    backgroundImage.image = UIImage(named: "emojis")!
    self.view.addSubview(backgroundImage)
    backgroundImage.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }


}
