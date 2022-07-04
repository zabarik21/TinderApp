//
//  UserView + ReactionsDelegate.swift
//  TinderApp
//
//  Created by Timofey on 2/7/22.
//

import UIKit

extension UserView: ReactionViewDelegate {
  
  func reacted(liked: Bool) {
    self.userViewDelegate?.hide()
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
      self.reactionsDelegate?.reacted(liked: liked)
    }
  }
  
}
