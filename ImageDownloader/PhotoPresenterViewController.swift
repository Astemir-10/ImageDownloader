//
//  PhotoPresenterViewController.swift
//  ImageDownloader
//
//  Created by Astemir Shibzuhov on 27.07.2020.
//  Copyright © 2020 Astemir Shibzuhov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PhotoPresenterViewController: UIViewController {
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var currentImage: UIImageView!
  var viewModel: PhotoPresenterViewModel!
  var photos = [PexelsImage.Photo]()
  var selectedIndex: Int?
  var image: UIImage!
  let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupCollectionView()
    
    view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(dismissOnSwipeDown(_ :))))
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    viewModel.presentationImages.bind(to: collectionView.rx.items(cellIdentifier: PhotoPresenterCell.identifier, cellType: PhotoPresenterCell.self)) {_, model, cell in
      cell.photoForPresenter.load(from: model.src.large2x)
      print("OK")
    }.disposed(by: disposeBag)
    viewModel.presentationImages.onNext(viewModel.images)
    
  }
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    collectionView.scrollToItem(at: viewModel.selectedIndex!, at: .centeredHorizontally, animated: false)
  }
  
  // MARK: Collection View Setup
  fileprivate func setupCollectionView() {
    let phototPresenterCellNib = UINib(nibName: String(describing: PhotoPresenterCell.self), bundle: nil)
    collectionView.register(phototPresenterCellNib.self, forCellWithReuseIdentifier: PhotoPresenterCell.identifier)
    let presenterPhotoLayout = PhototPresenterLayout()
    presenterPhotoLayout.sectionInset = .zero
    let itemSize = CGSize(width: view.frame.size.width, height: view.frame.size.height - 80)
    presenterPhotoLayout.itemSize = itemSize
    presenterPhotoLayout.scrollDirection = .horizontal
    collectionView.collectionViewLayout = presenterPhotoLayout
  }
  
  @objc private func dismissOnSwipeDown(_ gesture: UIPanGestureRecognizer) {
    if gesture.state == .changed {
      let translationGesture = gesture.translation(in: view)
      let velocityTransformGesture = gesture.velocity(in: view)
      
      if translationGesture.y > 0 && velocityTransformGesture.y > 800 {
        dismiss(animated: true, completion: nil)
      }
    }
  }
  
}
