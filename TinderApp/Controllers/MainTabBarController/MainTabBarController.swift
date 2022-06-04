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
  static var cardContainer: Int = 485
  static var cardDisappearTime: CGFloat = 0.5
  static var cardContainerHorizontalOffset: Int = 37
  static var tabBarLayerHorizontalPadding: CGFloat = 26
  static var tabBarLayerVerticalPadding: CGFloat = 5
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
      make.leading.equalTo(self.view.snp.leading).offset(Constants.cardContainerHorizontalOffset)
      make.trailing.equalTo(self.view.snp.trailing).offset(-Constants.cardContainerHorizontalOffset)
      make.height.equalTo(Constants.cardContainer)
      make.center.equalTo(self.view)
    }
    
    cardContainer.delegate = self
  }
  
}

extension MainTabBarController: CardContainerDelagate {
  
  func getNextUser(_ cardContainer: CardContainerView) -> UserCardViewViewModelProtocol {
    return UserCardViewViewModel()
  }

}
