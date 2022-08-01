//
//  DemoModeService.swift
//  TinderApp
//
//  Created by Timofey on 29/7/22.
//

import Foundation


class DemoModeService {
  
  static let shared = DemoModeService()
  
  static var isDemoMode: Bool {
    return StorageService.shared.demoMode()
  }
  
  func toggleDemo(to bool: Bool) {
    print("Demo mode setted to \(bool)")
    StorageService.shared.setDemoMode(bool)
  }
  
}
