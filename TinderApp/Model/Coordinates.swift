//
//  Coordinates.swift
//  TinderApp
//
//  Created by Timofey on 29/7/22.
//

import Foundation


struct Coordinates: Codable {
  var latitude: String
  var longitude: String
  
  enum CodingKeys: String, CaseIterable, CodingKey {
    case latitude
    case longitude
  }
}
