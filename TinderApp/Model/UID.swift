//
//  UID.swift
//  TinderApp
//
//  Created by Timofey on 29/7/22.
//

import Foundation
import FirebaseFirestore


struct UID: Codable {
  var value: String?
  
  var representation: [String: String] {
    var dict = [String: String]()
    dict[CodingKeys.value.rawValue] = value ?? "nil"
    return dict
  }
  
  init(value: String) {
    self.value = value
  }
  
  init?(document: DocumentSnapshot) {
    guard let data = document.data() else {
      return nil
    }
    self.value = data[CodingKeys.value.rawValue]! as! String
  }
  
  enum CodingKeys: String, CaseIterable, CodingKey {
    case value
  }
  
}
