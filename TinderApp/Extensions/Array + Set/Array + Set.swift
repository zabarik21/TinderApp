//
//  File.swift
//  TinderApp
//
//  Created by Timofey on 13/7/22.
//

import Foundation


extension Array {
  func toSet() -> Set<Element> where Element: Hashable {
    var set = Set<Element>()
    for i in self {
      set.insert(i)
    }
    return set
  }
}
