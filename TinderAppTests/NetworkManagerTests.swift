//
//  NetworkManagerTests.swift
//  TinderAppTests
//
//  Created by Timofey on 8/7/22.
//

import Foundation
import XCTest
@testable import TinderApp

class NetworkManagerTests: XCTestCase {
  
  var sut: MockNetworkManager!
  
  
  override func setUp() {
    super.setUp()
    sut = MockNetworkManager()
  }
  
  override func tearDown() {
    sut = nil
    super.tearDown()
  }
  
  func testNetworkManagerSetParametrs() {
    let apiPath = "https://randomuser.me/api/"
    let parametrs = [
      "results": 100,
      "inc": "location,id",
      "noinfo": nil
    ] as [String : Any?]
    
    guard let url = URL(string: apiPath) else {
      XCTFail("bad url")
      return
    }
    var urlComp = URLComponents(url: url, resolvingAgainstBaseURL: true)
    var queryItems = [URLQueryItem]()
    for parametr in parametrs {
      let item: URLQueryItem!
      if let parametrValue = parametr.value {
        item = URLQueryItem(
          name: parametr.key,
          value: "\(parametrValue)".addingPercentEncoding(
            withAllowedCharacters: .urlPathAllowed))
      } else {
        item = URLQueryItem(name: parametr.key, value: nil)
      }
      queryItems.append(item)
    }
    urlComp?.queryItems = queryItems
    
    sut.request(with: apiPath, parametrs: parametrs) { _ in
      
    }
    let managerUrl = sut.mockUrlString
    
    XCTAssertEqual(managerUrl, urlComp?.url?.absoluteString)
  }
}


class MockNetworkManager: NetworkManager {
  var mockUrlString: String = ""
  private let session = URLSession.shared
  
  override func request(
    with urlString: String,
    parametrs: Parametr?,
    completion: @escaping ((Result<Data, Error>) -> Void)
  ) {
    guard let url = URL(string: urlString),
          var urlComp = URLComponents(
            url: url,
            resolvingAgainstBaseURL: true)
    else {
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
      self.mockUrlString = urlComp.url?.absoluteString ?? ""
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
