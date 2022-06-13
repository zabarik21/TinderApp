//
//  CGFLoat + Radians.swift
//  TinderApp
//
//  Created by Timofey on 12/6/22.
//

import Foundation
import UIKit

extension CGFloat {
  var degreesToRadians: Self { self * .pi / 180 }
  var radianstoDegrees: Self { self * 180 / .pi }
}
