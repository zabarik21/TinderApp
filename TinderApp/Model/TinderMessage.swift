//
//  TinderMessage.swift
//  TinderApp
//
//  Created by Timofey on 30/7/22.
//

import Foundation
import FirebaseFirestore

protocol SenderType {
  var senderId: String { get }
  var displayName: String { get }
  
}

struct TinderSender: SenderType {
  var senderId: String
  var displayName: String
}



struct TinderMessage: Hashable, Equatable {
  
  var sender: SenderType
  
  let content: String
  
  let sentDate: Date
  
  let id: String?
  
  var messageId: String {
    return id ?? UUID().uuidString
  }
  
  var representation: [String: Any] {
    let data: [String: Any] = [
      "created": sentDate,
      "senderUsername": sender.displayName,
      "senderId": sender.senderId,
      "content": content
    ]
    return data
  }
  
  
  init?(document: QueryDocumentSnapshot) {
    let data = document.data()
    guard let content = data["content"] as? String,
          let sendDate = data["created"] as? Timestamp,
          let senderId = data["senderId"] as? String,
          let senderUsername = data["senderUsername"] as? String
    else {
      return nil
    }
    self.id = document.documentID
    self.content = content
    self.sentDate = sendDate.dateValue()
    self.sender = TinderSender(senderId: senderId, displayName: senderUsername)
  }
  
  
  init(user: UserCardModel, content: String) {
    self.content = content
    self.sender = TinderSender(senderId: user.id.value!, displayName: user.name.first)
    sentDate = Date()
    id = nil
  }
  
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(messageId)
  }
  
  static func == (lhs: TinderMessage, rhs: TinderMessage) -> Bool {
    return lhs.messageId == rhs.messageId
  }
}

extension TinderMessage: Comparable {
  
  static func < (lhs: TinderMessage, rhs: TinderMessage) -> Bool {
    return lhs.sentDate < rhs.sentDate
  }
  
  
}
