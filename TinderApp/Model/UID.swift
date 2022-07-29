//
//  UID.swift
//  TinderApp
//
//  Created by Timofey on 29/7/22.
//

import Foundation


struct UID: Codable {
  var value: String?
  
  enum CodingKeys: String, CaseIterable, CodingKey {
    case value
  }
}
