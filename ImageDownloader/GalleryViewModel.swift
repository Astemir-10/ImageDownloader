//
//  GalleryViewModel.swift
//  ImageDownloader
//
//  Created by Astemir Shibzuhov on 03.08.2020.
//  Copyright © 2020 Astemir Shibzuhov. All rights reserved.
//

import RxSwift

class GalleryViewModel {
  var fetchedPhotos: PublishSubject<[PhotoModelCoreData]>!
  fileprivate var photos: [PhotoModelCoreData] = []
  func fetchPhotos() {
    CoreDataManager.shared.fetchPhoto { (photosCoreData) in
      self.photos = photosCoreData
      self.fetchedPhotos.onNext(self.photos)
      self.photos = photosCoreData
      print("photos in core data = \(photosCoreData.count)")
    }
  }
  func deletePhoto(at index: Int) {
    CoreDataManager.shared.deletePhoto(photos[index])
    photos.remove(at: index)
    fetchPhotos()
    self.fetchedPhotos.onNext(self.photos)
  }
  
  func openPhoto(at index: Int) -> PhotoPresenterViewModel {
    let viewModel = PhotoPresenterViewModel(selectedIndex: index, images: photos)
    return viewModel
  }
  
  func removeAllPhotos() {
    CoreDataManager.shared.remove(photos) {
      self.fetchPhotos()
    }
  }

  init() {
    fetchedPhotos = PublishSubject<[PhotoModelCoreData]>()
  }
}
