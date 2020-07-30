//
//  PexelImagesDecoder.swift
//  ImageDownloader
//
//  Created by Astemir Shibzuhov on 26.07.2020.
//  Copyright © 2020 Astemir Shibzuhov. All rights reserved.
//

import Foundation

class PexelImagesDecoder<T: Codable> {
  fileprivate let decoder = JSONDecoder()
  
  func decode(keyWord: String, completion: @escaping (T) -> Void) {
    NetworkService.req(searchWord: keyWord) { (data) in
      do {
        let images = try self.decoder.decode(T.self, from: data)
        completion(images)
      } catch let error {
        print(error)
      }
    }
  }
}
