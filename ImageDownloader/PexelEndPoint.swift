//
//  PexelEndPoint.swift
//  ImageDownloader
//
//  Created by Astemir Shibzuhov on 30.07.2020.
//  Copyright © 2020 Astemir Shibzuhov. All rights reserved.
//

import Foundation

enum PexelEndPoint {
  case search(searchWord: String, page: Int)
  case download(url: String?)
}

extension PexelEndPoint: EndPointType {
  var baseURL: URL {
    guard let url = URL(string: "https://api.pexels.com/v1/") else {fatalError("URL Error")}
    return url
  }
  
  var path: String {
    return "search"
  }
  
  var task: HTTPTask {
    switch self {
    case .search(searchWord: let searchWord, let page):
      return .requsetParameters(urlParameters: ["query": searchWord, "page": "\(page)"], encoding: .urlEncoding, allowedHeaders: headers)
    case .download(url: let url):
      return .download(url: url)
    }
  }
  
  var headers: HTTPHeader? {
    return ["Authorization": NetworkManager.apiKey]
  }
  
  var httpMethod: HTTPMethod {
    return .get
  }
}
