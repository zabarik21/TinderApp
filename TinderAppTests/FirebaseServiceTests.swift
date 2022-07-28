//
//  FirebaseServiceTests.swift
//  TinderAppTests
//
//  Created by Timofey on 28/7/22.
//

import XCTest
@testable import TinderApp

class FirebaseServiceTests: XCTestCase {
  
  var sut: FirestoreService!
  
  let user = UserCardModel(
    name: Name(
      first: "Тимофей",
      last: "Резвых"),
    gender: .male,
    location: Location(
      city: "Perm",
      coordinates: Coordinates(
        latitude: "2",
        longitude: "3")),
    birthDate: BirthDate(
      date: "03.03.02",
      age: 19),
    picture: WebImage(
      large: "https://vgmsite.com/soundtracks/spongebob-battle-for-bikini-bottom-gc-xbox-ps2/coverart.jpg",
      thumbnail: "https://prodigits.co.uk/thumbs/android-games/thumbs/s/1396790468.jpg"),
    id: USERID.init(value: "3241145"),
    interests: Interest.getAllCases())
  
  override func setUp() {
    super.setUp()
    sut = FirestoreService()
  }
  
  override func tearDown() {
    sut = nil
    super.tearDown()
  }
 
  func testServiceSavesUser() {
    
  }
  
}
