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
  
  @IBOutlet weak var loadingImageActivityIndicator: UIActivityIndicatorView!
  @IBOutlet var searchBar: UIView!
  @IBOutlet weak var collectionView: UICollectionView!
  private var searchController: UISearchController!
  private var searchTextField: UITextField {
    return searchController.searchBar.searchTextField
  }
  private var viewModel: SearchImageViewModel!
  private let disposeBag = DisposeBag()
  private var searchWord: String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    viewModel = SearchImageViewModel()
    setup()
    
    viewModel.requestPexelImages()
    
  }
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    searchTextField.layer.cornerRadius = searchTextField.frame.size.height / 2
    searchTextField.clipsToBounds = true
  }
  
  fileprivate func setup() {
    setupView()
    let nibName = String(describing: SearchImageCell.self)
    let nibFile = UINib(nibName: nibName, bundle: Bundle(for: SearchImageCell.self))
    collectionView.register(nibFile, forCellWithReuseIdentifier: SearchImageCell.identifier)
    collectionView.collectionViewLayout = SearchImageCollectionViewLayout()
    viewModel.images.bind(to: collectionView.rx.items(cellIdentifier: SearchImageCell.identifier, cellType: SearchImageCell.self)) {item, model, cell in
      self.stopActivityIndicator()
      cell.setup(photo: model)
      cell.setDelegate(indexPath: item, delegate: self)
    }.disposed(by: disposeBag)
    
    collectionView.rx.itemSelected.subscribeOn(MainScheduler.instance).bind {[weak self] (indexPath) in
      guard let strongSelf = self else {return}
      if strongSelf.searchController.searchBar.searchTextField.isEditing {
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
      if self.collectionView.contentOffset.y + UIScreen.main.bounds.height > self.collectionView.contentSize.height + 220 {
        self.startActivityIndicator()
        self.viewModel.requestNextPage(for: self.searchTextField.text)
      }
    }.disposed(by: disposeBag)
    
    collectionView.rx.didScroll.bind { (_) in
      if self.collectionView.contentOffset.y + UIScreen.main.bounds.height > self.collectionView.contentSize.height + 220 {
        self.startActivityIndicator()
      }
    }.disposed(by: disposeBag)
    
  }
  
  fileprivate func setupView() {
    let openGalleryIcon = UIImage(named: "openGallery")
    let saves = UIBarButtonItem(image: openGalleryIcon, style: .plain, target: self, action: #selector(openGallery))
    let removeCacheBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "clearCache"), style: .plain, target: self, action: #selector(removeCache))
    
    navigationItem.rightBarButtonItem = saves
    navigationItem.leftBarButtonItem = removeCacheBarButton
    searchController = UISearchController(searchResultsController: nil)
    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = true
    navigationItem.largeTitleDisplayMode = .automatic
    navigationController?.navigationBar.prefersLargeTitles = false
    searchController.searchBar.delegate = self
    
    let gradioentLayer = CAGradientLayer()
    gradioentLayer.frame = view.bounds
    gradioentLayer.startPoint = CGPoint(x: 0, y: 0)
    gradioentLayer.endPoint = CGPoint(x: 1, y: 1)
    gradioentLayer.colors = [#colorLiteral(red: 0.968627451, green: 0.8117647059, blue: 0.8117647059, alpha: 1).cgColor, #colorLiteral(red: 0.9568627451, green: 0.6666666667, blue: 0.6666666667, alpha: 1).cgColor]
    view.layer.insertSublayer(gradioentLayer, at: 0)
  }
  
  @objc private func openGallery() {
    let gallery: GalleryViewController = GalleryViewController.loadFromStoryboard()
    gallery.modalPresentationStyle = .fullScreen
    present(gallery, animated: true)
  }
  
  @objc func removeCache() {
    let cache = URLCache.shared.currentMemoryUsage / 1024
    
    let alert = UIAlertController(title: "Очистить кэш?", message: "Размер кэша: \(cache) Kb", preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
      URLCache.shared.removeAllCachedResponses()
    }
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    alert.addAction(cancelAction)
    alert.addAction(okAction)
    present(alert, animated: true, completion: nil)
  }
  
  fileprivate func startActivityIndicator() {
    loadingImageActivityIndicator.isHidden = false
    loadingImageActivityIndicator.startAnimating()
  }
  
  fileprivate func stopActivityIndicator() {
    loadingImageActivityIndicator.isHidden = true
    loadingImageActivityIndicator.startAnimating()
  }
}

extension SearchImageVC: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchWord != nil {
      searchWord = searchText == searchWord ? searchWord: searchText
    } else {
      searchWord = searchText
    }
  }
  
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    guard let searchWord = searchWord, searchWord != "" else {return}
    searchController.isActive = false
    searchTextField.text = searchWord
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    guard let searchWord = searchWord, searchWord != "" else {return}
    viewModel.request(for: searchWord)
    searchController.isActive = false
    searchTextField.text = searchWord
  }
}

extension SearchImageVC: SearchViewCellDlegate {
  func downloadPhoto(indexPath: Int) {
    viewModel.savePhoto(at: indexPath)
  }
}
