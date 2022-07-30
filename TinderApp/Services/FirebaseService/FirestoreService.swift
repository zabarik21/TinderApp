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
  
  private var waitingChats: CollectionReference {
    return database.collection([
      "users",
      currentUser.id.value!,
      "waitingChats"
    ].joined(separator: "/"))
  }
  
  private var dislikedUsers: CollectionReference {
    return database.collection([
      "users",
      currentUser.id.value!,
      "dislikedUsers"
    ].joined(separator: "/"))
  }
  
  var currentUser: UserCardModel!
  
  init() {
    if currentUser == nil {
      currentUser = StorageService.shared.loadUser()
    }
  }
  
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
      self.currentUser = userModel
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
    self.currentUser = user
  }
  
  func createWaitingChat(
    message: String = "I want to chat with you",
    reciever: UserCardModel,
    completion: @escaping (Result<Void, Error>) -> Void
  ) {
    let messageRef = waitingChats.document(currentUser.id.value!).collection("messages")
    
    let tinderMessage = TinderMessage(user: currentUser, content: message)
    
    guard let chat = TinderChat(
      friendUsername: reciever.name.first,
      lastMessageContent: message,
      friendImageString: reciever.picture.large,
      friendId: reciever.id.value!) else {
        completion(.failure(TinderChatError.chatRepresentationError))
        return
      }
    
    
    waitingChats.document(reciever.id.value!).setData(chat.representation) { error in
      if let error = error {
        completion(.failure(error))
        return
      }
      messageRef.addDocument(data: tinderMessage.representation) { error in
        if let error = error {
          completion(.failure(error))
          return
        }
        completion(.success(()))
      }
    }
  }
    
  func removeUser(
    user: UserCardModel,
    completion: @escaping (Result<Void, Error>) -> Void
  ) {
    dislikedUsers.document(user.id.value!).setData(user.id.representation)
  }

  func getDislikedUsers(completion: @escaping (Result<Set<String>, Error>) -> Void) {
    dislikedUsers.getDocuments { quetySnapshot, error in
      if let error = error {
        completion(.failure(error))
      }
      if let documents = quetySnapshot?.documents {
        var ids = Set<String>()
        for document in documents {
          if let id = UID(document: document) {
            ids.insert(id.value!)
          }
        }
        completion(.success(ids))
      }
    }
  }
  
}

