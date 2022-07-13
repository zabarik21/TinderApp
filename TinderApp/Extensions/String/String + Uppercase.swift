//
//  String + Uppercase.swift
//  TinderApp
//
//  Created by Timofey on 6/7/22.
//

import Foundation

extension String {
  var uppercasingFirstLetter: Self {
    guard count > 1 else { return self.uppercased() }
    let tail = self.suffix(from: self.index(after: self.startIndex))
    let firstLetter = self[startIndex].uppercased()
    return "\(firstLetter)\(tail)"
  }
  
  var lowercasingFirstLetter: Self {
    guard count > 1 else { return self.uppercased() }
    let tail = self.suffix(from: self.index(after: self.startIndex))
    let firstLetter = self[startIndex].lowercased()
    return "\(firstLetter)\(tail)"
  }
  
}
