//
//  PhotoModelCoreData.swift
//  ImageDownloader
//
//  Created by Astemir Shibzuhov on 03.08.2020.
//  Copyright © 2020 Astemir Shibzuhov. All rights reserved.
//

import Foundation

struct PhotoModelCoreData {
  let url: String
  let photo: Data?
  
  init(url: String?, photoData: Data?) {
    guard let url = url else {fatalError("No photo model")}
    self.url = url
    self.photo = photoData
  }
}
