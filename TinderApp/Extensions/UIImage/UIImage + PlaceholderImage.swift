//
//  UIImage + PlaceholderImage.swift
//  TinderApp
//
//  Created by Timofey on 2/7/22.
//

import UIKit

extension UIImage {
  static var userPlaceholderImage: UIImage? {
    let factor = Int.random(in: 0...1)
    let imgName = "user\(factor)"
    return UIImage(named: imgName)
  }
}

