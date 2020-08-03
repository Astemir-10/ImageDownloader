//
//  PhotoPresenterCell.swift
//  ImageDownloader
//
//  Created by Astemir Shibzuhov on 27.07.2020.
//  Copyright © 2020 Astemir Shibzuhov. All rights reserved.
//

import UIKit

class PhotoPresenterCell: UICollectionViewCell {

  @IBOutlet weak var photoForPresenter: UIImageView!
  @IBOutlet weak var scrollView: UIScrollView!
  
  static var identifier = "PhotoPresenterCell"
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    zoomingImage()
  }
  
  fileprivate func zoomingImage() {
    let pinch = UIPinchGestureRecognizer()
    pinch.addTarget(self, action: #selector(zooming(_ :)))
    self.addGestureRecognizer(pinch)
  }
  
  @objc fileprivate func zooming(_ gesture: UIPinchGestureRecognizer) {
    print("OK")
    self.scrollView.setZoomScale(gesture.scale, animated: true)
//    print(self.bounds.size)
  }

}
