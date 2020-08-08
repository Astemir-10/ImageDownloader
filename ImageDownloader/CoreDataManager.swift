//
//  CoreDataManager.swift
//  ImageDownloader
//
//  Created by Astemir Shibzuhov on 26.07.2020.
//  Copyright © 2020 Astemir Shibzuhov. All rights reserved.
//

import CoreData

class CoreDataManager {
  static let shared = CoreDataManager()
  fileprivate let coreDataQueue = DispatchQueue.global(qos: .background)
  fileprivate let context = PersistentCoreData.shared.persistntContainer.viewContext
  
  func savePhoto(photo: PhotoModelCoreData) {
    coreDataQueue.async { [weak self] in
      guard let strongSelf = self else {return}
      strongSelf.fetchPhoto { (fetch) in
        var flag = false
        for currentPhoto in fetch where currentPhoto.url == photo.url {
            flag = true
            break
        }
        if !flag {
          let photoModel = PhotoModel(context: strongSelf.context)
          photoModel.photoLarge = photo.photo
          photoModel.url = photo.url
          do {
            try strongSelf.context.save()
          } catch let error as NSError {
            fatalError("Error at saving photo model \(error.userInfo)")
          }
        }
      }
    }
  }
  
  func fetchPhoto(completion: @escaping ([PhotoModelCoreData]) -> Void) {
    coreDataQueue.async {
      let fetch: NSFetchRequest<PhotoModel> = PhotoModel.fetchRequest()
      do {
        let result = try self.context.fetch(fetch)
        let photoModelResult = result.map {PhotoModelCoreData(url: $0.url, photoData: $0.photoLarge)}
        completion(photoModelResult)
      } catch let error as NSError {
        fatalError("No fetched \(error.userInfo)")
      }
    }
  }
  
  func savePhotos(photos: [PhotoModelCoreData]) {
    photos.forEach {savePhoto(photo: $0)}
  }
  
  func deletePhoto(_ photo: PhotoModelCoreData) {
    let fetch: NSFetchRequest<PhotoModel> = PhotoModel.fetchRequest()
    fetch.predicate = NSPredicate(format: "url = '\(photo.url)'")
    do {
      let result = try self.context.fetch(fetch)
      if result.isEmpty {fatalError("No model with url")}
      let deletingPhoto = result[0]
      self.context.delete(deletingPhoto)
      try self.context.save()
    } catch {
      print(error)
    }
  }
  
  func remove(_ photos: [PhotoModelCoreData], completion: @escaping () -> Void) {
    coreDataQueue.async {
      for photo in photos {
        self.deletePhoto(photo)
      }
      completion()
    }
  }
}
