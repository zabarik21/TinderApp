//
//  CardContainerDelegate.swift
//  TinderApp
//
//  Created by Timofey on 3/6/22.
//

import Foundation


protocol CardContainerDelagate {
  func getNextUser(_ cardContainer: CardContainerView) -> UserCardViewViewModelProtocol
}

