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
  
  @IBOutlet var searchBar: UIView!
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
        
        let presentationVC = PhotoPresenterViewController()
        presentationVC.viewModel = viewModelForPresentation
        presentationVC.modalPresentationStyle = .fullScreen
        strongSelf.present(presentationVC, animated: true)
      }
    }.disposed(by: disposeBag)
    collectionView.rx.didEndDragging.bind { (_) in
      if self.collectionView.contentOffset.y > UIScreen.main.bounds.height + 40 {
        print("OK")
      }
    }.disposed(by: disposeBag)
  }
  @IBAction func openGalleryAction(_ sender: Any) {
    
  }
}
