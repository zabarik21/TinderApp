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
    DispatchQueue.global(qos: .utility).async { [weak self] in
      self?.networkManager.request(with: self!.apiUrlString, parametrs: includeParametr) { result in
        switch result {
        case .success(let data):
          do {
            let apiResponce = try JSONDecoder().decode(RandomPeopleApiResponce.self, from: data)
            completion(.success(apiResponce.results))
          } catch {
            print(error)
          }
        case .failure(let error):
          completion(.failure(error))
        }
      }
    }
  }
}
