//
//  ArrayExtensionTest.swift
//  TinderAppTests
//
//  Created by Timofey on 1/6/22.
//

import XCTest
@testable import TinderApp

class ArrayExtensionTest: XCTestCase {
  
  func testShiftReturnsAndDeleteFirstElement() {
    var array = Array(0...100).shuffled()
    let fst = array[0]
    let snd = array[1]
    guard let first = array.shift() else {
      XCTFail("First != array.shift")
      return
    }
    XCTAssertEqual(snd, array[0])
    XCTAssertEqual(fst, first)
  }

}
