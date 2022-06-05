//
//  PeopleViewController.swift
//  TinderApp
//
//  Created by Timofey on 27/5/22.
//

import UIKit

class PeopleViewController: UIViewController {

  var cardContainer: CardContainerView!
  
  let headerOvalLayerMask = CAShapeLayer()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "peopleBG")!
      setupHeaderOvalLayer()
      setupCardContainer()
    }
  


  private func setupCardContainer() {
    let viewModel = CardContainerViewViewModel(users: [
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

extension PeopleViewController: CardContainerDelagate {
  func usersLoaded() {
    print("loaded")
  }
}
