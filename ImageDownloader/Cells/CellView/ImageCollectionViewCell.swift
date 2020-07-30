//
//  ImageCollectionViewCell.swift
//  ImageDownloader
//
//  Created by Astemir Shibzuhov on 21.07.2020.
//  Copyright © 2020 Astemir Shibzuhov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ImageCollectionViewCell: UICollectionViewCell {
  
  static let identifier = String(describing: self)
  @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
  
  @IBOutlet weak var cellImage: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.clipsToBounds = true
    self.layer.cornerRadius = 10
    cellImage.layer.cornerRadius = 10
    self.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(downloadImage(_ :))))
    self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditingView)))
  }
  
  override func prepareForReuse() {
    cellImage.image = nil
    loadingActivityIndicator.startAnimating()
    super.prepareForReuse()
  }
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    loadingActivityIndicator.startAnimating()
  }
  
  func setup(photo: PexelsImage.Photo) {
    cellImage.load(from: photo.src.medium)
  }
  
  @objc fileprivate func downloadImage(_ gesture: UILongPressGestureRecognizer) {
    
  }
  
  @objc fileprivate func endEditingView() {
    superview?.superview?.endEditing(true)
  }
}
