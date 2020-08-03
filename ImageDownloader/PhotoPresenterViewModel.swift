//
//  PhotoPresenterViewModel.swift
//  ImageDownloader
//
//  Created by Astemir Shibzuhov on 27.07.2020.
//  Copyright © 2020 Astemir Shibzuhov. All rights reserved.
//

import Foundation
import RxSwift

class PhotoPresenterViewModel {
  var presentationImages: PublishSubject<[PexelsImage.Photo]>!
  var images: [PexelsImage.Photo]!
  var selectedIndex: IndexPath?
  
  init(selectedIndex: IndexPath, images: [PexelsImage.Photo]) {
    self.selectedIndex = selectedIndex
    self.images = images
    self.presentationImages = PublishSubject<[PexelsImage.Photo]>()
  }
}
