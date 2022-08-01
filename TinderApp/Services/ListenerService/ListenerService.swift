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
  
  func observeLikedUsers(
    liked: Set<String>,
    completion: @escaping (Result<Set<String>, Error>) -> Void
  ) -> ListenerRegistration {
    var liked = liked
    var dislikedUsers = Set<String>()
    
    let group = DispatchGroup()
    group.enter()
    
    DispatchQueue.global(qos: .utility).async {
      FirestoreService.shared.getDislikedUsers(completion: { result in
        switch result {
        case .success(let ids):
          dislikedUsers = ids
        case .failure:
          break
        }
        group.leave()
      })
    }
    
    group.wait(timeout: .now() + 5)
    
    let likedListenre = usersRef.document(currentUserId).collection("likedBy").addSnapshotListener { snapshot, error in
      if let error = error {
        completion(.failure(error))
        return
      }
      guard let snapshot = snapshot else {
        completion(.failure(ListenerError.nilSnapshot))
        return
      }
      for difference in snapshot.documentChanges {
        
        guard let id = UID(document: difference.document)?.value else {
          completion(.failure(FirestoreError.decodeDocumentError))
          return
        }
        
        guard !dislikedUsers.contains(id) else {
          continue
        }
        
        switch difference.type {
        case .added:
          liked.insert(id)
        case .modified, .removed:
          break
        }
      }
      completion(.success(liked))
    }
    return likedListenre
  }
  
  func observeUsers(
    users: [UserCardModel],
    completion: @escaping (Result<[UserCardModel], Error>) -> Void
  ) -> ListenerRegistration {
    
    var users = users
    var alreadyLikedUsers = Set<String>()
    var dislikedUsers = Set<String>()
    
    let group = DispatchGroup()
    
    group.enter()
    
    DispatchQueue.global(qos: .utility).async {
      FirestoreService.shared.getDislikedUsers(completion: { result in
        switch result {
        case .success(let ids):
          dislikedUsers = ids
        case .failure:
          break
        }
        group.leave()
      })
    }
    
    if group.wait(timeout: .now() + 5) == .timedOut {
      completion(.failure(FirestoreError.timeOut))
    }
    
    group.enter()
    
    DispatchQueue.global(qos: .utility).async {
      FirestoreService.shared.getAlreadyLikedUsers(completion: { result in
        switch result {
        case .success(let users):
          alreadyLikedUsers = users
        case .failure:
          break
        }
        group.leave()
      })
    }
    
    if group.wait(timeout: .now() + 5) == .timedOut {
      completion(.failure(FirestoreError.timeOut))
    }
    
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
          completion(.failure(FirestoreError.decodeDocumentError))
          return
        }
        
        guard !dislikedUsers.contains(userModel.id.value!) else { continue }
        guard !alreadyLikedUsers.contains(userModel.id.value!) else { continue }
        
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
