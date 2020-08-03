//
//  NetworkManager.swift
//  ImageDownloader
//
//  Created by Astemir Shibzuhov on 30.07.2020.
//  Copyright © 2020 Astemir Shibzuhov. All rights reserved.
//

import Foundation

enum NetworkResponse: String {
  case success
  case authenticationError = "You need to be authenticated first."
  case badRequest = "Bad request"
  case outdated = "The url you requested is outdated."
  case failed = "Network request failed."
  case noData = "Response returned with no data to decode."
  case unableToDecode = "We could not decode the response."
}

enum Result<String> {
  case success
  case failure(String)
}

struct NetworkManager {
  static let apiKey = "563492ad6f9170000100000183229c6e77c44b46903e1c73dc82b60e"
  let router = Router<PexelEndPoint>()
  
  func getImages(word: String = "popular", page: Int = 1, completion: @escaping (PexelsImage?, String?) -> Void) {
    
    router.request(.search(searchWord: word, page: page)) { (data, response, error) in
      if error != nil {
        completion(nil, "Please check your internet connection")
      }
      
      if let response = response as? HTTPURLResponse {
        let result = self.handlerHTTPResponse(response)
        switch result {
        case .success:
          guard let data = data else {
            completion(nil, NetworkResponse.noData.rawValue)
            return
          }
          do {
          let apiResponse = try JSONDecoder().decode(PexelsImage.self, from: data)
          completion(apiResponse, nil)
          } catch {completion(nil, NetworkResponse.unableToDecode.rawValue)}
        case .failure(let error):
          completion(nil, error)
        }
      }
    }
  }
  
  func downloadImage(for url: String, completion: @escaping(Data?, String?) -> Void) {
    router.request(.download(url: url)) { (data, response, error) in
      if error != nil {
        completion(nil, "Please check your url")
      }
      if let response = response as? HTTPURLResponse {
        let result = self.handlerHTTPResponse(response)
        switch result {
        case .success:
          guard let data = data else {
            completion(nil, NetworkResponse.noData.rawValue)
            return
          }
          completion(data, nil)
        case .failure(let error):
          completion(nil, error)
          
        }
      }
    }
  }
  
  fileprivate func handlerHTTPResponse(_ response: HTTPURLResponse) -> Result<String> {
    print(response.statusCode)
    switch response.statusCode {
    case 200...299:
      return .success
    case 401...500:
      return .failure(NetworkResponse.authenticationError.rawValue)
    case 501...599:
      return .failure(NetworkResponse.badRequest.rawValue)
    case 600:
      return.failure(NetworkResponse.outdated.rawValue)
    default:
      return.failure(NetworkResponse.failed.rawValue)
    }
  }
  
}
