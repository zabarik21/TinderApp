//
//  FirebaseService.swift
//  TinderApp
//
//  Created by Timofey on 28/7/22.
//

import Foundation
import FirebaseFirestore
import UIKit

class FirestoreService {
  
  static let shared = FirestoreService()
  
  private let database = Firestore.firestore()
  
  private var usersRef: CollectionReference {
    return database.collection("users")
  }
  
  init() {}
  
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
      id: USERID(
        value: id),
      interests: interests)
    
    DispatchQueue.main.async {
      DispatchQueue.global().sync {
        if let image = image {
          FirebaseStorageService.shared.uploadImage(image: image) { result in
            switch result {
            case .success(let url):
              user.picture.large = url.absoluteString
              user.picture.thumbnail = url.absoluteString
            case .failure(let error):
              print(error)
            }
          }
        }
      }
      self.usersRef.document(user.id.value!).setData(user.representation)
      completion(.success(user))
    }
  }
}
