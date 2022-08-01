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
import SwiftUI



enum FirestoreError: Error {
  case decodeDocumentError
  case nilData
  case timeOut
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
  
  private var checkedUsers: CollectionReference {
    return database.collection([
      "users",
      currentUser.id.value!,
      "dislikedUsers"
    ].joined(separator: "/"))
  }
  
  private var activeChats: CollectionReference {
    return database.collection([
      "users",
      currentUser.id.value!,
      "activeChats"
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
        completion(.failure(FirestoreError.nilData))
        return
      }
      guard let userModel = UserCardModel(document: document) else {
        completion(.failure(FirestoreError.decodeDocumentError))
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
  
  func addLikeInfoToUser(
    likedUser: UserCardModel
  ) {
    let likedRef = usersRef.document(likedUser.id.value!).collection("likedBy").document("\(currentUser.id.value!)")
    likedRef.setData(currentUser.id.representation)
  }
    
  func getWaitingChatMessages(
    chat: TinderChat,
    completion: @escaping (Result<[TinderMessage], Error>) -> Void
  ) {
    waitingChats.document(chat.friendId).collection("mesasges").getDocuments { querySnapshot, error in
      var messages = [TinderMessage]()
      if let error = error {
        completion(.failure(error))
      }
      guard let documents = querySnapshot?.documents else {
        completion(.failure(FirestoreError.nilData))
        return
      }
      for document in documents {
        guard let message = TinderMessage(document: document) else {
          completion(.failure(FirestoreError.nilData))
          return
        }
        messages.append(message)
      }
      completion(.success(messages))
    }
  }
  
  func getWaitingChatData(
    chatId: String,
    completion: @escaping (Result<TinderChat, Error>) -> Void
  ) {
    let chatReference = usersRef.document(chatId).collection("waitingChats").document(currentUser.id.value!)
    
    chatReference.getDocument { document, error in
      if let error = error {
        completion(.failure(error))
        return
      }
      guard let document = document else {
        completion(.failure(FirestoreError.nilData))
        return
      }
      guard let chat = TinderChat(document: document) else {
        completion(.failure(FirestoreError.decodeDocumentError))
        return
      }
      completion(.success(chat))
    }
  }
  
  func changeChatToActive(
    friendId: String,
    completion: @escaping (Result<Void, Error>) -> Void
  ) {
    let group = DispatchGroup()
    group.enter()
    var chat: TinderChat?
    getWaitingChatData(chatId: friendId) { result in
      switch result {
      case .success(let chatInfo):
        chat = chatInfo
        group.leave()
      case .failure(let error):
        completion(.failure(error))
      }
    }
    
    if group.wait(timeout: .now() + 5) == .timedOut {
      completion(.failure(FirestoreError.timeOut))
      return
    }
    
    guard let chat = chat else {
      completion(.failure(FirestoreError.nilData))
      return
    }
    
    getWaitingChatMessages(chat: chat) { result in
      switch result {
      case .success(let messages):
        self.deleteWaitingChat(chat: chat) { result in
          switch result {
          case .failure(let error):
            completion(.failure(error))
          case .success:
            self.createActiveChat(chat: chat, messages: messages) { result in
              switch result {
              case .failure(let error):
                completion(.failure(error))
              case .success:
                completion(.success(()))
              }
            }
          }
        }
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
  
  func createActiveChat(
    chat: TinderChat,
    messages: [TinderMessage],
    completion: @escaping (Result<Void, Error>) -> Void
  ) {
    let messageRef = activeChats.document(chat.friendId).collection("messages")
      
    messageRef.document(chat.friendId).setData(chat.representation) { error in
      if let error = error {
        completion(.failure(error))
        return
      }
      
      for message in messages {
        messageRef.addDocument(data: message.representation) { error in
          if let error = error {
            completion(.failure(error))
            return
          }
        }
      }
      completion(.success(()))
    }
      
    
    
  }
  
  func deleteWaitingChat(
    chat: TinderChat,
    completion: @escaping (Result<Void, Error>) -> Void
  ) {
    waitingChats.document(chat.friendId).delete { error in
      if let error = error {
        completion(.failure(error))
      }
      completion(.success(()))
    }
    self.deleteMessages(chat: chat, completion: completion)
  }
  
  func deleteMessages(
    chat: TinderChat,
    completion: @escaping (Result<Void, Error>) -> Void
  ) {
    let reference = waitingChats.document(chat.friendId).collection("messages")
    getWaitingChatMessages(chat: chat) { result in
      switch result {
      case .success(let messages):
        for message in messages {
          guard let docId = message.id else { return }
          let messageRef = reference.document(docId)
          messageRef.delete { error in
            if let error = error {
              completion(.failure(error))
              return
            }
          }
          completion(.success(Void()))
        }
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
  
  func addToCheckedUsers(
    user: UserCardModel,
    completion: @escaping (Result<Void, Error>) -> Void
  ) {
    checkedUsers.document(user.id.value!).setData(user.id.representation)
  }

  func getDislikedUsers(completion: @escaping (Result<Set<String>, Error>) -> Void) {
    checkedUsers.getDocuments { quetySnapshot, error in
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
  
  func getAlreadyLikedUsers(completion: @escaping ((Result<Set<String>, Error>) -> Void)) {
    var liked = Set<String>()
    activeChats.getDocuments { snapshot, error in
      if let error = error {
        completion(.failure(error))
      }
      guard let snapshot = snapshot else {
        completion(.failure(FirestoreError.nilData))
        return
      }
      for document in snapshot.documents {
        liked.insert(document.documentID)
      }
    }
    waitingChats.getDocuments { snapshot, error in
      if let error = error {
        completion(.failure(error))
      }
      guard let snapshot = snapshot else {
        completion(.failure(FirestoreError.nilData))
        return
      }
      for document in snapshot.documents {
        liked.insert(document.documentID)
      }
    }
    completion(.success(liked))
  }
  
}

