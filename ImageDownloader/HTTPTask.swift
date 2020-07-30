//
//  HTTPTask.swift
//  ImageDownloader
//
//  Created by Astemir Shibzuhov on 30.07.2020.
//  Copyright © 2020 Astemir Shibzuhov. All rights reserved.
//

import Foundation

// typealias for header in http request
public typealias HTTPHeader = [String: String]

public enum HTTPTask {
  case request
  case requsetParameters(urlParameters: Parameters?, encoding: ParameterEncoding, allowedHeaders: HTTPHeader?)
  case download(urlParameters: Parameters?)
}
