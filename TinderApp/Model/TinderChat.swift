//
//  TinderChat.swift
//  TinderApp
//
//  Created by Timofey on 30/7/22.
//

import Foundation
import FirebaseFirestore

enum TinderChatError: Error {
  case chatRepresentationError
}


struct TinderChat: Hashable, Decodable {
  
  var friendUsername: String
  var lastMessageContent: String
  var friendImageString: String
  var friendId: String
 
  var representation: [String: Any] {
      let data = [
          "friendUsername" : friendUsername,
          "lastMessage" : lastMessageContent,
          "friendImageString" : friendImageString,
          "friendId" : friendId,
      ]
      return data
  }
  
  init?(friendUsername: String,
        lastMessageContent: String,
        friendImageString: String,
        friendId: String) {
      self.friendId = friendId
      self.friendImageString = friendImageString
      self.lastMessageContent = lastMessageContent
      self.friendUsername = friendUsername
  }
 
  init?(document: DocumentSnapshot) {
    guard let data = document.data() else { return nil }
      guard let friendId = data["friendId"] as? String,
            let friendImageString = data["friendImageString"] as? String,
            let friendUsername = data["friendUsername"] as? String,
            let lastMessage = data["lastMessage"] as? String
      else {
          return nil
      }
      self.friendId = friendId
      self.friendImageString = friendImageString
      self.lastMessageContent = lastMessage
      self.friendUsername = friendUsername
  }
  
  func hash(into hasher: inout Hasher) {
      hasher.combine(friendId)
  }
  
  static func == (lhs: TinderChat, rhs: TinderChat) -> Bool {
      return lhs.friendId == rhs.friendId
  }
  
}
