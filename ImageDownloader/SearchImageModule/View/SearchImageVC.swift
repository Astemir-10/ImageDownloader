//
//  SearchImageVC.swift
//  ImageDownloader
//
//  Created by Astemir Shibzuhov on 02.08.2020.
//  Copyright © 2020 Astemir Shibzuhov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchImageVC: UIViewController {
  
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var searchWordTextField: UITextField!
  private var viewModel: SearchImageViewModel!
  private let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel = SearchImageViewModel()
    setup()
    viewModel.requestPexelImages()
  }
  
  fileprivate func setup() {
    let nibName = String(describing: SearchImageCell.self)
    let nibFile = UINib(nibName: nibName, bundle: nil)
    collectionView.register(nibFile, forCellWithReuseIdentifier: SearchImageCell.identifier)
    collectionView.collectionViewLayout = SearchImageCollectionViewLayout()
    viewModel.images.bind(to: collectionView.rx.items(cellIdentifier: SearchImageCell.identifier, cellType: SearchImageCell.self)) {_, model, cell in
      cell.setup(photo: model)
    }.disposed(by: disposeBag)
    
    collectionView.rx.itemSelected.subscribeOn(MainScheduler.instance).bind {[weak self] (indexPath) in
      guard let strongSelf = self else {return}
      if strongSelf.searchWordTextField.isEditing {
        strongSelf.view.endEditing(true)
      } else {
        let viewModelForPresentation = strongSelf.viewModel.openPhoto(on: indexPath)
        let nibName = String(describing: PhotoPresenterViewController.self)
        guard let presentationVC = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)?.first as? PhotoPresenterViewController else {return}
        print("loadNibNamed")
        presentationVC.viewModel = viewModelForPresentation
        print( presentationVC.viewModel)
        presentationVC.modalPresentationStyle = .fullScreen
        strongSelf.present(presentationVC, animated: true)
      }
    }.disposed(by: disposeBag)
    
  }
  @IBAction func openGalleryAction(_ sender: Any) {
    
  }
  
}

//extension SearchImageVC: UICollectionViewDelegate, UICollectionViewDataSource {
//  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//    return 10
//  }
//
//  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchImageCell.identifier, for: indexPath) as? SearchImageCell else {fatalError()}
//    cell.cellImage.image = #imageLiteral(resourceName: "Photo 16")
//    cell.backgroundColor = .black
//    return cell
//  }
//
//  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//    if searchWordTextField.isEditing {
//      view.endEditing(true)
//      return
//    }
//      let nibName = String(describing: PhotoPresenterViewController.self)
//      guard let photoPresenter = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)?.first as? PhotoPresenterViewController else {return}
//      photoPresenter.modalPresentationStyle = .fullScreen
//
//      present(photoPresenter, animated: true)
//
//  }
//}
