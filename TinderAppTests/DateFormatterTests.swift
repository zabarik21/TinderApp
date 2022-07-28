//
//  DateFormatterTests.swift
//  TinderAppTests
//
//  Created by Timofey on 28/7/22.
//

import XCTest
@testable import TinderApp

class DateFormatterTests: XCTestCase {
   
  var sut: CustomDateFormatter!
  
  override func setUp() {
    super.setUp()
    sut = CustomDateFormatter.shared
  }
  
  override func tearDown() {
    super.tearDown()
    sut = nil
  }
 
  func testFormatterReturnsRightString() {
    var components = DateComponents()
    components.day = 8
    components.month = 4
    components.year = 2002
    guard let date = Calendar.current.date(from: components) else {
      XCTFail()
      return
    }
    let dateString = sut.getFormattedString(date)
    XCTAssertEqual("08/04/2002", dateString)
  }
  
  func testFormatterCalculatesAgeRight() {
    var components = DateComponents()
    components.day = 4
    components.month = 8
    components.year = 2002
    guard let date = Calendar.current.date(from: components) else {
      XCTFail()
      return
    }
    
    let age = sut.yearsBetweenDate(startDate: date)
    XCTAssertEqual(19, age)
  }
  
}
