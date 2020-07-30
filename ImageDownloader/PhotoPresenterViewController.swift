//
//  PhotoPresenterViewController.swift
//  ImageDownloader
//
//  Created by Astemir Shibzuhov on 27.07.2020.
//  Copyright © 2020 Astemir Shibzuhov. All rights reserved.
//

import UIKit

class PhotoPresenterViewController: UIViewController {
  @IBOutlet weak var collectionView: UICollectionView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupCollectionView()
    view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(dismissOnSwipeDown(_ :))))
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
  
  // MARK: Collection View Setup
  
  fileprivate func setupCollectionView() {
    collectionView.delegate = self
    collectionView.dataSource = self
    let nibName = String(describing: PhotoPresenterCell.self)
    let phototPresenterCellNib = UINib(nibName: nibName, bundle: nil)
    collectionView.register(phototPresenterCellNib, forCellWithReuseIdentifier: PhotoPresenterCell.identifier)
  }
  
}

// MARK: Collection View Delegate, Data Source

extension PhotoPresenterViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 10
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoPresenterCell.identifier,
                                                        for: indexPath) as? PhotoPresenterCell else {return UICollectionViewCell()}
    cell.photoForPresenter.image = #imageLiteral(resourceName: "Photo 2")
    
    return cell
  }
}

extension PhotoPresenterViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let screenSize = collectionView.bounds.size
    return screenSize
  }
}
