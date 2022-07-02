//
//  PVC + CardContainerViewViewModelDelegate.swift
//  TinderApp
//
//  Created by Timofey on 2/7/22.
//

import Foundation


extension PeopleViewController: CardContainerViewViewModelDelegate {
  func usersLoaded() {
    cardContainer.fillCards()
  }
}
