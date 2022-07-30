//
//  MainTabBarController.swift
//  TinderApp
//
//  Created by Timofey on 27/5/22.
//

import UIKit
import SnapKit
import RxSwift

enum ViewControllers: Int {
  case people
  case messages
  case profile
}

enum MainTabBarVCConstants {
  static var tabBarLayerHorizontalPaddingMultiplier: CGFloat = 0.0695
  static var tabBarLayerVerticalPadding: CGFloat = 5
  static var itemPadding: CGFloat = 3
}

class MainTabBarController: UITabBarController {
  
  var user: UserCardModel
  
  var peopleVC: PeopleViewController!
  var messagesVC: MessagerViewController!
  var profileVC: ProfileViewController!
  
  let tabBarLayer = CAShapeLayer()
  let itemLayer = CAShapeLayer()
  var layerHeight = CGFloat()
  var layerWidth = CGFloat()
  var itemWidth = CGFloat()
  let appearence = UITabBarAppearance()
  
  private let bag = DisposeBag()
  
  init(user: UserCardModel) {
    self.user = user
    super.init(nibName: nil, bundle: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTabBar()
    setupObserver()
  }
  
  private func setupObserver() {
    AlertService.shared.alertObservable
      .subscribe(onNext: { [weak self] alertDescription in
        self?.showAlert(title: alertDescription.title, message: alertDescription.message)
      })
      .disposed(by: bag)
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    actualizePath()
  }
   
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
