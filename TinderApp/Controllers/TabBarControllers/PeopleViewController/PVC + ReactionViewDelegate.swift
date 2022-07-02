//
//  PVC + ReactionViewDelegate.swift
//  TinderApp
//
//  Created by Timofey on 1/7/22.
//

import UIKit

extension PeopleViewController: ReactionViewDelegate {
  func reacted(liked: Bool) {
    if userView.isHidden == false {
      userView.hide()
    }
    cardContainer.reacted(liked: liked)
  }
}
