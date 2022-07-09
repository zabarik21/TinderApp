//
//  UserViewProtocol.swift
//  TinderApp
//
//  Created by Timofey on 1/7/22.
//

import UIKit


protocol HideShowView {
  
}

protocol UserViewProtocol: UIView, HideShowView {
  var viewModel: UserCardViewViewModelProtocol? { get set }
  var reactionsDelegate: ReactionViewDelegate? { get set }
  var userViewDelegate: UserViewDelegate? { get set }
  
  func toIdentity()
}
