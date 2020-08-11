//
//  ExtensionView.swift
//  ImageDownloader
//
//  Created by Astemir Shibzuhov on 25.07.2020.
//  Copyright © 2020 Astemir Shibzuhov. All rights reserved.
//

import UIKit

extension UIViewController {
  class func loadFromStoryboard<T: UIViewController> () -> T {
    let storyboardName = String(describing: T.self)
    let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle(identifier: storyboardName))
    if let viewController = storyboard.instantiateInitialViewController() as? T {
      return viewController
    } else {
      fatalError("Doesn't exist storyboard with name \(storyboardName)")
    }
  }
  
  class func loadFromStoryboard<T: UIViewController> (storyboardName: String, withId: String) -> T {
    let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle(identifier: storyboardName))
    if let viewController = storyboard.instantiateViewController(identifier: withId) as? T {
      return viewController
    } else {
      fatalError("Doesn't exist storyboard with name \(storyboardName)")
    }
  }
}

extension UIImageView {
  func load(from urlString: String) {
    let networkManager = NetworkManager()
    guard let url = URL(string: urlString) else {return}
    let request = URLRequest(url: url)
    if let imageData = URLCache.shared.cachedResponse(for: request)?.data {
      self.image = UIImage(data: imageData)
      return
    }
    
    networkManager.downloadImage(for: urlString) { (data, error) in
      if let error = error {
        print(error)
        return
      }
      guard let data = data, let image = UIImage(data: data) else {return}
      DispatchQueue.main.async {
        self.image = image
      }
      self.saveToCach(from: request)
    }
  }
  
  private func saveToCach(from request: URLRequest) {
    guard let cachedResponse = URLCache.shared.cachedResponse(for: request) else {return}
    URLCache.shared.storeCachedResponse(cachedResponse, for: request)
  }
}
