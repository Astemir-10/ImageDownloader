//
//  Router.swift
//  ImageDownloader
//
//  Created by Astemir Shibzuhov on 30.07.2020.
//  Copyright © 2020 Astemir Shibzuhov. All rights reserved.
//

import Foundation

public typealias NetworkRouterCompletion = (Data?, URLResponse?, Error?) -> Void

protocol NetworkRouter {
  associatedtype EndPoint: EndPointType
  func request(_ rout: EndPoint, completion: @escaping NetworkRouterCompletion)
  func cancel()
}

class Router<EndPoint: EndPointType>: NetworkRouter {
  fileprivate var task: URLSessionTask?
  
  func request(_ rout: EndPoint, completion: @escaping NetworkRouterCompletion) {
    let session = URLSession.shared
    do {
      let request = try buildRequest(from: rout)
      task = session.dataTask(with: request) { data, response, error in
        completion(data, response, error)
      }
    } catch {
      completion(nil, nil, error)
    }
  }
  
  func cancel() {
    task?.cancel()
  }
  
  fileprivate func buildRequest(from route: EndPoint) throws -> URLRequest {
    var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path), cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0)
    request.httpMethod = route.httpMethod.rawValue
    do {
      switch route.task {
      case .request:
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      case .requsetParameters(urlParameters: let urlParameters, encoding: let encoding, allowedHeaders: let allowedHeaders):
        try self.configureParameters(encoding: encoding, urlParameter: urlParameters, with: &request)
        self.additionalHeader(additionalHeaders: allowedHeaders, request: &request)
      case .download(urlParameters: let urlParameters):
        break
      }
      return request
    } catch {
      throw error
    }
    
  }
  
  fileprivate func configureParameters(encoding: ParameterEncoding, urlParameter: Parameters?, with request: inout URLRequest) throws {
    do {
      try encoding.encode(request: &request, with: urlParameter)
    } catch {
      throw error
    }
  }
  
  fileprivate func additionalHeader(additionalHeaders: HTTPHeader?, request: inout URLRequest) {
    guard let headers = additionalHeaders else {return}
    for (key, value) in headers {
      request.setValue(key, forHTTPHeaderField: value)
    }
  }
}
