//
//  WebImage.swift
//  TinderApp
//
//  Created by Timofey on 29/7/22.
//

import Foundation


struct WebImage: Codable {
  var large: String
  var thumbnail: String
  
  enum CodingKeys: String, CodingKey, CaseIterable {
    case large
    case thumbnail
  }
  
}
