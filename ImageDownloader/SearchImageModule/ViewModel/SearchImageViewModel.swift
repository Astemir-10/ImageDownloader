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
    networkaManager.getImages(word: keyWord) { [unowned self] (pexels, error) in
      if let error = error {
        print(error)
        return
      }
      guard let photos = pexels?.photos else {return}
      self.images.onNext(photos)
      self.page = photos.count
    }
  }
  
  func requestPages(for keyWord: String?) {
    guard let keyWord = keyWord else {return}
    
    print(flag)
    if !flag {
      flag = true
      networkaManager.getImages(word: keyWord, page: page + 1) { (photos, error) in
        if let error = error {
          print(error)
          return
        }
        guard let photos = photos?.photos else {return}
        self.imgReq.append(contentsOf: photos)
        self.images.onNext(self.imgReq)
        self.page += 1
        self.flag = false
      }
    }
  }
  
  func openPhoto(on indexPath: IndexPath) -> PhotoPresenterViewModel {
    let viewModel = PhotoPresenterViewModel(selectedIndex: indexPath, images: imgReq)
    return viewModel
  }
  
  init() {
    images = PublishSubject<[PexelsImage.Photo]>()
    networkaManager = NetworkManager()
  }
}
