//
//  AuthenticationService.swift
//  TinderApp
//
//  Created by Timofey on 28/7/22.
//

import Foundation
import Firebase
import RxSwift

class AuthenticationService {
  
  static let shared = AuthenticationService()
  
  private let auth = Auth.auth()
  
  func registerUser(
    email: String,
    password: String,
    completion: @escaping (Result<User, Error>) -> Void
  ) {
    auth.createUser(
      withEmail: email,
      password: password
    ) { result, error in
        guard let result = result else {
          completion(.failure(error!))
          return
        }
        completion(.success(result.user))
    }
  }
  
  func logoutUser() throws {
    try auth.signOut()
  }
  
  func loginUser(
    email: String,
    password: String,
    _ completion: @escaping (Result<User, Error>) -> Void
  ) {
    auth.signIn(
      withEmail: email,
      password: password
    ) { result, error in
        guard let result = result else {
          completion(.failure(error!))
          return
        }
        completion(.success(result.user))
    }
  }
  
  func deleteUser(_ completion: @escaping (Result<Void, Error>) -> Void) {
    auth.currentUser?.delete(completion: { error in
      if let error = error {
        completion(.failure(error))
      } else {
        completion(.success(()))
      }
    })
  }
  
  func getCurrentUser() -> User? {
    return auth.currentUser
  }
}
