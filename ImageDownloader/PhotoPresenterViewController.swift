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
  
  var isSearchVCPresented = false

  lazy fileprivate var menuBar: MenuBar! = {
    let rect = CGRect(x: view.bounds.minX,
                      y: view.bounds.maxY - 64,
                      width: view.bounds.width,
                      height: 64)
    let menuBar = MenuBar(frame: rect)
    return menuBar
  }()
  lazy var collectionView: UICollectionView = {
    let presenterPhotoLayout = PhotoPresenterLayout()
    presenterPhotoLayout.sectionInset = .zero
    let itemSize = CGSize(width: view.frame.size.width, height: view.frame.size.height - 80)
    presenterPhotoLayout.itemSize = itemSize
    presenterPhotoLayout.scrollDirection = .horizontal
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: presenterPhotoLayout)
    let phototPresenterCellNib = UINib(nibName: String(describing: PhotoPresenterCell.self), bundle: Bundle(for: PhotoPresenterCell.self))
    collectionView.register(phototPresenterCellNib.self, forCellWithReuseIdentifier: PhotoPresenterCell.identifier)
    return collectionView
  }()
  
  var viewModel: PhotoPresenterViewModel!
  let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupCollectionView()
    self.view.backgroundColor = .black
    view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(dismissOnSwipeDown(_ :))))
    view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapAction)))
    
    if isSearchVCPresented {
      menuBar.mode = .hiddenRemoveAndShare
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    viewModel.presentationImages.bind(to: collectionView.rx.items(cellIdentifier: PhotoPresenterCell.identifier, cellType: PhotoPresenterCell.self)) {_, model, cell in
      cell.photoForPresenter.load(from: model.url)
    }.disposed(by: disposeBag)
    viewModel.presentationImages.onNext(viewModel.images)
    collectionView.scrollToItem(at: viewModel.selectedIndex!, at: .centeredHorizontally, animated: false)
  }
  
  // MARK: Collection View Setup
  fileprivate func setupCollectionView() {
    collectionView.frame = view.bounds
    view.addSubview(collectionView)
    view.insertSubview(menuBar, aboveSubview: collectionView)
    menuBar.delegate = self
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
  
  @objc private func viewTapAction() {
    menuBar.animatedHideShow()
  }
}

extension PhotoPresenterViewController: MenuBarActionsDelegate {
  func didDownloadButtnTapped() {
    let visbleItem = collectionView.indexPathsForVisibleItems
    viewModel.saveImage(at: visbleItem[0].row)
  }
  
  func didShareButtnTapped() {
    let visbleItem = collectionView.indexPathsForVisibleItems[0]
    guard let cellCurrent = collectionView.cellForItem(at: visbleItem) as? PhotoPresenterCell,
      let image = cellCurrent.photoForPresenter.image else {return}
    let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: [])
    present(activityVC, animated: true, completion: nil)
  }
  
  func didDeleteButtonTapped() {
    let visbleItem = collectionView.indexPathsForVisibleItems[0]
    if let nextIndex = viewModel.indexOfNextOrPreviewImage(at: visbleItem.item) {
      print(nextIndex)
      let nextIndexPath = IndexPath(row: nextIndex, section: visbleItem.section)
      collectionView.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: true)
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
        self.viewModel.removePhoto(at: visbleItem.item)
      }
    } else {
      self.viewModel.removePhoto(at: visbleItem.item)
      dismiss(animated: true, completion: nil)
    }
  }  
}
