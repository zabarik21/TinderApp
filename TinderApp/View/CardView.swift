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
    
  init(with viewModel: UserCardViewViewModel) {
    self.name = viewModel.name
    self.age = viewModel.age
    self.imageUrlString = viewModel.imageUrlString
    self.city = viewModel.city
    super.init(frame: .zero)
    setupElements()
  }
  
  private func setupElements() {
    
  }
    
  required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
    
}
