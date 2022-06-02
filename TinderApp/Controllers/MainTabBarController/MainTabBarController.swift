//
//  MainTabBarController.swift
//  TinderApp
//
//  Created by Timofey on 27/5/22.
//

import UIKit
import SnapKit


enum Constants  {
  static let ovalHeight: Int = 313
}

class MainTabBarController: UITabBarController {
  
  lazy var peopleVC = PeopleViewController()
  lazy var messagesVC = MessagerViewController()
  lazy var profileVC = ProfileViewController()
  
  let headerOvalLayerMask = CAShapeLayer()
  let tabBarLayer = CAShapeLayer()
  let itemLayer = CAShapeLayer()
  var layerHeight = CGFloat()
  var layerWidth = CGFloat()
  let appearence = UITabBarAppearance()
  
  
  var tabBarLayerHorizontalPadding: CGFloat = 26
  var tabBarLayerVerticalPadding: CGFloat = 5
  
  var cardContainer: CardContainerView!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTabBar()
    setupHeaderOvalLayer()
    setupCardContainer()
  }
  
  
  
  
  private func setupElements() {
    setupCardContainer()
  }
  
  private func setupCardContainer() {
    let viewModel = CardContainerViewViewModel(users: [
      .init(),
      .init(),
      .init(),
      .init(),
      .init(),
      .init(),
      .init(),
      .init(),
      .init()])
    cardContainer = CardContainerView(viewModel: viewModel)
    
    view.addSubview(cardContainer)
    
    cardContainer.snp.makeConstraints { make in
      make.leading.equalTo(self.view.snp.leading).offset(37)
      make.trailing.equalTo(self.view.snp.trailing).offset(-37)
      make.height.equalTo(485)
      make.center.equalTo(self.view)
    }
  }
  
  
  
  
  
}

extension MainTabBarController: CardContainerDelagate {
  
  func getNextUser(_ cardContainer: CardContainerView) -> UserCardViewViewModelProtocol {
    return UserCardViewViewModel()
  }
  
  
  
  
}
