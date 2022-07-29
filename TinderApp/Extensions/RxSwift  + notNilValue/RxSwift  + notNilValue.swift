//
//  RxSwift  + notNilValue.swift
//  TinderApp
//
//  Created by Timofey on 28/7/22.
//

import RxSwift


protocol OptionalType {
  associatedtype Wrapped
  var asOptional: Wrapped? { get }
}

extension Optional: OptionalType {
  var asOptional: Wrapped? { return self }
}

extension Observable where Element: OptionalType {
  func unwrappedOptional() -> Observable<Element.Wrapped> {
    return self
      .filter { $0.asOptional != nil }
      .map { $0.asOptional! }
  }
}
