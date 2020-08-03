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
//  @IBOutlet weak var collectionView: UICollectionView!
//  @IBOutlet weak var currentImage: UIImageView!
  lazy var collectionView: UICollectionView = {
    let presenterPhotoLayout = PhotoPresenterLayout()
    presenterPhotoLayout.sectionInset = .zero
    let itemSize = CGSize(width: view.frame.size.width, height: view.frame.size.height - 80)
    presenterPhotoLayout.itemSize = itemSize
    presenterPhotoLayout.scrollDirection = .horizontal
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: presenterPhotoLayout)
    let phototPresenterCellNib = UINib(nibName: String(describing: PhotoPresenterCell.self), bundle: nil)
    collectionView.register(phototPresenterCellNib.self, forCellWithReuseIdentifier: PhotoPresenterCell.identifier)
    return collectionView
  }()
  
  var viewModel: PhotoPresenterViewModel!
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
    collectionView.scrollToItem(at: viewModel.selectedIndex!, at: .centeredHorizontally, animated: false)
    
  }
  
  // MARK: Collection View Setup
  fileprivate func setupCollectionView() {
    collectionView.frame = self.view.bounds
    view.addSubview(collectionView)
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
