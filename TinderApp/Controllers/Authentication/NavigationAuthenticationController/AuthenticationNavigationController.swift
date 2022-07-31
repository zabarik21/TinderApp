//
//  AuthenticationNavigationController.swift
//  TinderApp
//
//  Created by Timofey on 30/7/22.
//

import Foundation
import UIKit
import RxSwift


class AuthenticationNavigationController: UINavigationController {
  
  private let bag = DisposeBag()
  
  override init(rootViewController: UIViewController) {
    super.init(rootViewController: rootViewController)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigationController()
    setupAlertObserver()
  }
  
  private func setupAlertObserver() {
    AlertService.shared.alertObservable
      .subscribe(onNext: { [weak self] alertDescription in
        self?.showAlert(
          title: alertDescription.title,
          message: alertDescription.message
        )
      })
      .disposed(by: bag)
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
