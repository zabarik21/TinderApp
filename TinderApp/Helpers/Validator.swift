//
//  Validator.swift
//  TinderApp
//
//  Created by Timofey on 28/7/22.
//

import Foundation

enum Validator {
  
  static func isFilled(
    email: String?,
    password: String?,
    confirmPassword: String?
  ) -> Bool {
    guard let password = password,
          let confirmPassword = confirmPassword,
          let email = email,
          password != " ",
          email != " ",
          isValidEmail(email),
          confirmPassword != " " else {
            return false
          }
    return true
  }
  
  static func isValidEmail(_ email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
    return emailPred.evaluate(with: email)
  }
  
}
