//
//  EndPointType.swift
//  ImageDownloader
//
//  Created by Astemir Shibzuhov on 30.07.2020.
//  Copyright © 2020 Astemir Shibzuhov. All rights reserved.
//

import Foundation

protocol EndPointType {
  var baseURL: URL { get }
  var path: String { get }
  var task: HTTPTask { get }
  var headers: HTTPHeader? { get }
  var httpMethod: HTTPMethod { get }
}
