//
//  UserCardViewViewModelProtocol.swift
//  TinderApp
//
//  Created by Timofey on 31/5/22.
//

import Foundation

protocol UserCardViewViewModelProtocol {
  var name: String { get }
  var age: Int { get }
  var city: String { get }
  var imageUrlString: String { get }
}
