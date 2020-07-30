//
//  SearchImageViewController.swift
//  ImageDownloader
//
//  Created by Astemir Shibzuhov on 18.07.2020.
//  Copyright © 2020 Astemir Shibzuhov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchImageViewController: UIViewController {
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var searchText: UITextField!
  
  fileprivate var searchImageViewModel: SearchImageViewModel!
  
  fileprivate let disposeBag = DisposeBag()
  
  override class func awakeFromNib() {
    super.awakeFromNib()
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))
    searchText.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.2352941176, green: 0.2352941176, blue: 0.262745098, alpha: 0.6)])
    searchText.delegate = self
    setupViewController()
    setupCollectionView()
  }
  
  @objc private func endEditing() {
    view.endEditing(true)
  }
  
  // Setup CollectionView
  fileprivate func setupCollectionView() {
    let nibName = String(describing: ImageCollectionViewCell.self)
    let cellNib = UINib(nibName: nibName, bundle: nil)
    collectionView.register(cellNib.self,
                            forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
    
    searchImageViewModel
      .images
      .observeOn(MainScheduler.instance)
      .bind(to: collectionView.rx.items(cellIdentifier: ImageCollectionViewCell.identifier, cellType: ImageCollectionViewCell.self)) { _, photo, cell in
      cell.setup(photo: photo)
    }.disposed(by: disposeBag)
    
    collectionView.rx.modelSelected(PexelsImage.Photo.self).subscribe {[unowned self] (_) in
      guard let presenter = Bundle.main.loadNibNamed(String(describing: PhotoPresenterViewController.self), owner: self, options: nil)?.first as? PhotoPresenterViewController else {return}
      presenter.modalPresentationStyle = .fullScreen
      self.present(presenter, animated: true)
    }.disposed(by: disposeBag)
  }
  
  // Setup ViewController
  fileprivate func setupViewController() {
    let gradient = CAGradientLayer()
    gradient.frame = view.bounds
    gradient.colors = [#colorLiteral(red: 0.9568627451, green: 0.7725490196, blue: 0.7725490196, alpha: 1).cgColor, #colorLiteral(red: 0.9568627451, green: 0.6666666667, blue: 0.6666666667, alpha: 1).cgColor]
    gradient.startPoint = CGPoint(x: 0, y: 0)
    gradient.endPoint = CGPoint(x: 1, y: 1)
    view.layer.insertSublayer(gradient, at: 0)
    searchImageViewModel = SearchImageViewModel()
    searchImageViewModel.requestPexelImages()
  }
  
  @IBAction func openGalleryAction(_ sender: Any) {
//    let galleryViewController: GalleryViewController = GalleryViewController().loadFromStoryboard()
//    galleryViewController.modalPresentationStyle = .fullScreen
    
    
    
    guard let presenter = Bundle.main.loadNibNamed(String(describing: PhotoPresenterViewController.self), owner: self, options: nil)?.first as? PhotoPresenterViewController else {return}
    presenter.modalPresentationStyle = .fullScreen
    self.present(presenter, animated: true)
    
//    self.present(galleryViewController, animated: true, completion: nil)
  }
}

extension SearchImageViewController: UITextFieldDelegate {
  func textFieldDidEndEditing(_ textField: UITextField) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
      self.searchImageViewModel.request(for: textField.text)
    }
  }
  
}
