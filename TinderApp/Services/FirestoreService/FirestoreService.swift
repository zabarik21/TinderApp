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
      "checkedUsers"
    ].joined(separator: "/"))
  }
  
  private var activeChats: CollectionReference {
    return database.collection([
      "users",
      currentUser.id.value!,
      "activeChats"
    ].joined(separator: "/"))
  }
  
  private var chatsRef: CollectionReference {
    return database.collection([
      "users",
      currentUser.id.value!,
      "chats"
    ].joined(separator: "/"))
  }
  
  private func friendChatsRef(friendId: String) -> CollectionReference {
    return database.collection([
      "users",
      friendId,
      "chats"
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
    
    let chat = TinderChat(
      friendUsername: reciever.name.first,
      lastMessageContent: message,
      friendImageString: reciever.picture.large,
      friendId: reciever.id.value!)
    
    
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
    likedRef.setData(currentUser.id.representation) { error in
      if let error = error {
        print(error)
      } else {
        print("Sucessfully liked user")
      }
    }
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
  
  func createChat(
    friend: UserCardModel,
    completion: @escaping (Result<Void, Error>) -> Void
  ) {
    let group = DispatchGroup()
    group.enter()
    let selfChat = TinderChat(
      friendUsername: friend.name.first,
      lastMessageContent: "",
      friendImageString: friend.picture.thumbnail,
      friendId: friend.id.value!)
    let friendChat = selfChat.toFriendChat(user: self.currentUser)
    let friendId = friend.id.value!
    let selfId = self.currentUser.id.value!
    
    chatsRef.document(friendId).setData(selfChat.representation) { error in
      if let error = error {
        print(error)
        completion(.failure(error))
        return
      }
    }
    
    let friendChatsRef = friendChatsRef(friendId: friendId)
    
    friendChatsRef.document(selfId).setData(friendChat.representation) { error in
      if let error = error {
        print(error)
        completion(.failure(error))
        return
      }
      completion(.success(()))
    }
  }
  
  
  func addToChecked(
    user: UserCardModel,
    completion: @escaping (Result<Void, Error>) -> Void
  ) {
    checkedUsers.document(user.id.value!).setData(user.id.representation) { error in
      if let error = error {
        print(error)
        completion(.failure(error))
      }
      completion(.success(()))
    }
  }

  func getCheckedUsers(completion: @escaping (Result<Set<String>, Error>) -> Void) {
    checkedUsers.getDocuments { quetySnapshot, error in
      
      if let error = error {
        completion(.failure(error))
      }

      guard let snapshot = quetySnapshot else {
        completion(.failure(FirestoreError.nilData))
        return
      }

      var ids = Set<String>()
      for document in snapshot.documents {
        if let id = UID(document: document) {
          ids.insert(id.value!)
        }
      }
      completion(.success(ids))
    }
  }
  
}

