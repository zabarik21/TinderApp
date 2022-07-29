//
//  AuthenticationServiceTests.swift
//  TinderAppTests
//
//  Created by Timofey on 28/7/22.
//

import XCTest
import FirebaseAuth
@testable import TinderApp

class AuthenticationServiceTests: XCTestCase {
  
  var sut: AuthenticationService!
  
  let email = "testemail@mail.com"
  let password = "password"
    
  override func setUp() {
    super.setUp()
    sut = AuthenticationService()
  }
  
  override func tearDown() {
    sut = nil
    super.tearDown()
  }
 
  func testServiceRegisterUserAndDeleteIt() {
    let registerExpectation = expectation(description: "firebase auth waiting")
    var user: User?
    sut.registerUser(
      email: email,
      password: password) { result in
        switch result {
        case .success(let registered):
          user = registered
          registerExpectation.fulfill()
        case .failure(let error):
          XCTFail(error.localizedDescription)
        }
    }
    wait(for: [registerExpectation], timeout: 5)
    
    guard user != nil else {
      XCTFail("current user is nil")
      return
    }
    
    XCTAssertNotNil(sut.getCurrentUser())
    
    let deleteExpectation = expectation(description: "delete expectation")
    
    sut.deleteUser { result in
      switch result {
      case .failure(let error):
        XCTFail(error.localizedDescription)
      case .success(_):
        deleteExpectation.fulfill()
      }
    }
    wait(for: [deleteExpectation], timeout: 5)
    XCTAssertNil(sut.getCurrentUser())
  }
  
}
