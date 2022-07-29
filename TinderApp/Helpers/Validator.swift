//
//  Validator.swift
//  TinderApp
//
//  Created by Timofey on 28/7/22.
//

import Foundation

enum ValidatorFieldsError {
  case email
  case password
  case confirmPassword
}

enum Validator {
  
  static func isFilled(
    email: String?,
    password: String?,
    confirmPassword: String?
  ) -> [ValidatorFieldsError] {
    var errors = [ValidatorFieldsError]()
    if let password = password, !password.isEmpty {
      if let confirm = confirmPassword {
        if password != confirm {
          errors.append(.confirmPassword)
        }
      } else {
        errors.append(.confirmPassword)
      }
      
    } else {
      errors.append(.password)
    }
    if email == nil || !isValidEmail(email!) {
      errors.append(.email)
    }
    return errors
  }
  
  static func isValidEmail(_ email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
    return emailPred.evaluate(with: email)
  }
  
}
