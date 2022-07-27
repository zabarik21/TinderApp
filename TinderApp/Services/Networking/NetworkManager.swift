//
//  NetwrokManager.swift
//  TinderApp
//
//  Created by Timofey on 8/7/22.
//

import Foundation


enum NetworkError: String, Error {
  case invalidURL = "Invalid URL"
  case nilData = "Nil data"
  case decodeData = "Failed to decode data"
}

typealias Parametr = [String: Any?]

class NetworkManager {
  
  private let session = URLSession.shared
  
  func request(
    with urlString: String,
    parametrs: Parametr?,
    completion: @escaping ((Result<Data, Error>) -> Void)
  ) {
    
    guard let url = URL(string: urlString),
          var urlComp = URLComponents(
            url: url,
            resolvingAgainstBaseURL: true) else {
            completion(.failure(NetworkError.invalidURL))
            return
          }
    if let parametrs = parametrs {
      var queryItems = [URLQueryItem]()
      for (key, value)  in parametrs {
        var item: URLQueryItem!
        if let value = value {
          item = URLQueryItem(
            name: key,
            value: "\(value)".addingPercentEncoding(withAllowedCharacters: .urlPathAllowed))
        } else {
          item = URLQueryItem(name: key, value: nil)
        }
        queryItems.append(item)
      }
      urlComp.queryItems = queryItems
    }
    session.dataTask(with: urlComp.url!) { data, _, error in
      if let error = error {
        completion(.failure(error))
      }
      if let data = data {
        completion(.success(data))
      }
    }
    .resume()
  }
  
}
