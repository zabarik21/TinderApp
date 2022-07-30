//
//  ProfileViewController.swift
//  TinderApp
//
//  Created by Timofey on 27/5/22.
//

import UIKit


class ProfileViewController: UIViewController {
  
  private var signOutButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    setupElements()
    setupButtonTargets()
  }
  
  private func setupButtonTargets() {
    signOutButton.addTarget(self, action: #selector(signOut), for: .touchUpInside)
  }
  
  @objc private func signOut() {
    do {
      try AuthenticationService.shared.logoutUser()
      StorageService.shared.resetData()
    } catch let signOutError {
      AlertService.shared.alertPublisher.accept((
        "Error",
        "\(signOutError)"
      ))
      return
    }
    if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
      sceneDelegate.changeRootViewController(AuthenticationNavigationController(
        rootViewController: AuthenticationViewController()),
                                             animated: true)
    }
  }
  
}

// MARK: - Setup Elements & Constraints
extension ProfileViewController {
  
  private func setupElements() {
    setupButton()
    setupConstraints()
  }
  
  private func setupButton() {
    signOutButton = UIButton(type: .system)
    signOutButton.setTitle("Sign out", for: .normal)
  }
  
  private func setupConstraints() {
    view.addSubview(signOutButton)
    signOutButton.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.centerY.equalToSuperview()
    }
  }
}
