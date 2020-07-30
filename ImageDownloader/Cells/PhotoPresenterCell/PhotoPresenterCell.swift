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
  
  static var identifier = "PhotoPresenterCell"
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
