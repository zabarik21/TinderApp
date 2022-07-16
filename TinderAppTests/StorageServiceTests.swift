//
//  StorageServiceTests.swift
//  TinderAppTests
//
//  Created by Timofey on 8/7/22.
//

import XCTest
@testable import TinderApp
import SwiftUI

class StorageServiceTests: XCTestCase {
  
  var sut: StorageService!
  
  let user = UserCardModel(name: Name(first: "Тимофей", last: "Резвых"),
                           gender: .male,
                           location: Location(city: "Perm",
                                              coordinates: Coordinates(latitude: "2", longitude: "3")),
                           birthDate: .init(date: "03.03.02", age: 19),
                           picture: WebImage(large: "https://vgmsite.com/soundtracks/spongebob-battle-for-bikini-bottom-gc-xbox-ps2/coverart.jpg",
                                             thumbnail: "https://prodigits.co.uk/thumbs/android-games/thumbs/s/1396790468.jpg"),
                           id: ID.init(value: "3241145"),
                                 interests: Interest.getAllCases())
  
  override func setUpWithError() throws {
    sut = StorageService.shared
  }
  
  override func tearDownWithError() throws {
    sut.resetData()
    sut = nil
  }
  
  func testUserModelCorrectDecodesAndEncodesIntoJson() {
    guard let jsonData = user.jsonRepresent() else {
      XCTFail()
      return
    }
    
    guard let decodedUser = try? JSONDecoder().decode(UserCardModel.self, from: jsonData) else {
      XCTFail()
      return
    }
            
    XCTAssertEqual(decodedUser, user)
  }
  
  func testStorageSavesUser() {
    sut.saveUser(user: user)
    
    guard let savedUser = sut.loadUser() else {
      XCTFail()
      return
    }
    
    XCTAssertEqual(user, savedUser) 
  }
  
}
