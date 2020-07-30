//
//  GalleryViewController.swift
//  ImageDownloader
//
//  Created by Astemir Shibzuhov on 25.07.2020.
//  Copyright © 2020 Astemir Shibzuhov. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class GalleryViewController: UIViewController {
  
  @IBOutlet weak var collectionView: UICollectionView!
  var models: [String] = []
  fileprivate let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViewController()
    setupCollectionView()
  }
  
  // Setup CollectionView
  fileprivate func setupCollectionView() {
    let nibName = String(describing: ImageCollectionViewCell.self)
    let cellNib = UINib(nibName: nibName, bundle: nil)
    collectionView.register(cellNib.self, forCellWithReuseIdentifier: "Cell")
    
    let observable = Observable<[String]>.just(models)
    observable.bind(to: collectionView.rx.items(cellIdentifier: "Cell", cellType: ImageCollectionViewCell.self)) { _, photo, cell in
      cell.cellImage.load(from: photo)
    }.disposed(by: disposeBag)
    
  }
  
  // Setup ViewController
  fileprivate func setupViewController() {
    let gradient = CAGradientLayer()
    gradient.frame = view.bounds
    gradient.colors = [#colorLiteral(red: 0.9725490196, green: 0.8862745098, blue: 0.8862745098, alpha: 1).cgColor, #colorLiteral(red: 0.968627451, green: 0.8117647059, blue: 0.8117647059, alpha: 1).cgColor]
    gradient.startPoint = CGPoint(x: 0, y: 0)
    gradient.endPoint = CGPoint(x: 1, y: 1)
    view.layer.insertSublayer(gradient, at: 0)
  }
  
  @IBAction func closeAction(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
}
