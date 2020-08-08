//
//  SearchImageViewModel.swift
//  ImageDownloader
//
//  Created by Astemir Shibzuhov on 26.07.2020.
//  Copyright © 2020 Astemir Shibzuhov. All rights reserved.
//

import Foundation
import RxSwift

final class SearchImageViewModel {
  var images: PublishSubject<[PexelsImage.Photo]>!
  var imgReq = [PexelsImage.Photo]()
  let disposeBag = DisposeBag()
  private var page = 1
  private var flag = false
  
  fileprivate var networkaManager: NetworkManager!
  
  func requestPexelImages() {
    networkaManager.getImages { [unowned self] (pexels, error) in
      if let error = error {
        print(error)
        return
      }
      guard let photos = pexels?.photos else {return}
      self.imgReq.append(contentsOf: photos)
      self.images.onNext(photos)
    }
  }
  
  func request(for keyWord: String?) {
    guard let keyWord = keyWord else {return}
    page = 1
    networkaManager.getImages(word: keyWord, page: page) { [unowned self] (pexels, error) in
      if let error = error {
        print(error)
        return
      }
      guard let photos = pexels?.photos else {return}
      self.imgReq = photos
      self.images.onNext(photos)
    }
  }
  
  func requestNextPage(for keyWord: String?) {
    var keyWord = keyWord
    if keyWord == nil {
      keyWord = "popular"
    }
    networkaManager.getImages(word: keyWord!, page: page + 1) { (photos, error) in
      
      if let error = error {
        print(error)
        return
      }
      guard let photos = photos?.photos, !photos.isEmpty else {return}
      self.imgReq.append(contentsOf: photos)
      self.images.onNext(self.imgReq)
      self.page += 1
    }
  }
  
  func openPhoto(on indexPath: IndexPath) -> PhotoPresenterViewModel {
    
    let images = imgReq.map {PresenterPhotoModel(url: $0.src.large2x)}
    let viewModel = PhotoPresenterViewModel(selectedIndex: indexPath, images: images)
    return viewModel
  }
  
  func savePhoto(at index: Int) {
    let selectedPexelPhotoModel = imgReq[index]
    networkaManager.downloadImage(for: selectedPexelPhotoModel.src.large2x) { (data, error) in
      if let error = error {
        print(error)
        return
      }
      let photoModelCoreData = PhotoModelCoreData(url: selectedPexelPhotoModel.src.large2x, photoData: data)
      CoreDataManager.shared.savePhoto(photo: photoModelCoreData)
    }
  }
  
  init() {
    images = PublishSubject<[PexelsImage.Photo]>()
    networkaManager = NetworkManager()
  }
}
