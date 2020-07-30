//
//  ParametersEncoding.swift
//  ImageDownloader
//
//  Created by Astemir Shibzuhov on 30.07.2020.
//  Copyright © 2020 Astemir Shibzuhov. All rights reserved.
//

import Foundation

public typealias Parameters = [String: Any]

public protocol ParameterEncoder {
  func encode(urlRequest: inout URLRequest, parameters: Parameters) throws
}

public enum ParameterEncoding {
  case urlEncoding
  
  func encode(request: inout URLRequest,
              with urlParameters: Parameters?) throws {
    do {
      switch self {
      
      case .urlEncoding:
        guard let urlParameters = urlParameters else {return}
        try URLParametersEncoder().encode(urlRequest: &request, parameters: urlParameters)
      }
    } catch {
      throw error
    }
  }
}
