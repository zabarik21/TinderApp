//
//  Array + Shift.swift
//  TinderApp
//
//  Created by Timofey on 1/6/22.
//

import Foundation

extension Array {
  mutating func shift() -> Element? {
    guard !isEmpty else { return nil }
    let topElement = self[0]
    self.remove(at: 0)
    return topElement
  }
}
