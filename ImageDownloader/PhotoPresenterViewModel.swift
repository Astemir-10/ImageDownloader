//
//  PhotoPresenterViewModel.swift
//  ImageDownloader
//
//  Created by Astemir Shibzuhov on 27.07.2020.
//  Copyright © 2020 Astemir Shibzuhov. All rights reserved.
//

import Foundation
import RxSwift

protocol PhotoPresenterModel {
  var url: String {get}
}

class PhotoPresenterViewModel {
  var presentationImages: PublishSubject<[PhotoPresenterModel]>!
  var images: [PhotoPresenterModel]!
  var selectedIndex: IndexPath?
  fileprivate var networkManager: NetworkManager!
  fileprivate var imagesOfDB: [PhotoModelCoreData]?
  
  func saveImage(at index: Int) {
    let imageLink = images[index].url
    downloadImage1(at: index) { (data) in
      CoreDataManager.shared.savePhoto(photo: PhotoModelCoreData(url: imageLink, photoData: data))
    }
  }
  
  func removePhoto(at index: Int) {
    removePhotoModel(at: index)
    presentationImages.onNext(images)
  }
  
  func indexOfNextOrPreviewImage(at index: Int) -> Int? {
    if images.count - 1 == index {
      if images.count == 1 {
        return nil
      }
      return images.count - 2
    }
    return index + 1
  }
  
  fileprivate func removePhotoModel(at index: Int) {
    images.remove(at: index)
    if imagesOfDB != nil {
      CoreDataManager.shared.deletePhoto(imagesOfDB![index])
      imagesOfDB!.remove(at: index)
    }
  }
  
  func downloadImage1(at index: Int, completion: @escaping (Data) -> Void) {
    networkManager.downloadImage(for: images[index].url) { (data, error) in
      if let error = error {
        print(error)
        return
      }
      guard let data = data else {return}
      completion(data)
    }
  }
  
  init(selectedIndex: IndexPath, images: [PhotoPresenterModel]) {
    self.selectedIndex = selectedIndex
    self.images = images
    self.presentationImages = PublishSubject<[PhotoPresenterModel]>()
    networkManager = NetworkManager()
  }
  
  init(selectedIndex: Int, images: [PhotoModelCoreData]) {
    self.selectedIndex = IndexPath(row: selectedIndex, section: 0)
    self.imagesOfDB = images
    self.images = imagesOfDB!.map {PresenterPhotoModel(url: $0.url)}
    self.presentationImages = PublishSubject<[PhotoPresenterModel]>()
    networkManager = NetworkManager()
  }
}
