//
//  LocationModelTests.swift
//  TinderAppTests
//
//  Created by Timofey on 2/8/22.
//

import Foundation
import XCTest
import CoreLocation

class LocationModelTests: XCTestCase {
  
  func testFuncCalculateDistanceRight() {
    let fst = CLLocation(latitude: 31.78901, longitude: 62.68410)
    let snd = CLLocation(latitude: 31.211147, longitude: 62.263453)
    
    let kms = Int(fst.distance(from: snd) / 1000)
    
    print(kms)
  }

}
