//
//  NetworkService.swift
//  ImageDownloader
//
//  Created by Astemir Shibzuhov on 25.07.2020.
//  Copyright © 2020 Astemir Shibzuhov. All rights reserved.
//

import Foundation

var apiKey = "563492ad6f9170000100000183229c6e77c44b46903e1c73dc82b60e"

class NetworkService {
  private let session = URLSession.shared
  
  static func req(searchWord: String, completion: @escaping (Data) -> Void) {
    let session = URLSession.shared
    guard let url = URL(string: "https://api.pexels.com/v1/search?query=\(searchWord)&per_page=12") else {print("Error");return}
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.allHTTPHeaderFields = ["Authorization": apiKey]
    session.dataTask(with: request) { data, _, error in
      if let error = error {
        print(error.localizedDescription)
        return
      }
      guard let data = data else {return}
      completion(data)
    }.resume()
  }
  
  static func loadData(url: URL, completion: @escaping (Data) -> Void) {
    let session = URLSession.shared
    session.dataTask(with: url) {data, _, error in
      if let error = error {
        print(error.localizedDescription)
        return
      }
      
      guard let data = data else {return}
      completion(data)
    }.resume()
  }
}
