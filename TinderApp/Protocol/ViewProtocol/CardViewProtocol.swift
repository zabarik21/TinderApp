//
//  CardViewProtocol.swift
//  TinderApp
//
//  Created by Timofey on 2/7/22.
//

import UIKit


protocol CardViewProtocol: UIView {
  var delegate: CardViewDeleagate? { get set }
  var viewModel: UserCardViewViewModelProtocol? { get set }
  var isSwipeble: Bool { get }
  
  func swipe(liked: Bool, fromButton: Bool)
}

