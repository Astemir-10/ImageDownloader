//
//  SearchImageViewModel.swift
//  ImageDownloader
//
//  Created by Astemir Shibzuhov on 26.07.2020.
//  Copyright © 2020 Astemir Shibzuhov. All rights reserved.
//

import Foundation
import RxSwift

class SearchImageViewModel {
  var images: PublishSubject<[PexelsImage.Photo]>!
  let pexelDecoder = PexelImagesDecoder<PexelsImage>()
  
  func requestPexelImages() {
    pexelDecoder.decode(keyWord: "popular") {  (pexels) in
      self.images.onNext(pexels.photos)
      
    }
  }
  
  func request(for keyWord: String?) {
    pexelDecoder.decode(keyWord: keyWord ?? "") { (photos) in
      self.images.onNext(photos.photos)
    }
  }
  
  init() {
    images = PublishSubject<[PexelsImage.Photo]>()
  }
}
