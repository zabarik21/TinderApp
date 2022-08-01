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
    id: UID.init(value: UUID().uuidString),
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
    let expectation = expectation(description: "Load expectation")
    print(user.representation)
    var userFromFirestore: UserCardModel?
    FirestoreService.shared.saveProfileWith(
      id: user.id.value!,
      name: user.name,
      email: "timblack12@mail.ru",
      image: UIImage(named: "emojis"),
      gender: .female,
      location: user.location,
      birthDate: user.birthDate,
      interests: user.interests!) { result in
        switch result {
        case .success(let user):
          userFromFirestore = user
          expectation.fulfill()
        case .failure(let error):
          XCTFail(error.localizedDescription)
        }
      }
    
    wait(for: [expectation], timeout: 5)
    guard let checkedUser = userFromFirestore else {
      XCTFail("Nil user")
      return
    }
    
    XCTAssertEqual(user, checkedUser)
  }
  
}
