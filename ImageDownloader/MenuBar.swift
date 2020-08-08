//
//  MenuBar.swift
//  ImageDownloader
//
//  Created by Astemir Shibzuhov on 05.08.2020.
//  Copyright © 2020 Astemir Shibzuhov. All rights reserved.
//

import UIKit

protocol MenuBarActionsDelegate: class {
  func didDownloadButtnTapped()
  func didShareButtnTapped()
  func didDeleteButtonTapped()
}

class MenuBar: UIView {
  enum MenuBarMode {
    case hiddenDownload
    case hiddenRemoveAndShare
  }
  fileprivate lazy var barView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.systemBackground
    return view
  }()
  
  fileprivate lazy var downloadButton: UIButton = {
    let btn = UIButton()
    btn.setImage(#imageLiteral(resourceName: "DownloadIconLarge"), for: .normal)
    btn.imageEdgeInsets = UIEdgeInsets(top: 12, left: 13, bottom: 12, right: 13)
    btn.backgroundColor = .white
    btn.layer.cornerRadius = 24
    btn.layer.shadowColor = UIColor.black.cgColor
    btn.layer.shadowRadius = 5
    btn.layer.shadowOffset = CGSize(width: 0, height: 2)
    btn.layer.shadowOpacity = 0.2
    return btn
  }()
  
  fileprivate var shareButton: UIButton = {
    let btn = UIButton()
    btn.setImage(#imageLiteral(resourceName: "ShareIconLarge"), for: .normal)
    btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
    return btn
  }()
  
  fileprivate var deleteButton: UIButton = {
    let btn = UIButton()
    btn.setImage(#imageLiteral(resourceName: "DeleteIconLarge"), for: .normal)
    btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
    return btn
  }()
  
  private var isShow = true
  
  var mode: MenuBarMode! = .hiddenDownload {
    didSet {
      toggleMode()
    }
  }
    
  weak var delegate: MenuBarActionsDelegate?
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    setupUIElements()
    toggleMode()
  }
 
  func animatedHideShow() {
    if isShow {
      hideMenuBar()
    } else {
      showMenuBar()
    }
    isShow.toggle()
  }
  
  private func hideMenuBar() {
    UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
      self.barView.transform = CGAffineTransform(translationX: 0, y: self.frame.size.height)
      self.alpha = 0
    }, completion: nil)
  }
  
  private func showMenuBar() {
    UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
      self.barView.transform = .identity
      self.alpha = 1
    }, completion: nil)
  }
  
  func toggleMode() {
    switch mode {
    case .hiddenDownload:
      downloadButton.isHidden = false
      deleteButton.isHidden = true
    case .hiddenRemoveAndShare:
      downloadButton.isHidden = true
      deleteButton.isHidden = false
    case .none:
      break
    }
  }
  // MARK: - ADD UI ELEMENTS
  fileprivate func setupUIElements() {
    let barViewSize = CGSize(width: bounds.width, height: bounds.height - 20)
    let barViewPoint = CGPoint(x: bounds.minX, y: bounds.maxY - barViewSize.height)
    barView.frame = CGRect(origin: barViewPoint, size: barViewSize)
    addSubview(barView)
    
    let downloadButtonSize = CGSize(width: 48, height: 48)
    let downloadButtonPoint = CGPoint(x: barView.bounds.width / 2 - downloadButtonSize.width / 2,
                                      y: barView.bounds.maxY - downloadButtonSize.height - 8)
    downloadButton.frame = CGRect(origin: downloadButtonPoint, size: downloadButtonSize)
    barView.addSubview(downloadButton)
    downloadButton.addTarget(self, action: #selector(downloadButtonAction), for: .touchUpInside)
    
    let yDeleteAndShareButtons = barView.bounds.maxY - 14 - barViewSize.height / 2
    shareButton.frame = CGRect(x: 8,
                               y: yDeleteAndShareButtons,
                               width: 28, height: 28)
    barView.addSubview(shareButton)
    shareButton.addTarget(self, action: #selector(shareButtonAction), for: .touchUpInside)
    
    deleteButton.frame = CGRect(x: barView.bounds.maxX - 8 - 28,
                                y: yDeleteAndShareButtons,
                                width: 28,
                                height: 28)
    barView.addSubview(deleteButton)
    deleteButton.addTarget(self, action: #selector(deleteButtonAction), for: .touchUpInside)
  }
  
  @objc fileprivate func downloadButtonAction() {
    guard let delegate = delegate else {return}
    delegate.didDownloadButtnTapped()
  }
  
  @objc fileprivate func shareButtonAction() {
    guard let delegate = delegate else {return}
    delegate.didShareButtnTapped()
  }
  
  @objc fileprivate func deleteButtonAction() {
    
    guard let delegate = delegate else {return}
    delegate.didDeleteButtonTapped()
  }
  
}
