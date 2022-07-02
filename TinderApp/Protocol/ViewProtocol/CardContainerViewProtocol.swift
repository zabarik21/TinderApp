//
//  CardContainerViewProtocol.swift
//  TinderApp
//
//  Created by Timofey on 2/7/22.
//

import UIKit

protocol CardContainerViewProtocol: UIView {
  var viewModel: CardContainerViewViewModelProtocol? { get set }
  var delegate: CardContainerDelagate? { get set }
  var bottomCardView: CardViewProtocol! { get set }
  var topCardView: CardViewProtocol! { get set }
  
  func reacted(liked: Bool)
}
