//
//  ListenerService.swift
//  TinderApp
//
//  Created by Timofey on 29/7/22.
//

import Firebase
import FirebaseFirestore

enum ListenerError: Error {
  case nilSnapshot
}

class ListenerService {
  
  static let shared = ListenerService()
  
  private let dataBase = Firestore.firestore()
  
  private var usersRef: CollectionReference {
    return dataBase.collection("users")
  }
  
  private var currentUserId: String {
    return Auth.auth().currentUser!.uid
  }
  
  func observeUsers(
    users: [UserCardModel],
    completion: @escaping (Result<[UserCardModel], Error>) -> Void
  ) -> ListenerRegistration {
    var users = users
    
    let usersListener = usersRef.addSnapshotListener { querySnapshot, error in
      if let error = error {
        completion(.failure(error))
        return
      }
      guard let querySnapshot = querySnapshot else {
        completion(.failure(ListenerError.nilSnapshot))
        return
      }
      
      for difference in querySnapshot.documentChanges {
        guard let userModel = UserCardModel(document: difference.document) else {
          completion(.failure(UserError.cannotUnwrapToMuser))
          return
        }
        
        switch difference.type {
        case .added:
          guard !users.contains(userModel) else { continue }
          guard userModel.id.value != self.currentUserId else { continue }
          users.append(userModel)
        case .modified:
          guard let index = users.firstIndex(of: userModel) else { continue }
          users[index] = userModel
        case .removed:
          guard let index = users.firstIndex(of: userModel) else { continue }
          users.remove(at: index)
        }
      }
      completion(.success(users))
    }
    return usersListener
  }
  
}
