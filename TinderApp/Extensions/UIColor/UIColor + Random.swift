//
//  UIColor + Random.swift
//  TinderApp
//
//  Created by Timofey on 31/5/22.
//

import Foundation
import UIKit

extension UIColor {
  static func randomColor() -> UIColor {
    let r = CGFloat(CGFloat(Int.random(in: 0...255)) / 255.0),
        g = CGFloat(CGFloat(Int.random(in: 0...255)) / 255.0),
        b = CGFloat(CGFloat(Int.random(in: 0...255)) / 255.0)
    return UIColor(red: r, green: g, blue: b, alpha: 1)
  }
}
