//
//  AuthenticationNavigationController.swift
//  TinderApp
//
//  Created by Timofey on 30/7/22.
//

import Foundation
import UIKit


class AuthenticationNavigationController: UINavigationController {
  
  override init(rootViewController: UIViewController) {
    super.init(rootViewController: rootViewController)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigationController()
  }
  
  private func setupNavigationController() {
    navigationBar.tintColor = .logoColor
    navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationBar.shadowImage = UIImage()
    navigationBar.isTranslucent = true
    view.backgroundColor = .clear
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
