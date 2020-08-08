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
  
  @IBOutlet weak var doneButton: UIButton!
  @IBOutlet weak var removeAllButton: UIButton!
  @IBOutlet weak var closeButton: UIButton!
  @IBOutlet weak var collectionView: UICollectionView!
  var viewModel: GalleryViewModel!
  fileprivate let disposeBag = DisposeBag()
  fileprivate var collectionViewCellsIsEditing = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel = GalleryViewModel()
    setupViewController()
    setupCollectionView()
    viewModel.fetchPhotos()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    viewModel.fetchedPhotos.bind(to: collectionView.rx.items(cellIdentifier: GalleryCell.identifire, cellType: GalleryCell.self)) {item, model, cell in
      cell.setup(model: model)
      cell.setDelegate(delegate: self, index: item)
      cell.setEditing(editing: self.collectionViewCellsIsEditing)
    }.disposed(by: disposeBag)
    viewModel.fetchPhotos()

  }
  
  // Setup CollectionView
  fileprivate func setupCollectionView() {
    let nibName = String(describing: GalleryCell.self)
    let cellNib = UINib(nibName: nibName, bundle: Bundle(for: GalleryCell.self))
    collectionView.register(cellNib.self, forCellWithReuseIdentifier: GalleryCell.identifire)

    collectionView.rx.itemSelected.bind { (indexPath) in
      let photoPresenter = PhotoPresenterViewController()
      photoPresenter.isSearchVCPresented = true
      photoPresenter.modalPresentationStyle = .fullScreen
      let viewModel = self.viewModel.openPhoto(at: indexPath.row)
      photoPresenter.viewModel = viewModel
      self.present(photoPresenter, animated: true, completion: nil)
    }.disposed(by: disposeBag)
    
  }
  
  // Setup ViewController
  fileprivate func setupViewController() {
    let gradient = CAGradientLayer()
    gradient.frame = view.bounds
    gradient.colors = [#colorLiteral(red: 0.9764705882, green: 0.8, blue: 0.8, alpha: 1).cgColor, #colorLiteral(red: 0.9529411765, green: 0.7607843137, blue: 0.7607843137, alpha: 1).cgColor]
    gradient.startPoint = CGPoint(x: 0, y: 0)
    gradient.endPoint = CGPoint(x: 1, y: 1)
    view.layer.insertSublayer(gradient, at: 0)
  }
  
  @IBAction func closeAction(_ sender: Any) {
    dismiss(animated: true, completion: nil)
    
  }
  @IBAction func doneButtonAction(_ sender: Any) {
    doneButton.isHidden.toggle()
    removeAllButton.isHidden.toggle()
    closeButton.isHidden.toggle()
    collectionViewCellsIsEditing.toggle()
    collectionView.reloadData()
  }
  @IBAction func removeAllAction(_ sender: Any) {
    viewModel.removeAllPhotos()
    doneButtonAction(doneButton as Any)
  }
}

extension GalleryViewController: GalleryPhotosDelegate {
  func setEditingCell() {
    collectionViewCellsIsEditing = true
    doneButton.isHidden.toggle()
    removeAllButton.isHidden.toggle()
    closeButton.isHidden.toggle()
    collectionView.reloadData()
  }
  
  func deletePhoto(at index: Int) {
    viewModel.deletePhoto(at: index)
    collectionView.reloadData()
  }
}
