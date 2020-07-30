//
//  ExtensionView.swift
//  ImageDownloader
//
//  Created by Astemir Shibzuhov on 25.07.2020.
//  Copyright © 2020 Astemir Shibzuhov. All rights reserved.
//

import UIKit

extension UIViewController {
  func loadFromStoryboard<T> () -> T {
    let storyboardName = String(describing: T.self)
    let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
    if let viewController = storyboard.instantiateInitialViewController() as? T {
      return viewController
    } else {
      fatalError("Doesn't exist storyboard with name \(storyboardName)")
    }
  }
}

extension UIImageView {
  func load(from urlString: String) {
    guard let url = URL(string: urlString) else {return}
    let request = URLRequest(url: url)
    if let imageData = URLCache.shared.cachedResponse(for: request)?.data {
      self.image = UIImage(data: imageData)
      return
    }
    
    NetworkService.loadData(url: url) { [unowned self] (data) in
      guard let image = UIImage(data: data) else {return}
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

@IBDesignable
extension UIView {
  @IBInspectable var cornerRadius: CGFloat {
    get {
      return self.layer.cornerRadius
    }
    set {
      self.clipsToBounds = true
      layer.cornerRadius = newValue
    }
  }
  
  @IBInspectable var roundCorners: Bool {
    get {
      return self.roundCorners
    }
    set {
      if newValue {
        self.layer.cornerRadius = self.frame.height / 2
      } else {
        self.layer.cornerRadius = cornerRadius
      }
    }
  }
  
}
