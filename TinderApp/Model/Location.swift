//
//  Location.swift
//  TinderApp
//
//  Created by Timofey on 29/7/22.
//

import Foundation


struct Location: Codable {
  var city: String
  var coordinates: Coordinates
  
  init(city: String, coordinates: Coordinates) {
    self.city = city
    self.coordinates = coordinates
  }
  
  // Location init for users who hide their location
  init() {
    self.city = "Hided"
    self.coordinates = Coordinates(latitude: "54", longitude: "54")
  }
  
  enum CodingKeys: String, CodingKey, CaseIterable {
    case city
    case coordinates
  }
  
}
