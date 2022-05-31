//
//  CardContainerViewProtocol.swift
//  TinderApp
//
//  Created by Timofey on 31/5/22.
//


import UIKit


protocol CardContainerViewProtocol: UIView {
  
  var topCardView: CardView { get }
  var backCardView: CardView { get }
  var backCardContainer: UIView { get }
  var delegate: CardContainerDelagate? { get set }
}
