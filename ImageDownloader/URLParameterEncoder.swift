//
//  URLParameterEncoder.swift
//  ImageDownloader
//
//  Created by Astemir Shibzuhov on 30.07.2020.
//  Copyright © 2020 Astemir Shibzuhov. All rights reserved.
//

import Foundation

public struct URLParametersEncoder: ParameterEncoder {
  public func encode(urlRequest: inout URLRequest, parameters: Parameters) throws {
    guard let url = urlRequest.url else {throw NetworkError.urlError}
    
    if var urlComponents = URLComponents(url: url,
                                         resolvingAgainstBaseURL: false), !parameters.isEmpty {
      urlComponents.queryItems = [URLQueryItem]()
      
      for (key, value) in parameters {
        let queryItem = URLQueryItem(name: key,
                                     value: "\(value)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))
        urlComponents.queryItems?.append(queryItem)
      }
      urlRequest.url = urlComponents.url
    }
    
    if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
      urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8",
                          forHTTPHeaderField: "Content-Type")
    }
  }
}
