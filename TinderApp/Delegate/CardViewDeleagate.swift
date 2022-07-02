//
//  CardViewProtocol.swift
//  TinderApp
//
//  Created by Timofey on 31/5/22.
//

import UIKit

protocol CardViewDeleagate: UIView {
  func swiped(liked: Bool)
}
