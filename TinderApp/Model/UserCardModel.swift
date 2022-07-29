//
//  UserCardModel.swift
//  TinderApp
//
//  Created by Timofey on 31/5/22.
//

import Foundation
import FirebaseFirestore

struct RandomPeopleApiResponce: Codable {
  let results: [UserCardModel]
}

struct UserCardModel: Codable {
  
  var name: Name
  var gender: Gender
  var location: Location
  var birthDate: BirthDate
  var picture: WebImage
  var id: UID
  var interests: Set<Interest>?
  
  static var demoUser: Self {
    return UserCardModel(
      name: Name(
        first: "Demo",
        last: "User"),
      gender: .other,
      location: Location(),
      birthDate: BirthDate(
        date: "01.01.2000",
        age: 0),
      picture: WebImage(
        large: "https://vgmsite.com/soundtracks/spongebob-battle-for-bikini-bottom-gc-xbox-ps2/coverart.jpg",
        thumbnail: "https://prodigits.co.uk/thumbs/android-games/thumbs/s/1396790468.jpg"),
      id: UID.init(value: "id"),
      interests: Interest.getRandomCases())
  }
  
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

extension UserCardModel {
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
    interestsCollection[UserCardModel.CodingKeys.interests.rawValue] = interests
    id[UID.CodingKeys.value.rawValue] = self.id.value
    picture[WebImage.CodingKeys.large.rawValue] = self.picture.large
    picture[WebImage.CodingKeys.thumbnail.rawValue] = self.picture.thumbnail
    birthDate[BirthDate.CodingKeys.age.rawValue] = self.birthDate.age
    birthDate[BirthDate.CodingKeys.date.rawValue] = self.birthDate.date
    name[Name.CodingKeys.first.rawValue] = self.name.first
    name[Name.CodingKeys.last.rawValue] = self.name.last
    coordinates[Coordinates.CodingKeys.latitude.rawValue] = self.location.coordinates.latitude
    coordinates[Coordinates.CodingKeys.longitude.rawValue] = self.location.coordinates.longitude
    location[Location.CodingKeys.city.rawValue] = self.location.city
    location[Location.CodingKeys.coordinates.rawValue] = coordinates
    
    dict[UserCardModel.CodingKeys.name.rawValue] = name
    dict[UserCardModel.CodingKeys.gender.rawValue] = self.gender.rawValue
    dict[UserCardModel.CodingKeys.location.rawValue] = location
    dict[UserCardModel.CodingKeys.birthDate.rawValue] = birthDate
    dict[UserCardModel.CodingKeys.picture.rawValue] = picture
    dict[UserCardModel.CodingKeys.id.rawValue] = id
    dict[UserCardModel.CodingKeys.interests.rawValue] = interests
    
    return dict
  }
  
  init?(document: DocumentSnapshot) {
    guard let document = document.data() else { return nil }
    guard
      let id = document[UserCardModel.CodingKeys.id.rawValue] as? [String: String],
      let image = document[UserCardModel.CodingKeys.picture.rawValue] as? [String: String],
      let name = document[UserCardModel.CodingKeys.name.rawValue] as? [String: String],
      let dob = document[UserCardModel.CodingKeys.birthDate.rawValue] as? [String: Any],
      let interests = document[UserCardModel.CodingKeys.interests.rawValue] as? [String],
      let location = document[UserCardModel.CodingKeys.location.rawValue] as? [String: Any],
      let coordinates = location[Location.CodingKeys.coordinates.rawValue] as? [String: String],
      let gender = document[UserCardModel.CodingKeys.gender.rawValue] as? String,
      let date = dob[BirthDate.CodingKeys.date.rawValue] as? String,
      let age = dob[BirthDate.CodingKeys.age.rawValue] as? Int,
      let longitude = coordinates[Coordinates.CodingKeys.longitude.rawValue],
      let latitude = coordinates[Coordinates.CodingKeys.latitude.rawValue],
      let large = image[WebImage.CodingKeys.large.rawValue],
      let thumbnail = image[WebImage.CodingKeys.thumbnail.rawValue],
      let first = name[Name.CodingKeys.first.rawValue],
      let last = name[Name.CodingKeys.last.rawValue],
      let city = location[Location.CodingKeys.city.rawValue]! as? String
    else {
      return nil
    }
    
    self.id = UID(value: id[UID.CodingKeys.value.rawValue]!)
    self.picture = WebImage(
      large: large,
      thumbnail: thumbnail)
    self.interests = interests.map { Interest(rawValue: $0)! }.toSet()
    self.name = Name(
      first: first,
      last: last)
    self.picture = WebImage(
      large: large,
      thumbnail: thumbnail)
    self.location = Location(
      city: city,
      coordinates: Coordinates(
        latitude: latitude,
        longitude: longitude))
    self.birthDate = BirthDate(
      date: date,
      age: age)
    self.gender = Gender(rawValue: gender)!
  }
}

extension UserCardModel: Equatable {
  static func == (lhs: UserCardModel, rhs: UserCardModel) -> Bool {
    guard let lid = lhs.id.value, let rid = rhs.id.value else { return false }
    return lid == rid
  }
}
