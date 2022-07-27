//
//  UserCardModel.swift
//  TinderApp
//
//  Created by Timofey on 31/5/22.
//

import Foundation

struct RandomPeopleApiResponce: Codable {
  let results: [UserCardModel]
}


struct UserCardModel: Codable {
  var name: Name
  var gender: Gender
  var location: Location
  var birthDate: BirthDate
  var picture: WebImage
  var id: USERID
  var interests: Set<Interest>?
  
  enum CodingKeys: String, CodingKey, CaseIterable {
    case birthDate = "dob"
    case picture
    case location
    case name
    case gender
    case id
    case interests
  }
  
  func jsonRepresent() -> Data? {
    do {
      let json = try JSONEncoder().encode(self)
      return json
    } catch {
      print(error)
      return nil
    }
  }
}

extension UserCardModel: Equatable {
  static func == (lhs: UserCardModel, rhs: UserCardModel) -> Bool {
    guard let lid = lhs.id.value, let rid = rhs.id.value else { return false }
    return lid == rid
  }
}


struct Coordinates: Codable {
  var latitude: String
  var longitude: String
}

struct USERID: Codable {
  var value: String?
}


enum Gender: String, Codable, CaseIterable {
  case female
  case male
  case other
}

struct Name: Codable {
  var first: String
  var last: String
}

struct WebImage: Codable {
  var large: String
  var thumbnail: String
}

struct BirthDate: Codable {
  var date: String
  var age: Int
}

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
  
}
