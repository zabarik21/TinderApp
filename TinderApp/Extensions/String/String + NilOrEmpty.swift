//
//  String + NilOrEmpty.swift
//  TinderApp
//
//  Created by Timofey on 30/7/22.
//

import Foundation


extension Optional where Wrapped == String {
  func isNilOrEmpty() -> Bool {
    if self != nil {
      return !self.unsafelyUnwrapped.isEmpty
    }
    return false
  }
}
