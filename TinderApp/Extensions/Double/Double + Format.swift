//
//  Double + Format.swift
//  TinderApp
//
//  Created by Timofey on 2/8/22.
//

import Foundation

extension Double {
  
  func format(f: String) -> String {
    return String(format: "%\(f)f", self)
  }
  
}
