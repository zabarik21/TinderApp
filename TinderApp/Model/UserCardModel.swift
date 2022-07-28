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
  
  var representation: [String: Any] {
    var dict = [String: Any]()
    var name = [String: String]()
    var location = [String: Any]()
    var coordinates = [String: Any]()
    var birthDate = [String: Any]()
    var picture = [String: Any]()
    var id = [String: Any]()
    var interestsCollection = [String: Any]()
    let interests = self.interests?.map { $0.rawValue } ?? []
    interestsCollection["interests"] = interests
    id["value"] = self.id.value
    picture["large"] = self.picture.large
    picture["thumbnail"] = self.picture.thumbnail
    birthDate["age"] = self.birthDate.age
    birthDate["date"] = self.birthDate.date
    name["first"] = self.name.first
    name["last"] = self.name.last
    coordinates["latitude"] = self.location.coordinates.latitude
    coordinates["longitude"] = self.location.coordinates.longitude
    location["city"] = self.location.city
    
    dict["name"] = name
    dict["gender"] = self.gender.rawValue.uppercasingFirstLetter
    dict["location"] = location
    dict["dob"] = birthDate
    dict["picture"] = picture
    dict["id"] = id
    dict["interests"] = interests
    
    return dict
  }
  
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
