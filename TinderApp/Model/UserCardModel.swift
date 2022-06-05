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
  var gender: String
  var location: Location
  var birthDate: BirthDate
  var picture: WebImage
  var id: ID
  
  enum CodingKeys: String, CodingKey {
    case birthDate = "dob"
    case picture
    case location
    case name
    case gender
    case id
  }
}

struct ID: Codable {
  var value: String
}


enum Gender: String {
  case female
  case male
}

struct Name: Codable {
  var first: String
  var last: String
}

struct WebImage: Codable {
  var large: String
  var medium: String
  var thumbnail: String
}

struct BirthDate: Codable {
  var date: String
  var age: Int
}

struct Location: Codable {
  var city: String
}
