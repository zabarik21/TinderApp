//
//  CardView.swift
//  TinderApp
//
//  Created by Timofey on 30/5/22.
//

import UIKit



class CardView: UIView, UserCardViewViewModelProtocol {
  
  var name: String
  var age: Int
  var city: String
  var imageUrlString: String
  var delegate: CardViewDeleagate?
    
  init(with viewModel: UserCardViewViewModelProtocol) {
    self.name = viewModel.name
    self.age = viewModel.age
    self.imageUrlString = viewModel.imageUrlString
    self.city = viewModel.city
    super.init(frame: .zero)
    setupElements()
  }
  
  init() {
    let viewModel = UserCardViewViewModel()
    self.age = viewModel.age
    self.imageUrlString = viewModel.imageUrlString
    self.city = viewModel.city
    self.name = viewModel.name
    super.init(frame: .zero)
    setupElements()
  }
  
  private func setupElements() {
    self.backgroundColor = .randomColor()
  }
    
  required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
    
}
