//
//  ContainerViewViewModel.swift
//  TinderApp
//
//  Created by Timofey on 31/5/22.
//

import Foundation


class CardContainerViewViewModel: CardContainerViewViewModelProtocol {
    
  var users: [UserCardViewViewModelProtocol]
  weak var delegate: CardContainerViewViewModelDelegate?
  
  func nextCard() -> UserCardViewViewModelProtocol? {
    if users.count < 5 {
      loadUsers()
    }
    return users.shift()
  }
  
  // init with users for случая when there are old saved users left in memory 
  init(users: [UserCardViewViewModel]) {
    self.users = users
    loadUsers()
  }
  
  func loadUsers() {
    guard let url = URL(string: "https://randomuser.me/api/?results=30&inc=gender,name,dob,location,picture,id&noinfo") else { return }
    let request = URLRequest(url: url)
    URLSession.shared.dataTask(with: request) { data, _, error in
      if let error = error {
        print(error)
      }
      guard let data = data else { return }
      var newUsers: [UserCardModel]?
      newUsers = try? JSONDecoder().decode(RandomPeopleApiResponce.self, from: data).results
      if let newUsers = newUsers {
        for user in newUsers {
          self.users.append(UserCardViewViewModel(with: user))
        }
        print("users loaded")
        self.delegate?.usersLoaded()
      }
      
    }.resume()
  }
}
