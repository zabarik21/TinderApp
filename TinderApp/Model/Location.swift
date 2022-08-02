//
//  Location.swift
//  TinderApp
//
//  Created by Timofey on 29/7/22.
//

import Foundation


struct Location: Codable {
  
  static let hidedKey = "Hided"
  static let distanceDemoKey: Int = -1
  
  var city: String
  var coordinates: Coordinates
  
  init(city: String, coordinates: Coordinates) {
    self.city = city
    self.coordinates = coordinates
  }
  
  // Location init for users who hide their location
  init() {
    self.city = Location.hidedKey
    self.coordinates = Coordinates(latitude: Location.hidedKey, longitude: Location.hidedKey)
  }
  
  enum CodingKeys: String, CodingKey, CaseIterable {
    case city
    case coordinates
  }
}
