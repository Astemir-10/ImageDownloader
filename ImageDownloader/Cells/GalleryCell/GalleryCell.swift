//
//  GalleryCell.swift
//  ImageDownloader
//
//  Created by Astemir Shibzuhov on 03.08.2020.
//  Copyright © 2020 Astemir Shibzuhov. All rights reserved.
//

import UIKit

protocol GalleryPhotosDelegate: class {
  func deletePhoto(at index: Int)
  func setEditingCell()
}

class GalleryCell: UICollectionViewCell {
  weak var delegate: GalleryPhotosDelegate?
  @IBOutlet weak var imageGallery: UIImageView!
  @IBOutlet weak var deleteButton: UIButton!
  fileprivate var index: Int?
  fileprivate var editingFlag = false
  static let identifire = String(describing: self)
  override func awakeFromNib() {
    super.awakeFromNib()
    layer.cornerRadius = 10
    imageGallery.layer.cornerRadius = 10

    
    imageGallery.clipsToBounds = true
    clipsToBounds = true
    addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(editingCell(_ :))))
    // Initialization code
  }
  override func draw(_ rect: CGRect) {
    super.draw(rect)
  }
  
  func setup(model: PhotoModelCoreData) {
    guard let photoData = model.photo else {return}
    guard let image = UIImage(data: photoData) else {
      return
    }
    imageGallery.image = image
  }
  
  func setDelegate(delegate: GalleryPhotosDelegate, index: Int) {
    self.delegate = delegate
    self.index = index
  }
  
  func setEditing(editing: Bool) {
    if editing {
      deleteButton.isHidden = false
    } else {
      deleteButton.isHidden = true
    }
  }
  
  @IBAction func deleteAction(_ sender: Any) {
    guard let delegate = delegate, let index = index else {
      return
    }
    delegate.deletePhoto(at: index)
  }
  
  @objc fileprivate func editingCell(_ gesture: UILongPressGestureRecognizer) {
    switch gesture.state {
    case .began:
      guard let delegate = delegate else {return}
      editingFlag = true
      delegate.setEditingCell()
    default: break
    }
  }
  
}
