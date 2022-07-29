//
//  Name.swift
//  TinderApp
//
//  Created by Timofey on 29/7/22.
//

import Foundation


struct Name: Codable {
  var first: String
  var last: String
  
  enum CodingKeys: String, CodingKey, CaseIterable {
    case first
    case last
  }
}
