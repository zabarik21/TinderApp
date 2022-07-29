//
//  FirebaseService.swift
//  TinderApp
//
//  Created by Timofey on 28/7/22.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import UIKit

enum UserError: Error {
  case cannotGetUserData
  case cannotUnwrapToMuser
}

class FirestoreService {
  
  static let shared = FirestoreService()
  
  private let database = Firestore.firestore()
  
  private var usersRef: CollectionReference {
    return database.collection("users")
  }
  
  init() {}
  
  func getUserData(
    user: User,
    _ completion: @escaping (Result<UserCardModel, Error>) -> Void
  ) {
    let userRef = usersRef.document(user.uid)
    userRef.getDocument { document, error in
      if let error = error {
        completion(.failure(error))
        return
      }
      guard let document = document else {
        completion(.failure(UserError.cannotGetUserData))
        return
      }
      guard let userModel = UserCardModel(document: document) else {
        completion(.failure(UserError.cannotUnwrapToMuser))
        return
      }
      completion(.success(userModel))
    }
    
  }
  
  func saveProfileWith(
    id: String,
    name: Name,
    email: String,
    image: UIImage?,
    gender: Gender,
    location: Location?,
    birthDate: BirthDate,
    interests: Set<Interest>,
    completion: @escaping (Result<UserCardModel, Error>) -> Void
  ) {
    var user = UserCardModel(
      name: name,
      gender: gender,
      location: location ?? Location(),
      birthDate: birthDate,
      picture: WebImage(
        large: "nil",
        thumbnail: "nil"),
      id: UID(
        value: id),
      interests: interests)
    
    DispatchQueue.main.async {
      if let image = image {
        FirebaseStorageService.shared.uploadImage(image: image) { result in
          switch result {
          case .success(let url):
            user.picture.large = url.absoluteString
            user.picture.thumbnail = url.absoluteString
            self.usersRef.document(user.id.value!).setData(user.representation)
            completion(.success(user))
            return
          case .failure(let error):
            self.usersRef.document(user.id.value!).setData(user.representation)
            completion(.success(user))
            print(error)
          }
        }
      }
    }
  }
}
