//
//  RandomUserApi.swift
//  TinderApp
//
//  Created by Timofey on 8/7/22.
//

import Foundation


class RandomUserApi {
  
  private let apiUrlString = "https://randomuser.me/api/"
  
  private let networkManager = NetworkManager()
  
  private var apiIncludes: [String]
  
  init() {
    var inc = [String]()
    for key in UserCardModel.CodingKeys.allCases {
      inc.append(key.rawValue)
    }
    self.apiIncludes = inc
  }
  
  func fetchPeopleWithParametrs(count: Int = 25, completion: @escaping (Result<[UserCardModel], Error>) -> ()) {
    let includeParametr = ["results": count,
                           "inc": apiIncludes.joined(separator: ","),
                           "noinfo": nil] as [String : Any?]
    networkManager.request(with: apiUrlString, parametrs: includeParametr) { result in
      switch result {
      case .success(let data):
        if let apiResponce = try? JSONDecoder().decode(RandomPeopleApiResponce.self, from: data) {
          completion(.success(apiResponce.results))
        } else {
          completion(.failure(NetworkError.decodeData))
        }
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
}
