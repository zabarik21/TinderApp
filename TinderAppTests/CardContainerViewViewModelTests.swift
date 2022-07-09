//
//  CardContainerViewViewModelTests.swift
//  TinderAppTests
//
//  Created by Timofey on 7/7/22.
//

import Foundation


import XCTest
@testable import TinderApp

class CardContainerViewViewModelTests: XCTestCase {
  
//  var sut: CardContainerViewViewModel!
  var user = UserCardModel(name: Name(first: "Foo",
                                      last: "Bar"),
                           gender: .male,
                           location: Location(city: "Perm",
                                              coordinates: Coordinates(latitude: "2", longitude: "3")),
                           birthDate: BirthDate(date: "01.02.03", age: 12),
                           picture: WebImage(large: "Bar", thumbnail: "Baz"),
                           id: ID(value: "1"))
  
  override func setUpWithError() throws {
//    sut = CardContainerViewViewModel(users: [], user: user)
  }
  
  override func tearDownWithError() throws {
//    sut = nil
  }
  
  func testSavedUsersLoadsOnReload() {
    
  }
  
  func testShiftReturnsAndDeleteFirstElement() {
   
  }

}
