//
//  SearchImageCell.swift
//  ImageDownloader
//
//  Created by Astemir Shibzuhov on 21.07.2020.
//  Copyright © 2020 Astemir Shibzuhov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol SearchViewCellDlegate: class {
  func downloadPhoto(indexPath: Int)
}

class SearchImageCell: UICollectionViewCell {
  
  static let identifier = String(describing: self)
  weak var delegate: SearchViewCellDlegate?
  fileprivate var indexCell: Int?
  @IBOutlet weak var deleteButton: UIButton!
  @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var cellImage: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.clipsToBounds = true
    self.layer.cornerRadius = 10
    cellImage.layer.cornerRadius = 10
    self.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(downloadImage(_ :))))
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
  
  func setDelegate(indexPath: Int, delegate: SearchViewCellDlegate) {
    self.delegate = delegate
    self.indexCell = indexPath
  }
    
  @objc fileprivate func downloadImage(_ gesture: UILongPressGestureRecognizer) {
    switch gesture.state {
    case .began:
      guard let delegate = delegate, let indexCell = indexCell else {return}
      delegate.downloadPhoto(indexPath: indexCell)
    default: break
    }
    
  }
}
