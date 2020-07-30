//
//  PexelsImage.swift
//  ImageDownloader
//
//  Created by Astemir Shibzuhov on 26.07.2020.
//  Copyright © 2020 Astemir Shibzuhov. All rights reserved.
//

import Foundation

struct PexelsImage: Codable {
  let photos: [Photo]
  
  struct Photo: Codable {
    let width: Int
    let height: Int
    let url: String
    let photographer: String
    //  let photographerUrl: String
    //  let photographerID: Int
    let src: PexelsImage.SRC
  }
  struct SRC: Codable {
    let original: String
    let large2x: String
    let large: String
    let medium: String
    let small: String
  }
}
