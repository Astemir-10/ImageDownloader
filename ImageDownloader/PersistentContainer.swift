//
//  PersistentContainer.swift
//  ImageDownloader
//
//  Created by Astemir Shibzuhov on 03.08.2020.
//  Copyright © 2020 Astemir Shibzuhov. All rights reserved.
//

import CoreData

class PersistentCoreData {
  static let shared = PersistentCoreData()
  lazy var persistntContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "ImageDownloader")
    
    container.loadPersistentStores { (_, error) in
      if let error = error as NSError? {
        fatalError("Error PersistentContainer userInfo \(error.userInfo)")
      }
    }
    return container
  }()
  
  func saveContext() {
    let context = persistntContainer.viewContext
    if context.hasChanges {
      do {
        try context.save()
      } catch let error as NSError {
        fatalError("Error at saving context \(error.userInfo)")
      }
    }
  }
}
