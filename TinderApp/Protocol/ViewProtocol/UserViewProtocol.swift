//
//  UserViewProtocol.swift
//  TinderApp
//
//  Created by Timofey on 1/7/22.
//

import UIKit


protocol HideShowView {
  func show()
  func hide()
}

protocol UserViewProtocol: UIView, HideShowView {
  var viewModel: UserCardViewViewModelProtocol! { get set }
  var reactionsDelegate: ReactionViewDelegate? { get set }
}
