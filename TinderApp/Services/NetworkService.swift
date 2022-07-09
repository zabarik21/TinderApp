//
//  NetworkService.swift
//  TinderApp
//
//  Created by Timofey on 7/7/22.
//

import Foundation


enum NetworkServiceError: Error {
  case nilData
}

class NetworkService {
  
  func request(with url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
    let session = URLSession.shared
    session.dataTask(with: url) { data, responce, error in
      DispatchQueue.main.async {
        if let error = error {
          completion(.failure(error))
        }
        if let data = data {
          completion(.success(data))
        } else {
          completion(.failure(NetworkServiceError.nilData))
        }
      }
    }
  }
  
}
